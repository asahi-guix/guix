;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2016, 2017, 2019–2021 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2017 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2019 Guillaume Le Vaillant <glv@posteo.net>
;;; Copyright © 2020, 2022 Maxim Cournoyer <maxim.cournoyer@gmail.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu build linux-boot)
  #:use-module (rnrs io ports)
  #:use-module (system repl error-handling)
  #:autoload   (system repl repl) (start-repl)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 match)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 ftw)
  #:use-module (guix build utils)
  #:use-module ((guix build syscalls)
                #:hide (file-system-type))
  #:use-module (gnu build linux-modules)
  #:use-module (gnu build file-systems)
  #:use-module (gnu system file-systems)
  #:export (mount-essential-file-systems
            linux-command-line
            find-long-option
            find-long-options
            make-essential-device-nodes
            make-static-device-nodes
            configure-qemu-networking

            boot-system))

;;; Commentary:
;;;
;;; Utility procedures useful in a Linux initial RAM disk (initrd).  Note that
;;; many of these use procedures not yet available in vanilla Guile (`mount',
;;; `load-linux-module', etc.); these are provided by a Guile patch used in
;;; the GNU distribution.
;;;
;;; Code:

(define* (mount-essential-file-systems #:key (root "/"))
  "Mount /dev, /proc, and /sys under ROOT."
  (define (scope dir)
    (string-append root
                   (if (string-suffix? "/" root)
                       ""
                       "/")
                   dir))

  (unless (file-exists? (scope "proc"))
    (mkdir (scope "proc")))
  (mount "none" (scope "proc") "proc")

  (unless (file-exists? (scope "dev"))
    (mkdir (scope "dev")))
  (mount "none" (scope "dev") "devtmpfs")

  (unless (file-exists? (scope "sys"))
    (mkdir (scope "sys")))
  (mount "none" (scope "sys") "sysfs"))

(define (move-essential-file-systems root)
  "Move currently mounted essential file systems to ROOT."
  (for-each (lambda (dir)
              (let ((target (string-append root dir)))
                (unless (file-exists? target)
                  (mkdir target))
                (mount dir target "" MS_MOVE)))
            '("/dev" "/proc" "/sys")))

(define (linux-command-line)
  "Return the Linux kernel command line as a list of strings."
  (string-tokenize
   (call-with-input-file "/proc/cmdline"
     get-string-all)))

(define (find-long-option option arguments)
  "Find OPTION among ARGUMENTS, where OPTION is something like \"gnu.load\".
Return the value associated with OPTION, or #f on failure."
  (let ((opt (string-append option "=")))
    (and=> (find (cut string-prefix? opt <>)
                 arguments)
           (lambda (arg)
             (substring arg (+ 1 (string-index arg #\=)))))))

(define (find-long-options option arguments)
  "Find OPTIONs among ARGUMENTS, where OPTION is something like \"console\".
Return the values associated with OPTIONs as a list, or the empty list if
OPTION doesn't appear in ARGUMENTS."
  (let ((opt (string-append option "=")))
    (filter-map (lambda (arg)
                  (and (string-prefix? opt arg)
                       (substring arg (+ 1 (string-index arg #\=)))))
                arguments)))

(define (resume-if-hibernated device)
  "Resume from hibernation if possible.  This is safe ONLY if no on-disk file
systems have been mounted; calling it later risks severe file system corruption!
See <Documentation/swsusp.txt> in the kernel source directory.  This is the
caller's responsibility, as is catching exceptions if resumption was supposed to
happen but didn't.

Resume only from DEVICE if it's a string.  If it's #f, use the kernel's default
hibernation device (CONFIG_PM_STD_PARTITION).  Never return if resumption
succeeds.  Return nothing otherwise.  The kernel logs any details to dmesg."

  (define (string->major:minor string)
    "Return a string with MAJOR:MINOR numbers of the device specified by STRING"

    ;; The "resume=" kernel command-line option always provides a string, which
    ;; can represent a device, a UUID, or a label.  Check for all three.
    (let* ((spec (cond ((string-prefix? "/" string) string)
                       ((uuid string) => identity)
                       (else (file-system-label string))))
           ;; XXX The kernel's swsusp_resume_can_resume() waits if ‘resumewait’
           ;; is found on the command line; our canonicalize-device-spec gives
           ;; up after 20 seconds.  We could emulate the former by looping…
           (device (canonicalize-device-spec spec))
           (rdev (stat:rdev (stat device))))
      (let-values (((major minor) (device-number->major+minor rdev)))
        (format #f "~a:~a" major minor))))

  ;; Write the resume DEVICE to this magic file, using the MAJOR:MINOR device
  ;; numbers if possible.  The kernel will immediately try to resume from it.
  (let ((resume "/sys/power/resume"))
    (when (file-exists? resume)         ; this kernel supports hibernation
      ;; Honour the kernel's default device (only) if none other was given.
      (let ((major:minor (if device
                             (or (false-if-exception (string->major:minor
                                                      device))
                                 ;; We can't parse it.  Maybe the kernel can.
                                 device)
                             (let ((default (call-with-input-file resume
                                              read-line)))
                               ;; Don't waste time echoing 0:0 to /sys.
                               (if (string=? "0:0" default)
                                   #f
                                   default)))))
        (when major:minor
          (call-with-output-file resume ; may throw an ‘Invalid argument’
            (cut display major:minor <>))))))) ; may never return

(define* (make-disk-device-nodes base major #:optional (minor 0))
  "Make the block device nodes around BASE (something like \"/root/dev/sda\")
with the given MAJOR number, starting with MINOR."
  (mknod base 'block-special #o644 (device-number major minor))
  (let loop ((i 1))
    (when (< i 16)
      (mknod (string-append base (number->string i))
             'block-special #o644 (device-number major (+ minor i)))
      (loop (+ i 1)))))

;; Representation of a /dev node.
(define-record-type <device-node>
  (device-node name type major minor module)
  device-node?
  (name device-node-name)
  (type device-node-type)
  (major device-node-major)
  (minor device-node-minor)
  (module device-node-module))

(define (read-static-device-nodes port)
  "Read from PORT a list of <device-node> written in the format used by
/lib/modules/*/*.devname files."
  (let loop ((line (read-line port)))
    (if (eof-object? line)
      '()
      (match (string-split line #\space)
       (((? (cut string-prefix? "#" <>)) _ ...)
        (loop (read-line port)))
       ((module-name device-name device-spec)
        (let* ((device-parts
               (string-match "([bc])([0-9][0-9]*):([0-9][0-9]*)"
                             device-spec))
               (type-string (match:substring device-parts 1))
               (type (match type-string
                      ("c" 'char-special)
                      ("b" 'block-special)))
               (major-string (match:substring device-parts 2))
               (major (string->number major-string 10))
               (minor-string (match:substring device-parts 3))
               (minor (string->number minor-string 10)))
          (cons (device-node device-name type major minor module-name)
                (loop (read-line port)))))
       (_
        (begin
          (format (current-error-port)
                  "read-static-device-nodes: ignored devname line '~a'~%" line)
          (loop (read-line port))))))))

(define* (mkdir-p* dir #:optional (mode #o755))
  "This is a variant of 'mkdir-p' that works around
<http://bugs.gnu.org/24659> by passing MODE explicitly in each 'mkdir' call."
  (define absolute?
    (string-prefix? "/" dir))

  (define not-slash
    (char-set-complement (char-set #\/)))

  (let loop ((components (string-tokenize dir not-slash))
             (root       (if absolute?
                             ""
                             ".")))
    (match components
      ((head tail ...)
       (let ((path (string-append root "/" head)))
         (catch 'system-error
           (lambda ()
             (mkdir path mode)
             (loop tail path))
           (lambda args
             (if (= EEXIST (system-error-errno args))
                 (loop tail path)
                 (apply throw args))))))
      (() #t))))

(define (report-system-error name . args)
  "Report a system error for the file NAME."
  (let ((errno (system-error-errno args)))
    (format (current-error-port) "could not create '~a': ~a~%" name
            (strerror errno))))

;; Catch a system-error, log it and don't die from it.
(define-syntax-rule (catch-system-error name exp)
  (catch 'system-error
    (lambda ()
      exp)
    (lambda args
      (apply report-system-error name args))))

;; Create a device node like the <device-node> passed here on the file system.
(define create-device-node
  (match-lambda
    (($ <device-node> xname type major minor module)
     (let ((name (string-append "/dev/" xname)))
       (mkdir-p* (dirname name))
       (catch-system-error name
         (mknod name type #o600 (device-number major minor)))))))

(define* (make-static-device-nodes linux-release-module-directory)
  "Create static device nodes required by the given Linux release.
This is required in order to solve a chicken-or-egg problem:
The Linux kernel has a feature to autoload modules when a device is first
accessed.
And udev has a feature to set the permissions of static nodes correctly
when it is starting up and also to automatically create nodes when hardware
is hotplugged. That leaves universal device files which are not linked to
one specific hardware device. These we have to create."
  (let ((devname-name (string-append linux-release-module-directory "/"
                                     "modules.devname")))
    (for-each create-device-node
              (call-with-input-file devname-name
                                    read-static-device-nodes))))

(define* (make-essential-device-nodes #:optional (root "/"))
  "Make essential device nodes under ROOT/dev."
  ;; The hand-made devtmpfs/udev!

  (define (scope dir)
    (string-append root
                   (if (string-suffix? "/" root)
                       ""
                       "/")
                   dir))

  (unless (file-exists? (scope "dev"))
    (mkdir (scope "dev")))

  ;; Make the device nodes for SCSI disks.
  (make-disk-device-nodes (scope "dev/sda") 8)
  (make-disk-device-nodes (scope "dev/sdb") 8 16)
  (make-disk-device-nodes (scope "dev/sdc") 8 32)
  (make-disk-device-nodes (scope "dev/sdd") 8 48)

  ;; SCSI CD-ROM devices (aka. "/dev/sr0" etc.).
  (mknod (scope "dev/scd0") 'block-special #o644 (device-number 11 0))
  (mknod (scope "dev/scd1") 'block-special #o644 (device-number 11 1))

  ;; The virtio (para-virtualized) block devices, as supported by QEMU/KVM.
  (make-disk-device-nodes (scope "dev/vda") 252)

  ;; Memory (used by Xorg's VESA driver.)
  (mknod (scope "dev/mem") 'char-special #o640 (device-number 1 1))
  (mknod (scope "dev/kmem") 'char-special #o640 (device-number 1 2))

  ;; Inputs (used by Xorg.)
  (unless (file-exists? (scope "dev/input"))
    (mkdir (scope "dev/input")))
  (mknod (scope "dev/input/mice") 'char-special #o640 (device-number 13 63))
  (mknod (scope "dev/input/mouse0") 'char-special #o640 (device-number 13 32))
  (mknod (scope "dev/input/event0") 'char-special #o640 (device-number 13 64))

  ;; System console.  This node is magically created by the kernel on the
  ;; initrd's root, so don't try to create it in that case.
  (unless (string=? root "/")
    (mknod (scope "dev/console") 'char-special #o600
           (device-number 5 1)))

  ;; TTYs.
  (mknod (scope "dev/tty") 'char-special #o600
         (device-number 5 0))
  (chmod (scope "dev/tty") #o666)
  (let loop ((n 0))
    (and (< n 50)
         (let ((name (format #f "dev/tty~a" n)))
           (mknod (scope name) 'char-special #o600
                  (device-number 4 n))
           (loop (+ 1 n)))))

  ;; Serial line.
  (mknod (scope "dev/ttyS0") 'char-special #o660
         (device-number 4 64))

  ;; Pseudo ttys.
  (mknod (scope "dev/ptmx") 'char-special #o666
         (device-number 5 2))
  (chmod (scope "dev/ptmx") #o666)

  ;; Create /dev/pts; it will be mounted later, at boot time.
  (unless (file-exists? (scope "dev/pts"))
    (mkdir (scope "dev/pts")))

  ;; Rendez-vous point for syslogd.
  (mknod (scope "dev/log") 'socket #o666 0)
  (mknod (scope "dev/kmsg") 'char-special #o600 (device-number 1 11))

  ;; Other useful nodes, notably relied on by guix-daemon.
  (for-each (match-lambda
             ((file major minor)
              (mknod (scope file) 'char-special #o666
                     (device-number major minor))
              (chmod (scope file) #o666)))
            '(("dev/null" 1 3)
              ("dev/zero" 1 5)
              ("dev/full" 1 7)
              ("dev/random" 1 8)
              ("dev/urandom" 1 9)))

  (symlink "/proc/self/fd" (scope "dev/fd"))
  (symlink "/proc/self/fd/0" (scope "dev/stdin"))
  (symlink "/proc/self/fd/1" (scope "dev/stdout"))
  (symlink "/proc/self/fd/2" (scope "dev/stderr"))

  ;; Loopback devices.
  (let loop ((i 0))
    (when (< i 8)
      (mknod (scope (string-append "dev/loop" (number->string i)))
             'block-special #o660
             (device-number 7 i))
      (loop (+ 1 i))))

  ;; File systems in user space (FUSE).
  (mknod (scope "dev/fuse") 'char-special #o666 (device-number 10 229)))

(define %host-qemu-ipv4-address
  (inet-pton AF_INET "10.0.2.10"))

(define* (configure-qemu-networking #:optional (interface "eth0"))
  "Setup the INTERFACE network interface and /etc/resolv.conf according to
QEMU's default networking settings (see net/slirp.c in QEMU for default
networking values.)  Return #t if INTERFACE is up, #f otherwise."
  (display "configuring QEMU networking...\n")
  (let* ((sock    (socket AF_INET SOCK_STREAM 0))
         (address (make-socket-address AF_INET %host-qemu-ipv4-address 0))
         (flags   (network-interface-flags sock interface)))
    (set-network-interface-address sock interface address)
    (set-network-interface-flags sock interface (logior flags IFF_UP))

    (logand (network-interface-flags sock interface) IFF_UP)))

(define (pidof program)
  "Return the PID of the first presumed instance of PROGRAM."
  (let ((program (basename program)))
    (find (lambda (pid)
            (let ((exe (format #f "/proc/~a/exe" pid)))
              (and=> (false-if-exception (readlink exe))
                     (compose (cut string=? program <>) basename))))
          (filter-map string->number (scandir "/proc")))))

(define* (mount-root-file-system root type
                                 #:key volatile-root? (flags 0) options
                                 check? skip-check-if-clean? repair)
  "Mount the root file system of type TYPE at device ROOT. If VOLATILE-ROOT? is
true, mount ROOT read-only and make it an overlay with a writable tmpfs using
the kernel built-in overlayfs. FLAGS and OPTIONS indicates the options to use
to mount ROOT, and behave the same as for the `mount' procedure.

If CHECK? is true, first run ROOT's fsck tool (if any) non-interactively.
If SKIP-CHECK-IF-CLEAN? is true, ask fsck to return immediately if ROOT is
marked as clean.  If REPAIR is true, fsck may write to ROOT to perform repairs.
If REPAIR is also 'PREEN, ask fsck to perform only those repairs that it
considers safe."

  (if volatile-root?
      (begin
        (mkdir-p "/real-root")
        (mount root "/real-root" type (logior MS_RDONLY flags) options)
        (mkdir-p "/rw-root")
        (mount "none" "/rw-root" "tmpfs")

        ;; Create the upperdir and the workdir of the overlayfs
        (mkdir-p "/rw-root/upper")
        (mkdir-p "/rw-root/work")

        ;; We want read-write /dev nodes.
        (mkdir-p "/rw-root/upper/dev")
        (mount "none" "/rw-root/upper/dev" "devtmpfs")

        ;; Make /root an overlay of the tmpfs and the actual root.
        (mount "none" "/root" "overlay" 0
               "lowerdir=/real-root,upperdir=/rw-root/upper,workdir=/rw-root/work"))
      (begin
        (when check?
          (check-file-system root type (not skip-check-if-clean?) repair))
        (mount root "/root" type flags options)))

  ;; Make sure /root/etc/mtab is a symlink to /proc/self/mounts.
  (false-if-exception
    (delete-file "/root/etc/mtab"))
  (mkdir-p "/root/etc")
  (symlink "/proc/self/mounts" "/root/etc/mtab"))

(define (switch-root root)
  "Switch to ROOT as the root file system, in a way similar to what
util-linux' switch_root(8) does."
  (move-essential-file-systems root)
  (chdir root)

  ;; Since we're about to 'rm -rf /', try to make sure we're on an initrd.
  ;; TODO: Use 'statfs' to check the fs type, like klibc does.
  (when (or (not (file-exists? "/init")) (directory-exists? "/home"))
    (format (current-error-port)
            "The root file system is probably not an initrd; \
bailing out.~%root contents: ~s~%" (scandir "/"))
    (force-output (current-error-port))
    (exit 1))

  ;; Delete files from the old root, without crossing mount points (assuming
  ;; there are no mount points in sub-directories.)  That means we're leaving
  ;; the empty ROOT directory behind us, but that's OK.
  (let ((root-device (stat:dev (stat "/"))))
    (for-each (lambda (file)
                (unless (member file '("." ".."))
                  (let* ((file   (string-append "/" file))
                         (device (stat:dev (lstat file))))
                    (when (= device root-device)
                      (delete-file-recursively file)))))
              (scandir "/")))

  ;; Make ROOT the new root.
  (mount root "/" "" MS_MOVE)
  (chroot ".")
  (chdir "/")

  (when (file-exists? "/dev/console")
    ;; Close the standard file descriptors since they refer to the old
    ;; /dev/console, and reopen them.
    (let ((console (open-file "/dev/console" "r+b0")))
      (for-each close-fdes '(0 1 2))

      (dup2 (fileno console) 0)
      (dup2 (fileno console) 1)
      (dup2 (fileno console) 2)

      (close-port console))))


(define* (boot-system #:key
                      (linux-modules '())
                      linux-module-directory
                      keymap-file
                      qemu-guest-networking?
                      volatile-root?
                      pre-mount
                      (mounts '())
                      (on-error 'debug))
  "This procedure is meant to be called from an initrd.  Boot a system by
first loading LINUX-MODULES (a list of module names) from
LINUX-MODULE-DIRECTORY, then installing KEYMAP-FILE with 'loadkeys' (if
KEYMAP-FILE is true), then setting up QEMU guest networking if
QEMU-GUEST-NETWORKING? is true, calling PRE-MOUNT, mounting the file systems
specified in MOUNTS, and finally booting into the new root if any.  The initrd
supports the kernel command-line options 'gnu.load' and 'gnu.repl'.  It also
honors a subset of the Linux kernel command-line parameters such as
'fsck.mode', 'resume', 'rootdelay', rootflags and rootfstype.

Mount the root file system, specified by the 'root' command-line argument, if
any.

MOUNTS must be a list of <file-system> objects.

When VOLATILE-ROOT? is true, the root file system is writable but any changes
to it are lost.

ON-ERROR is passed to 'call-with-error-handling'; it determines what happens
upon error."
  (define (root-mount-point? fs)
    (string=? (file-system-mount-point fs) "/"))

  (define (device-string->file-system-device device-string)
    ;; The "root=SPEC" kernel command-line option always provides a string,
    ;; but the string can represent a device, an nfs-root, a UUID, or a label.
    ;; So check for all four.
    (cond ((string-prefix? "/" device-string) device-string)
          ((string-contains device-string ":/") device-string) ; nfs-root
          ((uuid device-string) => identity)
          (else (file-system-label device-string))))

  (display "Welcome, this is GNU's early boot Guile.\n")
  (display "Use 'gnu.repl' for an initrd REPL.\n\n")

  (call-with-error-handling
    (lambda ()
      (mount-essential-file-systems)
      (let* ((args    (linux-command-line))
             (to-load (find-long-option "gnu.load" args))
             ;; If present, ‘root’ on the kernel command line takes precedence
             ;; over the ‘device’ field of the root <file-system> record.
             (root-device (and=> (find-long-option "root" args)
                                 device-string->file-system-device))
             (rootfstype  (find-long-option "rootfstype" args))
             (rootflags   (find-long-option "rootflags" args))
             (root-fs*    (find root-mount-point? mounts))
             (fsck.mode (find-long-option "fsck.mode" args)))

        (unless (or root-fs* (and root-device rootfstype))
          (error "no root file system or 'root' and 'rootfstype' parameters"))

        ;; If present, ‘root’ on the kernel command line takes precedence over
        ;; the ‘device’ field of the root <file-system> record; likewise for
        ;; the 'rootfstype' and 'rootflags' arguments.
        (define root-fs
          (if root-fs*
              (file-system
                (inherit root-fs*)
                (device (or root-device (file-system-device root-fs*)))
                (type (or rootfstype (file-system-type root-fs*)))
                (options (or rootflags (file-system-options root-fs*))))
              (file-system
                (device root-device)
                (mount-point "/")
                (type rootfstype)
                (options rootflags))))

        (define (check? fs)
          (match fsck.mode
            ("skip"  #f)
            ("force" #t)
            (_ (file-system-check? fs)))) ; assume "auto"

        (define (skip-check-if-clean? fs)
          (match fsck.mode
            ("force" #f)
            (_ (file-system-skip-check-if-clean? fs))))

        (define (repair fs)
          (let ((arg (find-long-option "fsck.repair" args)))
            (if arg
                (match arg
                  ("no"  #f)
                  ("yes" #t)
                  (_ 'preen))
                (file-system-repair fs))))

        (when (member "gnu.repl" args)
          (start-repl))

        (display "loading kernel modules...\n")
        (load-linux-modules-from-directory linux-modules
                                           linux-module-directory)

        (when keymap-file
          (let ((status (system* "loadkeys" keymap-file)))
            (unless (zero? status)
              ;; Emit a warning rather than abort when we cannot load
              ;; KEYMAP-FILE.
              (format (current-error-port)
                      "warning: 'loadkeys' exited with status ~a~%"
                      status))))

        (when qemu-guest-networking?
          (unless (configure-qemu-networking)
            (display "network interface is DOWN\n")))

        ;; A big ugly hammer, to be used only for debugging and in desperate
        ;; situations where no proper device synchonisation is possible.
        (let ((root-delay (and=> (find-long-option "rootdelay" args)
                                 string->number)))
          (when root-delay
            (format #t "Pausing for rootdelay=~a seconds before mounting \
the root file system...\n" root-delay)
            (sleep root-delay)))

        (when (procedure? pre-mount)
          ;; Do whatever actions are needed before mounting the root file
          ;; system--e.g., installing device mappings.  Error out when the
          ;; return value is false.
          (unless (pre-mount)
            (error "pre-mount actions failed")))

        (unless (or (member "hibernate=noresume" args)
                    ;; Also handle the equivalent old-style argument.
                    ;; See Documentation/admin-guide/kernel-parameters.txt.
                    (member "noresume" args))
          ;; Try to resume immediately after loading (storage) modules
          ;; but before any on-disk file systems have been mounted.
          (false-if-exception           ; failure is not fatal
           (resume-if-hibernated (find-long-option "resume" args))))

        ;; Prepare the real root file system under /root.
        (unless (file-exists? "/root")
          (mkdir "/root"))

        (setenv "EXT2FS_NO_MTAB_OK" "1")

        ;; Mount the root file system.
        (mount-root-file-system (canonicalize-device-spec
                                 (file-system-device root-fs))
                                (file-system-type root-fs)
                                #:volatile-root? volatile-root?
                                #:flags (mount-flags->bit-mask
                                         (file-system-flags root-fs))
                                #:options (file-system-options root-fs)
                                #:check? (check? root-fs)
                                #:skip-check-if-clean?
                                (skip-check-if-clean? root-fs)
                                #:repair (repair root-fs))

        ;; Mount the specified non-root file systems.
        (for-each (lambda (fs)
                    (mount-file-system fs
                                       #:check? (check? fs)
                                       #:skip-check-if-clean?
                                       (skip-check-if-clean? fs)
                                       #:repair (repair fs)))
                  (remove root-mount-point? mounts))

        (setenv "EXT2FS_NO_MTAB_OK" #f)

        (if to-load
            (begin
              (switch-root "/root")
              (format #t "loading '~a'...\n" to-load)

              (primitive-load to-load)

              (format (current-error-port)
                      "boot program '~a' terminated, rebooting~%"
                      to-load)
              (sleep 2)
              (reboot))
            (begin
              (display "no boot file passed via 'gnu.load'\n")
              (display "entering a warm and cozy REPL\n")
              (start-repl)))))
    #:on-error on-error))

;;; linux-boot.scm ends here
