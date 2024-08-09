;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014, 2018, 2023 Eric Bavier <bavier@posteo.net>
;;; Copyright © 2015, 2018 Leo Famulari <leo@famulari.name>
;;; Copyright © 2018–2022 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2019 Christopher Baines <mail@cbaines.net>
;;; Copyright © 2021 Xinglu Chen <public@yoctocell.xyz>
;;; Copyright © 2022 jgart <jgart@dismail.de>
;;; Copyright © 2023 Andy Tai <atai@atai.org>
;;; Copyright © 2023 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2023 Foundation Devices, Inc. <hello@foundationdevices.com>
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

(define-module (gnu packages patchutils)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system ocaml)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages django)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages file)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages groff)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages less)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages ocaml)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages xml))

(define-public coccinelle
  (let ((revision "0")
        (commit "6608e45f85a10c57a3c910154cf049a5df4d98e4"))
    (package
      (name "coccinelle")
      (version (git-version "1.1.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/coccinelle/coccinelle")
               (commit commit)))
         (file-name (git-file-name name version))
         (modules '((guix build utils)))
         (snippet
          #~(delete-file-recursively "bundles"))
         (sha256
          (base32
           "08nycmjyckqmqjpi78dcqdbmjq1xp18qdc6023dl90gdi6hmxz9l"))))
      (build-system gnu-build-system)
      (arguments
       (list #:phases
             #~(modify-phases %standard-phases
                 (add-before 'bootstrap 'prepare-version.sh
                   (lambda _
                     (setenv "MAKE_COCCI_RELEASE" "y")
                     (patch-shebang "version.sh")))
                 (add-before 'check 'set-batch-mode
                   (lambda _
                     (substitute* "Makefile"
                       (("--testall")
                         "--batch_mode --testall")))))))
      (propagated-inputs
       (list ocaml-menhir
             ocaml-num
             ocaml-parmap
             ocaml-pcre
             ocaml-pyml
             ocaml-stdcompat))
      (native-inputs
       (list autoconf
             automake
             ocaml
             ocaml-findlib
             pkg-config))
      (home-page "https://coccinelle.lip6.fr")
      (synopsis "Transformation of C code using semantic patches")
      (description "Coccinelle is a tool that allows modification of C code
using semantic patches in the @acronym{SmPL, Semantic Patch Language} for
specifying desired matches and transformations in the C code.")
      (license gpl2))))

