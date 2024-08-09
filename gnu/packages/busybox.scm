;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014 John Darrington <jmd@gnu.org>
;;; Copyright © 2016-2020, 2023 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2018–2022 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2022 LuHui <luhux76@gmail.com>
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

(define-module (gnu packages busybox)
  #:use-module (guix gexp)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages perl))

(define-public busybox
  (package
    (name "busybox")
    (version "1.36.1")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://www.busybox.net/downloads/" name "-"
                    version ".tar.bz2"))
              (sha256
               (base32
                "0573gpj51phcz04sg77iznvcxmf5jnbk9gn3g5r9x02daz4j9k5q"))))
    (build-system gnu-build-system)
    (arguments
     (list #:phases
           #~(modify-phases %standard-phases
               (add-before 'configure 'disable-timestamps
                 (lambda _
                   (setenv "KCONFIG_NOTIMESTAMP" "1")))
               (add-before 'configure 'disable-taskset
                 ;; This feature fails its tests in the build environment,
                 ;; was default 'n' until after 1.26.2.
                 (lambda _
                   (substitute* "util-linux/taskset.c"
                     (("default y") "default n"))))
               (replace 'configure
                 (lambda* (#:key make-flags #:allow-other-keys)
                   (apply invoke "make" "defconfig" make-flags)))
               (add-after 'configure 'dont-install-to-usr
                 (lambda _
                   (substitute* ".config"
                     (("# CONFIG_INSTALL_NO_USR is not set")
                      "CONFIG_INSTALL_NO_USR=y"))))
               (replace 'check
                 (lambda* (#:key tests? make-flags #:allow-other-keys)
                   (substitute* '("testsuite/du/du-s-works"
                                  "testsuite/du/du-works")
                     (("/bin") "/etc")) ; there is no /bin but there is a /etc

                   ;; There is no /usr/bin or /bin - replace it with
                   ;; /gnu/store.
                   (substitute* "testsuite/cpio.tests"
                     (("/usr/bin") (%store-directory))
                     (("usr") (car (filter (negate string-null?)
                                           (string-split (%store-directory) #\/)))))

                   (substitute* "testsuite/date/date-works-1"
                     (("/bin/date") (which "date")))

                   (substitute* "testsuite/start-stop-daemon.tests"
                     (("/bin/false") (which "false")))

                   ;; The pidof tests assume that pid 1 is called "init" but
                   ;; that is not true in guix build environment
                   (substitute* "testsuite/pidof.tests"
                     (("-s init") "-s $(cat /proc/1/comm)"))

                   ;; This test cannot possibly pass.  It is trying to test
                   ;; that "which ls" returns "/bin/ls" when PATH is not set.
                   ;; However, this relies on /bin/ls existing.  Which it does
                   ;; not in guix.
                   (delete-file "testsuite/which/which-uses-default-path")
                   (rmdir "testsuite/which")

                   (when tests?
                     (apply invoke "make"
                            ;; "V=1"
                            "SKIP_KNOWN_BUGS=1"
                            "SKIP_INTERNET_TESTS=1"
                            "check" make-flags))))
               (replace 'install
                 (lambda* (#:key outputs make-flags #:allow-other-keys)
                   (let ((out (assoc-ref outputs "out")))
                     (apply invoke "make"
                            (string-append "CONFIG_PREFIX=" out)
                            "install" make-flags)))))
           #:make-flags
           #~(let ((target #$(%current-target-system)))
               (if target
                   (list (string-append "CROSS_COMPILE=" target "-"))
                   '()))))
    (native-inputs (list perl     ; needed to generate the man pages (pod2man)
                         ;; The following are needed by the tests.
                         inetutils
                         (@ (gnu packages base) which)
                         zip))
    (synopsis "Many common UNIX utilities in a single executable")
    (description "BusyBox combines tiny versions of many common UNIX utilities
into a single small executable.  It provides a fairly complete environment for
any small or embedded system.")
    (home-page "https://www.busybox.net")
    ;; Some files are gplv2+
    (license gpl2)))

(define-public toybox
  (package
    (name "toybox")
    (version "0.8.7")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://landley.net/toybox/downloads/toybox-"
                    version ".tar.gz"))
              (sha256
               (base32
                "150lvp7hf9ndafvmr42kb8xi86hxjd2zj4binwwhgjw2dwrvy25m"))))
    (build-system gnu-build-system)
    (arguments
     (list #:make-flags
           #~(list (string-append "CC=" #$(cc-for-target))
                   (string-append "HOSTCC=gcc")
                   (string-append "PREFIX=" #$output))
           #:phases
           #~(modify-phases %standard-phases
               (replace 'configure
                 (lambda* (#:key make-flags #:allow-other-keys)
                   (apply invoke "make" "defconfig" make-flags)))
               (add-before 'check 'fix-or-skip-broken-tests
                 (lambda _
                   ;; Some tests expect $USER to magically be the current user.
                   (setenv "USER" (passwd:name (getpwnam (geteuid))))
                   ;; This expects directories to be exactly 4K.  They aren't!
                   (delete-file "tests/du.test")
                   ;; Delete tests that expect a root or 0 user to exist.
                   (substitute* "tests/id.test"
                     (("^testing .*[ \\(]root.*") ""))))
               (add-after 'install 'remove-usr-directory
                 (lambda* (#:key outputs #:allow-other-keys)
                   (delete-file-recursively (string-append #$output "/usr")))))
           #:test-target "tests"))
    (native-inputs (list bc))
    (inputs (list libxcrypt))
    (synopsis "Many common UNIX utilities in a single executable")
    (description "ToyBox combines tiny versions of many common UNIX utilities
into a single small executable.  It provides a fairly complete environment for
any small or embedded system.")
    (home-page "https://landley.net/toybox/")
    (license bsd-2)))
