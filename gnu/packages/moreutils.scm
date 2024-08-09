;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Taylan Ulrich Bayırlı/Kammer <taylanbayirli@gmail.com>
;;; Copyright © 2016, 2017, 2019, 2022 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016–2018, 2020–2022 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2022 ( <paren@disroot.org>
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

(define-module (gnu packages moreutils)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages xml)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public moreutils
  (package
    (name "moreutils")
    (version "0.69")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/"
                    name "-" version ".tar.gz"))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1l859qnzccslvxlh5ghn863bkq2vgmqgnik6jr21b9kc6ljmsy8g"))))
    (build-system gnu-build-system)
    (arguments
     (list #:phases
           #~(modify-phases %standard-phases
               (add-after 'install 'wrap-program
                 (lambda _
                   (for-each
                     (lambda (script)
                       (wrap-program script
                         `("PERL5LIB" ":" prefix (,(getenv "PERL5LIB")))))
                     (find-files (string-append #$output "/bin")))))
               (delete 'configure))     ; no configure script
           #:make-flags
           #~(list (string-append "PREFIX=" #$output)
                   (string-append "DOCBOOKXSL="
                                  #$(this-package-native-input "docbook-xsl")
                                  "/xml/xsl/docbook-xsl-"
                                  #$(package-version (this-package-native-input
                                                      "docbook-xsl")))
                   (string-append "CC=" #$(cc-for-target)))))
    (inputs
     (list bash-minimal
           perl
           perl-ipc-run
           perl-timedate
           perl-time-duration))
    ;; For building the manual pages.
    (native-inputs
     (list docbook-xml-4.4
           docbook-xsl
           libxml2
           libxslt))
    (home-page "https://joeyh.name/code/moreutils/")
    (synopsis "Miscellaneous general-purpose command-line tools")
    (description
     "Moreutils is a collection of general-purpose command-line tools to
augment the traditional Unix toolbox.")
    (properties
     '((release-monitoring-url . "https://git.joeyh.name/index.cgi/moreutils.git/")))
    (license license:gpl2+)))