(define-public patchutils
  (package
    (name "patchutils")
    (version "0.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://cyberelk.net/tim/data/patchutils/stable/"
                           name "-" version ".tar.xz"))
       (sha256
        (base32
         "1va5pzmxbzpi87vdnbjm9qdf9bvzps9xfv0gi4mycgg3bybb0xc8"))))
    (build-system gnu-build-system)
    (inputs
     (list bash-minimal perl python))
    (arguments
     '(#:parallel-tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-before 'check 'patch-test-scripts
           (lambda _
             (substitute* (find-files "tests" "^run-test$")
               (("/bin/echo") (which "echo")))))
         (add-after 'install 'wrap-program
           ;; Point installed scripts to the utilities they need.
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out       (assoc-ref outputs "out"))
                    (diffutils (assoc-ref inputs "diffutils"))
                    (sed       (assoc-ref inputs "sed"))
                    (gawk      (assoc-ref inputs "gawk")))
               (for-each
                (lambda (prog)
                  (wrap-program (string-append out "/bin/" prog)
                    `("PATH" ":" prefix
                      ,(map (lambda (dir)
                              (string-append dir "/bin"))
                            (list diffutils sed gawk)))))
                '("dehtmldiff" "editdiff" "espdiff"))))))))
    (home-page "http://cyberelk.net/tim/software/patchutils")
    (synopsis "Collection of tools for manipulating patch files")
    (description
     "Patchutils is a collection of programs that can manipulate patch files
in useful ways such as interpolating between two pre-patches, combining two
incremental patches, fixing line numbers in hand-edited patches, and simply
listing the files modified by a patch.")
    (license gpl2+)))

(define-public quilt
  (package
    (name "quilt")
    (version "0.67")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://savannah/quilt/"
                           "quilt-" version ".tar.gz"))
       (sha256
        (base32 "1hiw05aqysbnnl15zg2n5cr11k0z7rz85fvq8qv6qap7hw4vxqrv"))
       (patches (search-patches "quilt-grep-compat.patch"))))
    (build-system gnu-build-system)
    (native-inputs
     (list gettext-minimal))
    (inputs
     (list bash-minimal perl less file gzip ed
           diffutils diffstat findutils tar))
    (arguments
     '(#:parallel-tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'check)
         (add-after 'install 'wrap-program
           ;; quilt's configure checks for the absolute path to the utilities it
           ;; needs, but uses only the name when invoking them, so we need to
           ;; make sure the quilt script can find those utilities when run.
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((cmd-path (lambda (cmd) (dirname (which cmd))))
                   (out      (assoc-ref outputs "out")))
               (wrap-program (string-append out "/bin/quilt")
                 `("PATH" ":" prefix
                   ,(map cmd-path
                         (list "bash" "diff" "diffstat" "ed" "file" "find" "grep"
                               "gzip" "less" "patch" "perl" "rm" "sed" "tar"))))
               (wrap-program (string-append out "/share/quilt/scripts/backup-files")
                 `("PATH" ":" prefix
                   ,(map cmd-path
                         (list "find" "grep" "mkdir")))))))
         (add-after 'compress-documentation 'check
           (lambda _
             (substitute* '("test/run" "test/edit.test")
               (("/bin/sh") (which "sh"))
               (("rm -rf") (string-append (which "rm") " -rf")))
             (substitute* "Makefile"
               (("^(PATH|QUILT_DIR).*" &)
                (string-append "#" &)) ; Test the installed 'quilt'
               (("export QUILT_DIR") "export")
               (("\\| sort") (string-append "| " (which "sort")))
               (("\\| sed") (string-append "| " (which "sed")))
               (("(chmod|touch)" &) (which &)))
             ;; Tests are scripts interpreted by `test/run` and may specify
             ;; the execution of several tools.  But PATH will be empty, so
             ;; rewrite with the full file name:
             (setenv "PATH" (string-append %output "/bin" ":" (getenv "PATH")))
             (substitute* (find-files "test" "\\.test$")
               (("([\\$\\|] )([[:graph:]]+)([[:blank:]\n]+)"
                 & > cmd <)
                (if (string=? cmd "zcat")
                    ;; The `zcat` program is a script, and it will not be able
                    ;; to invoke its `gzip` with PATH unset.  It's a simple
                    ;; script though, so just translate here:
                    (string-append > (which "gzip") " -cd " <)
                    (or (and=> (which cmd)
                               (lambda (p) (string-append > p <)))
                        &))))
             (let ((make (which "make")))
               ;; Assert the installed 'quilt' can find utilities it needs.
               (unsetenv "PATH")
               ;; Used by some tests for access to internal "scripts"
               (setenv "QUILT_DIR" (string-append %output "/share/quilt"))
               (invoke make "check")))))))
    (home-page "https://savannah.nongnu.org/projects/quilt/")
    (synopsis "Script for managing patches to software")
    (description
     "Quilt allows you to easily manage large numbers of patches by keeping
track of the changes each patch makes.  Patches can be applied, un-applied,
refreshed, and more.")
    (license gpl2)))

(define-public colordiff
  (package
    (name "colordiff")
    (version "1.0.21")
    (source
      (origin
        (method url-fetch)
        (uri (list (string-append "https://www.colordiff.org/colordiff-"
                                  version ".tar.gz")
                   (string-append "http://www.colordiff.org/archive/colordiff-"
                                  version ".tar.gz")))
      (sha256
       (base32 "05g64z4ls1i70rpzznjxy2cpjgywisnwj9ssx9nq1w7hgqjz8c4v"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags (list (string-append "DESTDIR=" (assoc-ref %outputs "out"))
                          "INSTALL_DIR=/bin" "MAN_DIR=/share/man/man1")
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)            ; no configure script
         (delete 'build))))             ; nothing to build
    (inputs
     (list perl xmlto))
    (home-page "https://www.colordiff.org")
    (synopsis "Display diff output with colors")
    (description
     "Colordiff is Perl script wrapper on top of diff command which provides
'syntax highlighting' for various patch formats.")
    (license gpl2+)))

(define-public vbindiff
  (package
    (name "vbindiff")
    (version "3.0_beta5")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.cjmweb.net/vbindiff/vbindiff-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "1f1kj4jki08bnrwpzi663mjfkrx4wnfpzdfwd2qgijlkx5ysjkgh"))))
    (build-system gnu-build-system)
    (inputs
     (list ncurses))
    (home-page "https://www.cjmweb.net/vbindiff/")
    (synopsis "Console-based tool for comparing binary data")
    (description "Visual Binary Diff (@command{vbindiff}) displays files in
hexadecimal and ASCII (or EBCDIC).  It can also display two files at once, and
highlight the differences between them.  It works well with large files (up to 4
GiB).")
    (license gpl2+)))

(define-public meld
  (package
    (name "meld")
    (version "3.22.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnome/sources/meld/"
                           (version-major+minor version)
                           "/meld-" version ".tar.xz"))
       (sha256
        (base32 "1vqn4glv32dxrzm5hxj64ac5q9ffr1bhf7ks6wxia6ydzc9sg826"))))
    (build-system meson-build-system)
    (native-inputs
     (list desktop-file-utils
           intltool
           itstool
           libxml2
           `(,glib "bin")               ; for glib-compile-schemas
           gobject-introspection
           pkg-config
           python))
    (inputs
     (list bash-minimal
           python
           python-pycairo
           python-pygobject
           gsettings-desktop-schemas
           gtksourceview-4))
    (propagated-inputs
     (list dconf))
    (arguments
     (list
      #:glib-or-gtk? #t
      #:imported-modules `(,@%meson-build-system-modules
                           (guix build python-build-system))
      #:modules '((guix build meson-build-system)
                  ((guix build python-build-system) #:prefix python:)
                  (guix build utils))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'skip-gtk-update-icon-cache
            ;; Don't create 'icon-theme.cache'.
            (lambda _
              (substitute* "meson_post_install.py"
                (("gtk-update-icon-cache") (which "true")))))
          (add-after 'install 'copy-styles
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let ((styles "/share/gtksourceview-4/styles"))
                (copy-recursively
                 (string-append (assoc-ref inputs "gtksourceview") styles)
                 (string-append (assoc-ref outputs "out") styles)))))
          (add-after 'glib-or-gtk-wrap 'python-and-gi-wrap
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (wrap-program (search-input-file outputs "bin/meld")
                `("GUIX_PYTHONPATH" = (,(getenv "GUIX_PYTHONPATH")
                                       ,(python:site-packages inputs outputs)))
                `("GI_TYPELIB_PATH" = (,(getenv "GI_TYPELIB_PATH")))))))))
    (home-page "https://meldmerge.org/")
    (synopsis "Compare files, directories and working copies")
    (description "Meld is a visual diff and merge tool targeted at
developers.  Meld helps you compare files, directories, and version controlled
projects.  It provides two- and three-way comparison of both files and
directories, and has support for many popular version control systems.

Meld helps you review code changes and understand patches.  It might even help
you to figure out what is going on in that merge you keep avoiding.")
    (license gpl2)))

