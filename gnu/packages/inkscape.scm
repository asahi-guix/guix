;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014 John Darrington <jmd@gnu.org>
;;; Copyright © 2014, 2016 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2016, 2018 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017, 2020 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2020, 2021, 2022, 2024 Maxim Cournoyer <maxim.cournoyer@gmail.com>
;;; Copyright © 2020 Boris A. Dekshteyn <boris.dekshteyn@gmail.com>
;;; Copyright © 2020 Ekaitz Zarraga <ekaitz@elenq.tech>
;;; Copyright © 2023 Efraim Flashner <efraim@flashner.co.il>
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

(define-module (gnu packages inkscape)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages)
  #:use-module (gnu packages aspell)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bdw-gc)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages libreoffice)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages popt)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages image)
  #:use-module (gnu packages pkg-config)
  #:use-module (srfi srfi-1))

;;; A variant of Inkscape intended to be bumped only on core-updates, to avoid
;;; rebuilding 2k+ packages through dblatex.  It should only be used as a
;;; native-input since it might not receive timely security updates.
(define-public inkscape/stable
  (hidden-package
   (package
     (name "inkscape")
     (version "1.2.1")
     (source
      (origin
        (method url-fetch)
        (uri (string-append "https://media.inkscape.org/dl/"
                            "resources/file/"
                            "inkscape-" version ".tar.xz"))
        (patches (search-patches "inkscape-poppler-compat.patch"))
        (sha256
         (base32 "06scilds4p4bw337ss22nfdxy2kynv5yjw6vq6nlpjm7xfh7vkj6"))
        (modules '((guix build utils)
                   (ice-9 format)))
        (snippet
         '(begin
            (let-syntax
                ;; XXX: The build system doesn't currently support using
                ;; system libraries over bundled ones (see:
                ;; https://gitlab.com/inkscape/inkscape/issues/876).
                ((unbundle
                  (syntax-rules ()
                    ((_ (name source-dir use-pkg-config?) ...)
                     (begin
                       ;; Delete bundled source directories.
                       (delete-file-recursively source-dir) ...
                       (substitute* '("src/CMakeLists.txt"
                                      "src/3rdparty/CMakeLists.txt")
                         (((string-append ".*add_subdirectory\\("
                                          (basename source-dir) "\\).*"))
                          "") ...)
                       ;; Remove bundled entries from INKSCAPE_TARGET_LIBS.
                       (substitute* "src/CMakeLists.txt"
                         (((string-append name "_LIB.*")) "") ...)
                       ;; Register the external libraries, so that their
                       ;; headers are added to INKSCAPE_INCS_SYS and their
                       ;; shared libraries added to INKSCAPE_LIBS.
                       (if use-pkg-config?
                           (let* ((width (string-length "pkg_check_modules("))
                                  (indent (string-join (make-list width " ") "")))
                             (substitute* "CMakeScripts/DefineDependsandFlags.cmake"
                               (("^pkg_check_modules\\(INKSCAPE_DEP REQUIRED.*" start)
                                (string-append start
                                               (format #f "~a~a~%" indent name)))))
                           (substitute* "CMakeScripts/DefineDependsandFlags.cmake"
                             (("^find_package\\(Iconv REQUIRED\\).*" start)
                              (string-append (format #f "
find_path(~a_INCLUDE_DIR NAMES ~:*~a/~:*~a.h ~:*~a.h)
if(NOT ~:*~a_INCLUDE_DIR)
  message(FATAL_ERROR \"~:*~a headers not found\")
else()
  list(APPEND INKSCAPE_INCS_SYS ${~:*~a_INCLUDE_DIR})
endif()

find_library(~:*~a_LIB NAMES ~:*~a)
if(NOT ~:*~a_LIB)
  message(FATAL_ERROR \"~:*~a library not found\")
else()
  list(APPEND INKSCAPE_LIBS ~:*~a_LIB)
endif()~%~%"
                                                     name)
                                             start)))) ...
                                             ;; Fix the references to the headers of the
                                             ;; unbundled libraries.
                                             (substitute* (find-files "." "\\.h$|\\.cpp$")
                                               (((string-append "#include (\"|<)3rdparty/"
                                                                (basename source-dir)) _ quote)
                                                (string-append "#include " quote
                                                               (basename source-dir)))
                                               ...))))))
              (unbundle ("2geom" "src/3rdparty/2geom" #t)
                        ;; libcroco cannot be unbundled as it is heavily
                        ;; modified (see:
                        ;; https://gitlab.com/inkscape/inkscape/issues/876#note_276114904).
                        ;; ("croco" "src/3rdparty/libcroco" #t)
                        ;; FIXME: Unbundle the following libraries once they
                        ;; have been packaged.
                        ;; ("cola" "src/3rdparty/adaptagrams/libcola")
                        ;; ("avoid" "src/3rdparty/adaptagrams/libavoid")
                        ;; ("vpsc" "src/3rdparty/adaptagrams/libvpsc")
                        ;; libuemf cannot be unbundled as it slightly modified
                        ;; from upstream (see:
                        ;; https://gitlab.com/inkscape/inkscape/issues/973).
                        ;; ("uemf" "src/3rdparty/libuemf" #f)
                        ;; FIXME: libdepixelize upstream is ancient and doesn't
                        ;; build with a recent lib2geom
                        ;; (see: https://bugs.launchpad.net/libdepixelize/+bug/1862458).
                        ;;("depixelize" "src/3rdparty/libdepixelize")
                        ("autotrace" "src/3rdparty/autotrace" #t)))
            ;; Lift the requirement on the double-conversion library, as
            ;; it is only needed by lib2geom, which is now unbundled.
            (substitute* "CMakeScripts/DefineDependsandFlags.cmake"
              ((".*find_package\\(DoubleConversion.*") ""))))))
     (build-system cmake-build-system)
     (arguments
      (list
       #:test-target "check"         ;otherwise some test binaries are missing
       #:disallowed-references (list imagemagick/stable)
       #:imported-modules `(,@%cmake-build-system-modules
                            (guix build glib-or-gtk-build-system))
       #:modules '((guix build cmake-build-system)
                   ((guix build glib-or-gtk-build-system) #:prefix glib-or-gtk:)
                   (guix build utils))
       ;; Disable imagemagick support in the stable variant, to reduce the
       ;; number of dependents of the 'imagemagick' package.
       #:configure-flags #~(list "-DWITH_IMAGE_MAGICK=OFF")
       #:phases
       #~(modify-phases %standard-phases
           (add-after 'unpack 'generate-gdk-pixbuf-loaders-cache-file
             (assoc-ref glib-or-gtk:%standard-phases
                        'generate-gdk-pixbuf-loaders-cache-file))
           (add-after 'unpack 'patch-icon-cache-generator
             (lambda _
               (substitute* "share/icons/application/CMakeLists.txt"
                 (("gtk-update-icon-cache") "true"))))
           (add-after 'unpack 'disable-latex-export-tests
             ;; FIXME: For some reason the test.pdf_tex file generated by the
             ;; "--export-latex" lacks "some text" in its content when run in
             ;; the build environment.  Skip the related tests.
             (lambda _
               (substitute* "testfiles/cli_tests/CMakeLists.txt"
                 (("add_cli_test\\(export-latex")
                  "message(TEST_DISABLED: export-latex"))))
           (add-after 'unpack 'disable-vertical-glyph-tests
             (lambda _
               ;; FIXME: These tests fail with newer Pango and Harfbuzz:
               ;;   https://gitlab.com/inkscape/inkscape/-/issues/2917
               ;;   https://gitlab.com/inkscape/inkscape/-/issues/3554
               ;; Simply providing older versions don't work, as we need
               ;; the full GTK stack; we could use package-input-rewriting
               ;; but then have to also downgrade pangomm and disable tests
               ;; in librsvg and GTK+.  Just ignore for now.
               (substitute* "testfiles/rendering_tests/CMakeLists.txt"
                 (("test-glyph-y-pos") "")
                 (("text-glyphs-combining") "")
                 (("text-glyphs-vertical") "")
                 (("test-rtl-vertical") ""))))
           #$@(if (or (target-aarch64?)
                      (target-ppc64le?)
                      (target-riscv64?))
                  '((add-after 'unpack 'disable-more-tests
                      (lambda _
                        ;; https://gitlab.com/inkscape/inkscape/-/issues/3554#note_1035680690
                        (substitute* "testfiles/CMakeLists.txt"
                          (("lpe64-test") "#lpe64-test"))
                        ;; https://gitlab.com/inkscape/inkscape/-/issues/3554#note_1035539888
                        ;; According to upstream, this is a false positive.
                        (substitute* "testfiles/rendering_tests/CMakeLists.txt"
                          (("test-use") "#test-use"))
                        ;; https://gitlab.com/inkscape/inkscape/-/issues/3554#note_1035539888
                        ;; Allegedly a precision error in the gamma.
                        (substitute* "testfiles/cli_tests/CMakeLists.txt"
                          (("add_cli_test\\(export-png-color-mode-gray-8_png" all)
                           (string-append "#" all))))))
                  '())
           (add-after 'unpack 'set-home
             ;; Mute Inkscape warnings during tests.
             (lambda _
               (setenv "HOME" (getcwd))))
           ;; Move the check phase after the install phase, as when run in the
           ;; tests, Inkscape relies on files that are not yet installed, such
           ;; as the "share/inkscape/ui/units.xml" file.
           (delete 'check)
           (add-after 'install 'check
             (assoc-ref %standard-phases 'check))
           (add-after 'install 'glib-or-gtk-compile-schemas
             (assoc-ref glib-or-gtk:%standard-phases 'glib-or-gtk-compile-schemas))
           (add-after 'glib-or-gtk-compile-schemas 'glib-or-gtk-wrap
             (assoc-ref glib-or-gtk:%standard-phases 'glib-or-gtk-wrap))
           (add-after 'install 'wrap-program
             ;; Ensure Python is available at runtime.
             (lambda _
               (wrap-program (string-append #$output "/bin/inkscape")
                 `("GUIX_PYTHONPATH" prefix
                   (,(getenv "GUIX_PYTHONPATH")))
                 ;; Wrapping GDK_PIXBUF_MODULE_FILE allows Inkscape to load
                 ;; its own icons in pure environments.
                 `("GDK_PIXBUF_MODULE_FILE" =
                   (,(getenv "GDK_PIXBUF_MODULE_FILE")))))))))
     (inputs
      (list aspell
            autotrace
            bash-minimal
            gdl-minimal
            gtkmm-3
            gtk+
            gtkspell3
            gsl
            poppler
            lib2geom
            libjpeg-turbo
            libpng
            libxml2
            libxslt
            libgc
            (librsvg-for-system)        ;for the pixbuf loader
            libsoup-minimal-2
            libcdr
            libvisio
            libwpd
            libwpg
            freetype
            popt
            potrace
            lcms
            boost
            python-wrapper
            python-scour
            python-pyserial
            python-numpy
            python-lxml))
     (native-inputs
      (list gettext-minimal
            imagemagick/stable          ;for tests
            `(,glib "bin")
            googletest
            perl
            pkg-config))
     (home-page "https://inkscape.org/")
     (synopsis "Vector graphics editor")
     (description "Inkscape is a vector graphics editor.  What sets Inkscape
apart is its use of Scalable Vector Graphics (SVG), an XML-based W3C standard,
as the native format.")
     (license license:gpl3+))))           ;see the file COPYING

(define-public inkscape
  (package
    (inherit inkscape/stable)
    (name "inkscape")
    (version "1.2.1")
    (source
     (origin
       (inherit (package-source inkscape/stable))
       (method url-fetch)
       (uri (string-append "https://media.inkscape.org/dl/"
                           "resources/file/"
                           "inkscape-" version ".tar.xz"))
       (sha256
        (base32 "06scilds4p4bw337ss22nfdxy2kynv5yjw6vq6nlpjm7xfh7vkj6"))))
    (build-system cmake-build-system)
    (arguments
     (substitute-keyword-arguments (package-arguments inkscape/stable)
       ;; ((#:configure-flags flags ''())
       ;;  ;; Enable ImageMagick support.
       ;;  #~(delete "-DWITH_IMAGE_MAGICK=OFF" #$flags))
       ((#:phases phases)
        #~(modify-phases #$phases
            (replace 'wrap-program
              ;; Ensure Python is available at runtime.
              (lambda _
                (wrap-program (string-append #$output "/bin/inkscape")
                  `("GUIX_PYTHONPATH" prefix
                    (,(getenv "GUIX_PYTHONPATH")))
                  ;; Wrapping GDK_PIXBUF_MODULE_FILE allows Inkscape to load
                  ;; its own icons in pure environments.
                  `("GDK_PIXBUF_MODULE_FILE" =
                    (,(getenv "GDK_PIXBUF_MODULE_FILE"))))))))))
    (inputs (modify-inputs (package-inputs inkscape/stable)
              (append imagemagick         ;for libMagickCore and libMagickWand
                      python-cssselect))) ;to render qrcode
    (properties (alist-delete 'hidden? (package-properties inkscape/stable)))))
