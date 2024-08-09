;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016, 2017, 2018 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2019, 2020, 2022 Marius Bakke <marius@gnu.org>
;;; Copyright © 2021 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2021 Guillaume Le Vaillant <glv@posteo.net>
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

(define-module (gnu packages selinux)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages xml))

;; Update the SELinux packages together!

(define-public libsepol
  (package
    (name "libsepol")
    (version "3.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/SELinuxProject/selinux")
                    (commit version)))
              (file-name (git-file-name "selinux" version))
              (sha256
               (base32
                "1lcmgmfr0q7g5cwg6b7jm6ncw8cw6c1jblkm93v1g37bfhcgrqc0"))
              (patches (search-patches "libsepol-versioned-docbook.patch"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f         ; tests require checkpolicy, which requires libsepol
      #:test-target "test"
      #:make-flags
      #~(let ((out #$output))
          (list (string-append "PREFIX=" out)
                (string-append "SHLIBDIR=" out "/lib")
                (string-append "MAN3DIR=" out "/share/man/man3")
                (string-append "MAN5DIR=" out "/share/man/man5")
                (string-append "MAN8DIR=" out "/share/man/man8")
                (string-append "CFLAGS=-Wno-error")
                (string-append "LDFLAGS=-Wl,-rpath=" out "/lib")
                (string-append "CC=" #$(cc-for-target))))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (add-after 'unpack 'enter-dir
            (lambda _ (chdir #$name)))
          (add-after 'enter-dir 'portability
            (lambda _
              (substitute* "src/ibpkeys.c"
                (("#include \"ibpkey_internal.h\"" line)
                 (string-append line "\n#include <inttypes.h>\n"))
                (("%#lx") "%#\" PRIx64 \"")))))))
    (native-inputs
     (list flex))
    (home-page "https://selinuxproject.org/")
    (synopsis "Library for manipulating SELinux policies")
    (description
     "The libsepol library provides an API for the manipulation of SELinux
binary policies.  It is used by @code{checkpolicy} (the policy compiler) and
similar tools, and programs such as @code{load_policy}, which must perform
specific transformations on binary policies (for example, customizing policy
boolean settings).")
    (license license:lgpl2.1+)))

(define-public checkpolicy
  (package/inherit libsepol
    (name "checkpolicy")
    (arguments
     (list
      #:tests? #f                       ; there is no check target
      #:make-flags
      #~(list (string-append "PREFIX=" #$output)
              (string-append "LIBSEPOLA="
                             (search-input-file %build-inputs
                                                "/lib/libsepol.a"))
              (string-append "CC=" #$(cc-for-target)))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'portability)
          (add-after 'unpack 'enter-dir
            (lambda _ (chdir #$name))))))
    (inputs
     (list libsepol))
    (native-inputs
     (list bison flex))
    (synopsis "Check SELinux security policy configurations and modules")
    (description
     "This package provides the tools \"checkpolicy\" and \"checkmodule\".
Checkpolicy is a program that checks and compiles a SELinux security policy
configuration into a binary representation that can be loaded into the kernel.
Checkmodule is a program that checks and compiles a SELinux security policy
module into a binary representation.")
    ;; GPLv2 only
    (license license:gpl2)))

(define-public libselinux
  (package/inherit libsepol
    (name "libselinux")
    (outputs '("out" "python"))
    (arguments
     (substitute-keyword-arguments (package-arguments libsepol)
       ((#:make-flags flags)
        #~(cons* "PYTHON=python3"
                 (string-append "LIBSEPOLA="
                                (search-input-file %build-inputs
                                                   "/lib/libsepol.a"))
                 (string-append "PYTHONLIBDIR="
                                #$output:python
                                "/lib/python"
                                #$(version-major+minor (package-version python))
                                "/site-packages/")
                 #$flags))
       ((#:phases phases)
        #~(modify-phases #$phases
            (delete 'portability)
            (replace 'enter-dir
              (lambda _ (chdir #$name)))
            (add-after 'build 'pywrap
              (lambda* (#:key make-flags #:allow-other-keys)
                (apply invoke "make" "pywrap" make-flags)))
            (add-after 'install 'install-pywrap
              (lambda* (#:key make-flags #:allow-other-keys)
                ;; The build system uses "python setup.py install" to install
                ;; Python bindings.  Instruct it to use the correct output.
                (substitute* "src/Makefile"
                  (("--prefix=\\$\\(PREFIX\\)")
                   (string-append "--prefix=" #$output:python
                                  ;; Python 3.10 refuses to execute the install
                                  ;; command unless these flags are present.
                                  " --single-version-externally-managed"
                                  " --root=/")))

                (apply invoke "make" "install-pywrap" make-flags)))))))
    ;; These libraries are in "Requires.private" in libselinux.pc.
    (propagated-inputs
     (list libsepol pcre2))
    ;; For pywrap phase
    (inputs
     (list python-wrapper))
    ;; These inputs are only needed for the pywrap phase.
    (native-inputs
     (list pkg-config swig))
    (synopsis "SELinux core libraries and utilities")
    (description
     "The libselinux library provides an API for SELinux applications to get
and set process and file security contexts, and to obtain security policy
decisions.  It is required for any applications that use the SELinux API, and
used by all applications that are SELinux-aware.  This package also includes
the core SELinux management utilities.")
    (license license:public-domain)))

(define-public libsemanage
  (package/inherit libsepol
    (name "libsemanage")
    (arguments
     (substitute-keyword-arguments (package-arguments libsepol)
       ((#:make-flags flags)
        #~(cons* "PYTHON=python3"
                 (string-append "PYTHONLIBDIR="
                                #$output
                                "/lib/python"
                                #$(version-major+minor (package-version python))
                                "/site-packages/")
                 #$flags))
       ((#:phases phases)
        #~(modify-phases #$phases
            (delete 'portability)
            (replace 'enter-dir
              (lambda _ (chdir #$name)))
            (add-before 'install 'adjust-semanage-conf-location
              (lambda _
                (substitute* "src/Makefile"
                  (("DEFAULT_SEMANAGE_CONF_LOCATION=/etc")
                   "DEFAULT_SEMANAGE_CONF_LOCATION=$(PREFIX)/etc"))))
            (add-after 'build 'pywrap
              (lambda* (#:key make-flags #:allow-other-keys)
                (apply invoke "make" "pywrap" make-flags)))
            (add-after 'install 'install-pywrap
              (lambda* (#:key make-flags #:allow-other-keys)
                (apply invoke "make" "install-pywrap" make-flags)))))))
    (inputs
     (list audit libsepol libselinux python-wrapper))
    (native-inputs
     (list bison flex pkg-config swig))
    (synopsis "SELinux policy management libraries")
    (description
     "The libsemanage library provides an API for the manipulation of SELinux
binary policies.")
    (license license:lgpl2.1+)))

(define-public secilc
  (package/inherit libsepol
    (name "secilc")
    (arguments
     (substitute-keyword-arguments (package-arguments libsepol)
       ((#:phases phases)
        #~(modify-phases #$phases
            (delete 'portability)
            (replace 'enter-dir
              (lambda _ (chdir #$name)))))))
    (inputs
     (list libsepol))
    (native-inputs
     (list docbook-xml-4.2 docbook-xsl xmlto))
    (synopsis "SELinux common intermediate language (CIL) compiler")
    (description "The SELinux CIL compiler is a compiler that converts the
@dfn{common intermediate language} (CIL) into a kernel binary policy file.")
    (license license:bsd-2)))

(define-public python-sepolgen
  (package/inherit libsepol
    (name "python-sepolgen")
    (arguments
     (substitute-keyword-arguments (package-arguments libsepol)
       ((#:modules _ #~%default-gnu-modules)
        '((srfi srfi-1)
          (guix build gnu-build-system)
          (guix build utils)))
       ((#:phases phases)
        #~(modify-phases #$phases
            (delete 'portability)
            (replace 'enter-dir
              (lambda _ (chdir "python/sepolgen")))
            ;; By default all Python files would be installed to
            ;; $out/gnu/store/...-python-.../, so we override the
            ;; PACKAGEDIR to fix this.
            (add-after 'enter-dir 'fix-target-path
              (lambda* (#:key inputs #:allow-other-keys)
                (let ((get-python-version
                       ;; FIXME: copied from python-build-system
                       (lambda (python)
                         (let* ((version     (last (string-split python #\-)))
                                (components  (string-split version #\.))
                                (major+minor (take components 2)))
                           (string-join major+minor "."))))
                      (python (dirname (dirname (search-input-file
                                                 inputs "bin/python3")))))
                  (substitute* "src/sepolgen/Makefile"
                    (("^PACKAGEDIR.*")
                     (string-append "PACKAGEDIR="
                                    #$output
                                    "/lib/python"
                                    (get-python-version python)
                                    "/site-packages/sepolgen")))
                  (substitute* "src/share/Makefile"
                    (("\\$\\(DESTDIR\\)") #$output)))))))))
    (inputs
     (list python-wrapper))
    (native-inputs '())
    (synopsis "Python module for generating SELinux policies")
    (description
     "This package contains a Python module that forms the core of
@code{audit2allow}, a part of the package @code{policycoreutils}.  The
sepolgen library contains: Reference Policy Representation, which are Objects
for representing policies and the reference policy interfaces.  It has objects
and algorithms for representing access and sets of access in an abstract way
and searching that access.  It also has a parser for reference policy
\"headers\".  It contains infrastructure for parsing SELinux related messages
as produced by the audit system.  It has facilities for generating policy
based on required access.")
    ;; GPLv2 only
    (license license:gpl2)))

(define-public python-setools
  (package
    (name "python-setools")
    (version "4.4.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/SELinuxProject/setools")
                    (commit version)))
              (file-name (string-append name "-" version "-checkout"))
              (sha256
               (base32
                "1qvd5j6zwq4fmlahg45swjplhif2z89x7s6pnp07gvcp2fbqdsh5"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f ; the test target causes a rebuild
       #:phases
       (modify-phases %standard-phases
         (delete 'portability)
         (add-after 'unpack 'set-SEPOL-variable
           (lambda* (#:key inputs #:allow-other-keys)
             (setenv "SEPOL"
                     (search-input-file inputs "/lib/libsepol.a"))))
         (add-after 'unpack 'remove-Werror
           (lambda _
             (substitute* "setup.py"
               (("'-Werror',") ""))
             #t))
         (add-after 'unpack 'fix-target-paths
           (lambda* (#:key outputs #:allow-other-keys)
             (substitute* "setup.py"
               (("join\\(sys.prefix")
                (string-append "join(\"" (assoc-ref outputs "out") "/\"")))
             #t)))))
    (propagated-inputs
     (list python-networkx))
    (inputs
     (list libsepol libselinux python-pyqt))
    (native-inputs
     (list bison flex python-cython swig))
    (home-page "https://github.com/SELinuxProject/setools")
    (synopsis "Tools for SELinux policy analysis")
    (description "SETools is a collection of graphical tools, command-line
tools, and libraries designed to facilitate SELinux policy analysis.")
    ;; Some programs are under GPL, all libraries under LGPL.
    (license (list license:lgpl2.1+
                   license:gpl2+))))

(define-public policycoreutils
  (package/inherit libsepol
    (name "policycoreutils")
    (arguments
     (list
      #:test-target "test"
      #:make-flags
      #~(let ((out #$output))
          (list (string-append "CC=" #$(cc-for-target))
                (string-append "PREFIX=" out)
                (string-append "LOCALEDIR=" out "/share/locale")
                (string-append "BASHCOMPLETIONDIR=" out
                               "/share/bash-completion/completions")
                "INSTALL=install -c -p"
                "INSTALL_DIR=install -d"
                ;; These ones are needed because some Makefiles define the
                ;; directories relative to DESTDIR, not relative to PREFIX.
                (string-append "SBINDIR=" out "/sbin")
                (string-append "ETCDIR=" out "/etc")
                (string-append "SYSCONFDIR=" out "/etc/sysconfig")
                (string-append "MAN5DIR=" out "/share/man/man5")
                (string-append "INSTALL_NLS_DIR=" out "/share/locale")
                (string-append "AUTOSTARTDIR=" out "/etc/xdg/autostart")
                (string-append "DBUSSERVICEDIR=" out "/share/dbus-1/services")
                (string-append "SYSTEMDDIR=" out "/lib/systemd")
                (string-append "INITDIR=" out "/etc/rc.d/init.d")
                (string-append "SELINUXDIR=" out "/etc/selinux")))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (add-after 'unpack 'enter-dir
            (lambda _ (chdir #$name)))
          (add-after 'enter-dir 'ignore-/usr-tests
            (lambda* (#:key inputs #:allow-other-keys)
              ;; Rewrite lookup paths for header files.
              (substitute* '("newrole/Makefile"
                             "setfiles/Makefile"
                             "run_init/Makefile")
                (("/usr(/include/security/pam_appl.h)" _ file)
                 (search-input-file inputs file))
                (("/usr(/include/libaudit.h)" _ file)
                 (search-input-file inputs file))))))))
    (inputs
     (list audit
           linux-pam
           libsepol
           libselinux
           libsemanage
           libxcrypt))
    (native-inputs
     (list gettext-minimal))
    (synopsis "SELinux core utilities")
    (description "The policycoreutils package contains the core utilities that
are required for the basic operation of an SELinux-enabled GNU system and its
policies.  These utilities include @code{load_policy} to load policies,
@code{setfiles} to label file systems, @code{newrole} to switch roles, and
@code{run_init} to run service scripts in their proper context.")
    (license license:gpl2+)))