(define-public patchwork
  (package
    (name "patchwork")
    (version "3.1.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/getpatchwork/patchwork")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0is9d4gf93jcbyshyj2k3kjyrjnvimrm6bai6dbcx630md222j5w"))))
    (build-system python-build-system)
    (arguments
     `(;; TODO: Tests require a running database
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (add-after 'unpack 'replace-wsgi.py
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (delete-file "patchwork/wsgi.py")
             (call-with-output-file "patchwork/wsgi.py"
               (lambda (port)
                 ;; Embed the PYTHONPATH containing the dependencies, as well
                 ;; as the python modules in this package in the wsgi.py file,
                 ;; as this will ensure they are available at runtime.
                 (define pythonpath
                   (string-append (getenv "GUIX_PYTHONPATH")
                                  ":"
                                  (site-packages inputs outputs)))
                 (display
                  (string-append "
import os, sys

sys.path.extend('" pythonpath "'.split(':'))

from django.core.wsgi import get_wsgi_application

# By default, assume that patchwork is running as a Guix service, which
# provides the settings as the 'guix.patchwork.settings' Python module.
#
# When using httpd, it's hard to set environment variables, so rely on the
# default set here.
os.environ['DJANGO_SETTINGS_MODULE'] = os.getenv(
  'DJANGO_SETTINGS_MODULE',
  'guix.patchwork.settings' # default
)

application = get_wsgi_application()\n") port)))))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (setenv "DJANGO_SETTINGS_MODULE" "patchwork.settings.dev")
               (invoke "python" "-Wonce" "./manage.py" "test" "--noinput"))
             #t))
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out"))
                   (out-site-packages (site-packages inputs outputs)))
               (for-each (lambda (directory)
                           (copy-recursively
                            directory
                            (string-append out-site-packages "/" directory)))
                         '(;; Contains the python code
                           "patchwork"
                           ;; Contains the templates for the generated HTML
                           "templates"))
               (delete-file-recursively
                (string-append out-site-packages "/patchwork/tests"))

               ;; Install patchwork related tools
               (for-each (lambda (file)
                           (install-file file (string-append out "/bin")))
                         (list
                          (string-append out-site-packages
                                         "/patchwork/bin/parsemail.sh")
                          (string-append out-site-packages
                                         "/patchwork/bin/parsemail-batch.sh")))

               ;; Collect the static assets, this includes JavaScript, CSS and
               ;; fonts. This is a standard Django process when running a
               ;; Django application for regular use, and includes assets for
               ;; dependencies like the admin site from Django.
               ;;
               ;; The intent here is that you can serve files from this
               ;; directory through a webserver, which is recommended when
               ;; running Django applications.
               (let ((static-root
                      (string-append out "/share/patchwork/htdocs")))
                 (mkdir-p static-root)
                 (copy-file "patchwork/settings/production.example.py"
                            "patchwork/settings/assets.py")
                 (setenv "DJANGO_SECRET_KEY" "dummyvalue")
                 (setenv "DJANGO_SETTINGS_MODULE" "patchwork.settings.assets")
                 (setenv "STATIC_ROOT" static-root)
                 (invoke "./manage.py" "collectstatic" "--no-input"))

               ;; The lib directory includes example configuration files that
               ;; may be useful when deploying patchwork.
               (copy-recursively "lib"
                                 (string-append
                                  out "/share/doc/" ,name "-" ,version)))
             #t))
         ;; The hasher script is used from the post-receive.hook
         (add-after 'install 'install-hasher
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (out-site-packages (site-packages inputs outputs))
                    (out-hasher.py (string-append out-site-packages
                                                  "/patchwork/hasher.py")))
               (chmod out-hasher.py #o555)
               (symlink out-hasher.py (string-append out "/bin/hasher")))
             #t))
         ;; Create a patchwork specific version of Django's command line admin
         ;; utility.
         (add-after 'install 'install-patchwork-admin
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out")))
               (mkdir-p (string-append out "/bin"))
               (call-with-output-file (string-append out "/bin/patchwork-admin")
                 (lambda (port)
                   (simple-format port "#!~A
import os, sys

if __name__ == \"__main__\":
    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)" (which "python"))))
               (chmod (string-append out "/bin/patchwork-admin") #o555))
             #t)))))
    (inputs
     (list python-wrapper))
    (propagated-inputs
     (list python-django-3.2
           ;; TODO: Make this configurable
           python-psycopg2
           python-mysqlclient
           python-django-filter
           python-django-rest-framework
           python-django-debug-toolbar))
    (synopsis "Web based patch tracking system")
    (description
     "Patchwork is a patch tracking system.  It takes in emails containing
patches, and displays the patches along with comments and state information.
Users can login allowing them to change the state of patches.")
    (home-page "http://jk.ozlabs.org/projects/patchwork/")
    (license gpl2+)))

(define-public wiggle
  (package
    (name "wiggle")
    (version "1.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/neilbrown/wiggle")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "18ilzr9sbal1j8p1d94ilm1j5blac5cngvcvjpdmgmpw6diy2ldf"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:make-flags
      #~(list "CFLAGS=-I. -O3" "INSTALL=install" "STRIP=-s"
              (string-append "CC=" #$(cc-for-target))
              (string-append "BINDIR=" #$output "/bin")
              (string-append "MANDIR=" #$output "/share/man")
              (string-append "PREFIX=" #$output))
      #:test-target "test"
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure))))
    (home-page "http://neil.brown.name/wiggle/")
    (inputs (list ncurses))
    (native-inputs (list groff))
    (synopsis "Apply patches with conflicts")
    (description
     "@code{wiggle} attempts to apply patches to a target file even if the
patches do not match perfectly.")
    (license gpl2+)))

(define-public pwclient
  (package
    (name "pwclient")
    (version "1.3.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/getpatchwork/pwclient")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1xckwvcqklzpyh3xs4k2zm40ifp0q5fdkj2vmgb8vhfvl1ivs6jv"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch-requirements
           (lambda _
             (substitute* "test-requirements.txt"
               ;; The pytest requirement is unnecessarily strict
               (("pytest>=3.0,<5.0;")
                "pytest>=3.0,<6.0;"))
             #t))
         (add-before 'build 'set-PBR_VERSION
           (lambda _
             (setenv "PBR_VERSION"
                     ,version)
             #t))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (invoke "pytest"))
             #t))
         (add-after 'install 'install-man-page
           (lambda* (#:key outputs #:allow-other-keys)
             (install-file "man/pwclient.1"
                           (string-append
                            (assoc-ref outputs "out")
                            "/share/man/man1"))
             #t)))))
    (native-inputs
     (list python-pbr python-pytest python-pytest-cov python-mock))
    (home-page
     "https://github.com/getpatchwork/pwclient")
    (synopsis "Command-line client for the Patchwork patch tracking tool")
    (description
     "pwclient is a VCS-agnostic tool for interacting with Patchwork, the
web-based patch tracking system.")
    (license gpl2+)))
