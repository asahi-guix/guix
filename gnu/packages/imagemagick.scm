;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2014, 2015 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2015 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2015 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016 Leo Famulari <leo@famulari.name>
;;; Copyright © 2016, 2021 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2017 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2018, 2019 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Alex Vong <alexvong1995@gmail.com>
;;; Copyright © 2020 Marius Bakke <marius@gnu.org>
;;; Copyright © 2020 Vinicius Monego <monego@posteo.net>
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

(define-module (gnu packages imagemagick)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system perl)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (srfi srfi-1))

;; This is a variant of the 'imagemagick' package that is not updated often.
;; It is intended to be used as a native-input at build-time only, e.g. by
;; 'gtk-doc' (via 'dblatex') for generating package documentation.  This
;; allows the main 'imagemagick' package to be freely updated on the 'master'
;; branch without triggering an excessive number of rebuilds.
;;
;; Normally the grafts mechanism would be used, but there are often
;; difficulties grafting imagemagick, e.g. because upstream changes the ABI
;; between micro version updates.  Also, the overwhelming majority of
;; dependencies on imagemagick are via 'gtk-doc' in 'native-inputs', where
;; grafting is ineffective.  See:
;; <https://lists.gnu.org/archive/html/guix-devel/2021-03/msg00381.html>.
(define-public imagemagick/stable
  (hidden-package
   (package
     (name "imagemagick")
     ;; The 7 release series has an incompatible API, while the 6 series is still
     ;; maintained. Don't update to 7 until we've made sure that the ImageMagick
     ;; users are ready for the 7-series API.
     (version "6.9.12-91")
     (source (origin
               (method url-fetch)
               (uri (string-append "mirror://imagemagick/ImageMagick-"
                                   version ".tar.xz"))
               (sha256
                (base32
                 "0didbs10i9zb4dgripa851j7fivxb9jar7l3vvxz6i4kn6xvdv7r"))
               (patches
                (search-patches "imagemagick-fix-tests.patch"))))
     (build-system gnu-build-system)
     (arguments
      (list
       #:configure-flags #~(list "--with-frozenpaths" "--without-gcc-arch"

                                 ;; Do not embed the build date in binaries.
                                 "--enable-reproducible-build")
       #:phases
       #~(modify-phases %standard-phases
           (add-before 'build 'pre-build
             (lambda _
               (substitute* "Makefile"
                 ;; Clear the `LIBRARY_PATH' setting, which otherwise
                 ;; interferes with our own use.
                 (("^LIBRARY_PATH[[:blank:]]*=.*$")
                  "")

                 ;; Since the Makefile overrides $docdir, modify it to
                 ;; refer to what we want.
                 (("^DOCUMENTATION_PATH[[:blank:]]*=.*$")
                  (string-append "DOCUMENTATION_PATH = "
                                 #$output:doc "/share/doc/"
                                 #$name "-"
                                 #$(package-version this-package) "\n")))))
           (add-before 'configure 'strip-configure-xml
             (lambda _
               (substitute* "config/configure.xml.in"
                 ;; Do not record 'configure' arguments in the
                 ;; configure.xml file that gets installed: That would
                 ;; include --docdir, and thus retain a reference to the
                 ;; 'doc' output.
                 (("@CONFIGURE_ARGS@")
                  "not recorded")))))))
     ;; TODO: Add Jasper etc.
     (inputs
      (list bzip2
            fftw
            freetype
            ghostscript
            graphviz
            lcms
            libjpeg-turbo
            libpng
            libtiff
            libwebp
            libx11
            libxml2
            pango
            xz
            zlib))
     (native-inputs (list pkg-config))
     (outputs '("out"
                "doc"))                 ; 26 MiB of HTML documentation
     (home-page "https://www.imagemagick.org/")
     (synopsis "Create, edit, compose, or convert bitmap images")
     (description
      "ImageMagick is a software suite to create, edit, compose, or convert
bitmap images.  It can read and write images in a variety of formats (over 100)
including DPX, EXR, GIF, JPEG, JPEG-2000, PDF, PhotoCD, PNG, Postscript, SVG,
and TIFF.  Use ImageMagick to resize, flip, mirror, rotate, distort, shear and
transform images, adjust image colors, apply various special effects, or draw
text, lines, polygons, ellipses and Bézier curves.")
     (license (license:fsf-free "http://www.imagemagick.org/script/license.php")))))

(define-public imagemagick
  (package
    (inherit imagemagick/stable)
    (properties (alist-delete 'hidden? (package-properties imagemagick/stable)))
    ;; The 7 release series has an incompatible API, while the 6 series is still
    ;; maintained. Don't update to 7 until we've made sure that the ImageMagick
    ;; users are ready for the 7-series API.
    (version "6.9.12-91")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://imagemagick/ImageMagick-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "0didbs10i9zb4dgripa851j7fivxb9jar7l3vvxz6i4kn6xvdv7r"))
              (patches
               (search-patches "imagemagick-fix-tests.patch"))))))

(define-public perl-image-magick
  (package
    (name "perl-image-magick")
    (version "6.89")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://cpan/authors/id/J/JC/JCRISTY/"
                           "PerlMagick-" version "-1.tar.gz"))
       (sha256
        (base32
         "0n9afy1z5bhf9phrbahnkwhgcmijn8jggpbzwrivw1zhliliiy68"))))
    (build-system perl-build-system)
    (native-inputs (list pkg-config))
    (inputs (list imagemagick))
    (arguments
     `(#:tests? #f ;;Failed 2/23 test programs. 2/353 subtests failed.
       #:phases
       (modify-phases %standard-phases
         (add-before
          'configure 'image-magick-flags
          (lambda* (#:key inputs #:allow-other-keys)
            (let ((im (assoc-ref inputs "imagemagick")))
              (substitute* "Makefile.PL"
                (("my \\$INC_magick = .*")
                 "my $INC_magick = `pkg-config --cflags ImageMagick`;\n")
                (("my \\$LIBS_magick = .*")
                 "my $LIBS_magick = `pkg-config --libs ImageMagick`;\n"))
              #t)))
         (add-before
          'check 'skip-mpeg-tests
          (lambda _
            ;; TODO: MPEG tests fail even though our imagemagick supports
            ;; MPEG.  Has been reported elsewhere,
            ;; http://www.imagemagick.org/discourse-server/viewtopic.php?f=7&t=25036,
            ;; so skip for now.
            (delete-file "t/mpeg/read.t")
            #t)))))
    (home-page "https://metacpan.org/release/PerlMagick")
    (synopsis "Perl interface to ImageMagick")
    (description "This Perl extension allows the reading, manipulation and
writing of a large number of image file formats using the ImageMagick library.
Use it to create, edit, compose, or convert bitmap images from within a Perl
script.")
    ;; See Magick.pm
    (license (package-license imagemagick))))

(define-public graphicsmagick
  (package
    (name "graphicsmagick")
    (version "1.3.40")
    (source
     (origin
       (method url-fetch)
       (uri
        (list
         (string-append "mirror://sourceforge/graphicsmagick/graphicsmagick"
                        "/" version "/GraphicsMagick-" version ".tar.xz")
         (string-append "ftp://ftp.graphicsmagick.org/pub/"
                        "GraphicsMagick/" (version-major+minor version)
                        "/GraphicsMagick-" version ".tar.xz")))
       (sha256
        (base32
         "0ikpza74p00hrs4z2cgykf7vhlqnzzkhaidjlcjppiw99sfimp4p"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "--with-frozenpaths"
              "--enable-shared=yes"
              "--with-x=yes"
              "--with-quantum-depth=16" ;required by Octave
              "--enable-quantum-library-names"
              (string-append "--with-gs-font-dir="
                             (search-input-directory
                              %build-inputs "share/fonts/type1/ghostscript")))))
    (inputs
     (list bzip2
           font-ghostscript
           freetype
           ghostscript
           graphviz
           lcms
           libjpeg-turbo
           libpng
           libtiff
           libwebp
           libxml2
           libx11
           xz
           zlib))
    (native-inputs
     (list pkg-config))
    (outputs '("out"                  ; 13 MiB
               "doc"))                ; ~7 MiB
    (home-page "http://www.graphicsmagick.org")
    (synopsis "Create, edit, compose, or convert bitmap images")
    (description
     "GraphicsMagick provides a comprehensive collection of utilities,
programming interfaces, and GUIs, to support file format conversion, image
processing, and 2D vector rendering.")
    (license license:expat)))
