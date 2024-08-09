;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2016, 2023-2024 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2015, 2016 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2015 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2016, 2017 Leo Famulari <leo@famulari.name>
;;; Copyright © 2017, 2021 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2017 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2018, 2019, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2024 Maxim Cournoyer <maxim.cournoyer@gmail.com>
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

(define-module (gnu packages gd)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system perl)
  #:use-module (guix download)
  #:use-module (gnu packages)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl-check)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages pkg-config)
  #:use-module ((guix licenses) #:select (non-copyleft perl-license)))

(define-public gd
  (package
    (name "gd")
    ;; Note: With libgd.org now pointing to github.com, genuine old
    ;; tarballs are no longer available.  Notably, versions 2.0.x are
    ;; missing.
    (version "2.3.3")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/libgd/libgd/releases/download/gd-"
                    version "/libgd-" version ".tar.xz"))
              (sha256
               (base32
                "0qas3q9xz3wgw06dm2fj0i189rain6n60z1vyq50d5h7wbn25s1z"))
              (patches
               (search-patches "gd-fix-tests-on-i686.patch"
                               "gd-brect-bounds.patch"))))
    (build-system gnu-build-system)
    (arguments
     ;; As recommended by github.com/libgd/libgd/issues/278 to fix rounding
     ;; issues on aarch64 and other architectures.
     (list #:make-flags #~(list "CFLAGS=-ffp-contract=off"

                                ;; XXX: This test fails on i686-linux.
                                ;; See <https://issues.guix.gnu.org/71996>.
                                #$@(if (and (not (%current-target-system))
                                            (string-prefix? "i686"
                                                            (%current-system)))
                                       #~("XFAIL_TESTS=gdimagegrayscale/basic")
                                       #~()))
           #:configure-flags #~(list "--disable-static")
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'install 'remove-libtool-archives
                 ;; Libtool archives lists the whole transitive dependencies,
                 ;; which is unnecessary unless producing static archives and
                 ;; leads to overlinking, e.g. causing the configure script of
                 ;; texlive-bin to fail due to looking for a transitive jpeg
                 ;; library.
                 (lambda _
                   (for-each delete-file
                             (find-files (string-append #$output "/lib")
                                         "\\.la$")))))))
    (native-inputs
     (list pkg-config))
    (inputs
     (list fontconfig
           freetype
           libjpeg-turbo
           libpng
           zlib))
    (home-page "https://www.libgd.org/")
    (synopsis "Library for the dynamic creation of images by programmers")
    (description
     "GD is a library for the dynamic creation of images by programmers.  GD
is written in C, and \"wrappers\" are available for Perl, PHP and other
languages.  GD creates PNG, JPEG, GIF, WebP, XPM, BMP images, among other
formats.  GD is commonly used to generate charts, graphics, thumbnails, and
most anything else, on the fly.  While not restricted to use on the web, the
most common applications of GD involve website development.")
    (license (non-copyleft "file://COPYING"
                           "See COPYING file in the distribution."))
    (properties '((cpe-name . "libgd")
                  (upstream-name . "libgd")
                  (release-monitoring-url
                   . "https://github.com/libgd/libgd/releases")))))

(define-public perl-gd
  (package
    (name "perl-gd")
    (version "2.78")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://cpan/authors/id/R/RU/RURBAN/"
                           "GD-" version ".tar.gz"))
       (sha256
        (base32 "1r3fpr8jhpwi48i66rickiphyj442hypsqnk4df4yjs2ym5hacb8"))))
    (build-system perl-build-system)
    (inputs
     (list fontconfig
           freetype
           gd
           libpng
           libjpeg-turbo
           zlib))
    (native-inputs
     (list perl-extutils-pkgconfig
           perl-test-nowarnings))
    (arguments
     (list #:make-maker-flags
           #~(list (string-append "--lib_jpeg_path="
                                  #$(this-package-input "libjpeg-turbo")))))
    (home-page "https://metacpan.org/release/GD")
    (synopsis "Perl interface to the GD graphics library")
    (description "GD.pm is an autoloadable interface module for libgd, a
popular library for creating and manipulating PNG files.  With this library
you can create PNG images on the fly or modify existing files.")
    (license perl-license)))

(define-public perl-gd-securityimage
  (package
    (name "perl-gd-securityimage")
    (version "1.75")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://cpan/authors/id/B/BU/BURAK/"
                           "GD-SecurityImage-" version ".tar.gz"))
       (sha256
        (base32 "19lf1kzdavrkkx3f900jnpynr55d5kjd2sdmwpfir5dsmkcj9pix"))))
    (build-system perl-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'set-env
           (lambda _ (setenv "PERL_USE_UNSAFE_INC" "1") #t)))))
    (native-inputs
     (list perl-module-build))
    (propagated-inputs
     (list perl-gd perl-image-magick))
    (home-page "https://metacpan.org/release/GD-SecurityImage")
    (synopsis "Security image generator")
    (description "This module provides a basic interface to create
security (captcha) images.  The final output is the actual graphic data, the
mime type of the graphic, and the created random string.  The module also has
some \"styles\" that are used to create the background (or foreground) of the
image.")
    (license perl-license)))
