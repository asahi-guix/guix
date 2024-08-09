;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2020 Ekaitz Zarraga <ekaitz@elenq.tech>
;;; Copyright © 2020 Evan Hanson <evhan@foldling.org>
;;; Copyright © 2020 raingloom <raingloom@riseup.net>
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

(define-module (gnu packages chicken)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix build-system chicken)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix svn-download)
  #:use-module ((guix licenses)
                #:prefix license:))

(define-public chicken
  (package
    (name "chicken")
    (version "5.3.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://code.call-cc.org/releases/"
                                  version "/chicken-" version ".tar.gz"))
              (sha256
               (base32
                "0xhdvcdwlv9vbhxh7k0fzd32ybhc7fn83y9fj48dhzp1z7c9kbf3"))))
    (build-system gnu-build-system)
    (arguments
     `(#:modules ((guix build gnu-build-system)
                  (guix build utils)
                  (srfi srfi-1))

       ;; No `configure' script; run "make check" after "make install" as
       ;; prescribed by README.
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'check)
         (add-after 'install 'check
           (assoc-ref %standard-phases 'check)))

       #:make-flags (let ((out (assoc-ref %outputs "out")))
                      (list "PLATFORM=linux"
                            (string-append "PREFIX=" out)
                            (string-append "VARDIR=" out "/var/lib")))

       ;; Parallel builds are not supported, as noted in README.
       #:parallel-build? #f))
    (native-search-paths
     (list (search-path-specification
            (variable "CHICKEN_REPOSITORY_PATH")
            ;; TODO extract binary version into a module level definition.
            (files (list "var/lib/chicken/11")))))
    ;; Reference gcc-toolchain lazily to avoid circular module dependency
    ;; problems.
    (propagated-inputs (list (module-ref (resolve-interface
                                          '(gnu packages commencement))
                                         'gcc-toolchain)))
    (home-page "https://www.call-cc.org/")
    (synopsis "R5RS Scheme implementation that compiles native code via C")
    (description
     "CHICKEN is a compiler for the Scheme programming language.  CHICKEN
produces portable and efficient C, supports almost all of the R5RS Scheme
language standard, and includes many enhancements and extensions.")
    (license license:bsd-3)))

(define-public chicken-compile-file
  (package
    (name "chicken-compile-file")
    (version "1.3")
    (source (origin
              (method url-fetch)
              (uri (egg-uri "compile-file" version))
              (sha256
               (base32
                "1029i5ifr48vb3clvl8n50iq23rzc42szdcsl9320qmj1ksg9y93"))))
    (build-system chicken-build-system)
    (arguments `(#:egg-name "compile-file"))
    (home-page "https://wiki.call-cc.org/egg/compile-file")
    (synopsis "Programmatic compiler invocation")
    (description "This egg provides a way to do on-the-fly compilation of
source code and load it into the running process.")
    (license license:bsd-3)))

(define-public chicken-srfi-1
  (package
    (name "chicken-srfi-1")
    (version "0.5.1")
    (source
     (origin
       (method svn-fetch)
       (uri (svn-reference
             (url (string-append
                   "https://code.call-cc.org/svn/chicken-eggs/"
                   "release/5/srfi-1/tags/"
                   version))
             (revision 39055)
             (user-name "anonymous")
             (password "")))
       (file-name (string-append "chicken-srfi-1" version "-checkout"))
       (sha256
        (base32
         "02940zsjrmn7c34rnp1rllm2nahh9jvszlzrw8ak4pf31q09cmq1"))))
    (build-system chicken-build-system)
    (arguments '(#:egg-name "srfi-1"))
    (inputs
     (list chicken-test))
    (home-page "https://wiki.call-cc.org/eggref/5/srfi-1")
    (synopsis "SRFI-1 list library")
    (description
     "The list library defined in
@uref{https://srfi.schemers.org/srfi-1/srfi-1.html, SRFI-1} contains a lot of
useful list processing procedures for construction, examining, destructuring
and manipulating lists and pairs.")
    (license license:bsd-3)))

(define-public chicken-srfi-13
  (package
    (name "chicken-srfi-13")
    (version "0.3.2")
    (source (origin
              (method url-fetch)
              (uri (egg-uri "srfi-13" version))
              (sha256
               (base32
                "18clbmaampaxivwx9bya9fxnkzqbczhlz0kbs9bfapm77mxkwclc"))))
    (build-system chicken-build-system)
    (arguments '(#:egg-name "srfi-13"))
    (native-inputs (list chicken-test))
    (propagated-inputs (list chicken-srfi-14))
    (home-page "https://wiki.call-cc.org/egg/srfi-13")
    (synopsis "SRFI-13 string library for Chicken scheme")
    (description "This package provides the SRFI-13 string library for Chicken
scheme.")
    (license license:bsd-3)))

(define-public chicken-srfi-14
  (package
    (name "chicken-srfi-14")
    (version "0.2.1")
    (source
     (origin
       (method svn-fetch)
       (uri (svn-reference
             (url (string-append "https://code.call-cc.org/svn/chicken-eggs/"
                                 "release/5/srfi-14/tags/" version))
             (revision 39057)
             (user-name "anonymous")
             (password "")))
       (file-name (string-append "chicken-srfi-14-" version "-checkout"))
       (sha256
        (base32
         "0wjsqfwawh9bx6vvii1gwag166bxkflc0ib374fbws14914g2ac1"))))
    (build-system chicken-build-system)
    (arguments '(#:egg-name "srfi-14"))
    (home-page "https://wiki.call-cc.org/eggref/5/srfi-14")
    (synopsis "Character set library")
    (description
     "Character sets can be created, extended, tested for the membership of
a characters and be compared to other character sets")
    (license (license:non-copyleft
              "http://wiki.call-cc.org/eggref/5/srfi-14#license"))))

(define-public chicken-srfi-18
  (package
    (name "chicken-srfi-18")
    (version "0.1.6")
    (source (origin
              (method url-fetch)
              (uri (egg-uri "srfi-18" version))
              (sha256
               (base32
                "0v2pkdck0ji1wiqgg8sg4z6rbkj2qw4vy4b9lx0w0pmhlxqpg1xd"))))
    (build-system chicken-build-system)
    (arguments
     `(#:egg-name "srfi-18"))
    (native-inputs (list chicken-compile-file))
    (home-page "https://wiki.call-cc.org/egg/srfi-18")
    (synopsis "Multithreading package, largely following SRFI-18")
    (description "The threads implemented in CHICKEN are so called \"green\"
threads, based on first-class continuations.  Native threads that map directly
to the threads provided by the operating system are not supported.  The
advantage of this is that threads are very lightweight and somewhat larger
degree of determinism.  The disadvantage is that execution of Scheme code on
multiple processor cores is not available.")
    (license license:bsd-3)))

(define-public chicken-srfi-69
  (package
    (name "chicken-srfi-69")
    (version "0.4.1")
    (source
     (origin
       (method svn-fetch)
       (uri (svn-reference
             (url (string-append "https://code.call-cc.org/svn/chicken-eggs/"
                                 "release/5/srfi-69/tags/"
                                 version))
             (revision 39057)
             (user-name "anonymous")
             (password "")))
       (file-name (string-append "chicken-srfi-69-" version "-checkout"))
       (sha256
        (base32
         "1z0m9vmg9bj9z0a941pls6igvg8nmhq4mj5psjjidbp0fac572mp"))))
    (arguments '(#:egg-name "srfi-69"))
    (build-system chicken-build-system)
    (home-page "https://wiki.call-cc.org/eggref/5/srfi-69")
    (synopsis "Implementation of SRFI 69 with SRFI 90 extensions")
    (description
     "This package provides an implementation of
@uref{https://srfi.schemers.org/srfi-69/srfi-69.html, SRFI-69 hash tables} for
CHICKEN Scheme, along with
@uref{https://srfi.schemers.org/srfi-90/srfi-90.html, SRFI-90} extensions.")
    (license license:bsd-3)))

(define-public chicken-agrep
  (package
    (name "chicken-agrep")
    (version "1.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/iraikov/chicken-agrep")
             (commit version)))
       (file-name (string-append "chicken-agrep-" version "-checkout"))
       (sha256
        (base32
         "0z05x7f154n9bgmainrsmncf5i6dil43r9ymr3rdgwbg4wnxmz4s"))))
    ;; TODO do we really have to make these propagated?
    ;; I don't know Chicken's module system well enough to tell
    (propagated-inputs
     (list chicken-datatype chicken-srfi-1 chicken-srfi-14))
    (inputs
     (list chicken-test))
    (build-system chicken-build-system)
    (arguments '(#:egg-name "agrep"))
    (synopsis "Approximate string matching library")
    (home-page "https://wiki.call-cc.org/eggref/5/agrep")
    (description
     "This library implements the Wu-Manber algorithm for approximate string
searching with errors, popularized by the agrep Unix command and the glimpse
file indexing tool.")
    (license license:gpl3+)))

(define-public chicken-datatype
  (package
    (name "chicken-datatype")
    (version "1.6")
    (source
     (origin
       (method svn-fetch)
       (uri (svn-reference
             (url (string-append "https://code.call-cc.org/svn/chicken-eggs/"
                                 "release/5/datatype/tags/" version))
             (revision 39266)
             (user-name "anonymous")
             (password "")))
       (file-name (string-append "chicken-datatype-" version "-checkout"))
       (sha256
        (base32
         "1a58q8ypjkjz6wdv25247wixds4179239d36nnvsfn6gp70s9jfq"))))
    (build-system chicken-build-system)
    (arguments '(#:egg-name "datatype"))
    (inputs
     (list chicken-srfi-1 chicken-test))
    (home-page "https://wiki.call-cc.org/eggref/5/datatype")
    (synopsis "Facility for creating and using variant records")
    (description
     "This CHICKEN Scheme library provides a facility for creating and using
variant records, as described in the book @i{Essentials of Programming
Languages} by Friedman, Wand, and Haynes.")
    (license license:bsd-3)))

(define-public chicken-iset
  (package
    (name "chicken-iset")
    (version "2.2")
    (source
     (origin
       (method svn-fetch)
       (uri (svn-reference
             (url (string-append "https://code.call-cc.org/svn/chicken-eggs/"
                                 "release/5/iset/tags/" version))
             (revision 39057)
             (user-name "anonymous")
             (password "")))
       (file-name (string-append "chicken-iset-" version "-checkout"))
       (sha256
        (base32
         "0gz50n5i561n5sk9prry0lrxz6bfrq9if5bclaq6a0f7lzinhnzb"))))
    (inputs
     (list chicken-test))
    (build-system chicken-build-system)
    (arguments '(#:egg-name "iset"))
    (synopsis "Integer set library")
    (home-page "https://wiki.call-cc.org/eggref/5/iset")
    (description
     "This ``integer set'' CHICKEN Scheme library implements bit vectors.
Bit-vectors provide an abstract interface to bitwise operations typically done
with integers.")
    (license license:bsd-3)))

(define-public chicken-test
  (package
    (name "chicken-test")
    (version "1.1")
    (source
     (origin
       (method svn-fetch)
       (uri (svn-reference
             (url (string-append "https://code.call-cc.org/svn/chicken-eggs/"
                                 "release/5/test/tags/" version))
             (revision 39263)
             (user-name "anonymous")
             (password "")))
       (file-name (string-append "chicken-test-" version "-checkout"))
       (sha256
        (base32
         "14i91cxsn6hjkx6kqf7i9syck73cw71jik61jmhg87vpxx5kfnzx"))))
    (build-system chicken-build-system)
    (arguments '(#:egg-name "test"))
    (home-page "https://wiki.call-cc.org/eggref/5/test")
    (synopsis "Yet another testing utility")
    (description
     "This package provides a simple testing utility for CHICKEN Scheme.")
    (license license:bsd-3)))

(define-public chicken-crypto-tools
  (package
    (name "chicken-crypto-tools")
    (version "1.4")
    (source (origin
              (method url-fetch)
              (uri (egg-uri "crypto-tools" version))
              (sha256
               (base32
                "0ajf0qfnhp99f4x1dll2fhlxrsxamgrrwyksc7rrym77xmv8f1pd"))))
    (build-system chicken-build-system)
    (arguments '(#:egg-name "crypto-tools"))
    (home-page "https://wiki.call-cc.org/egg/crypto-tools")
    (synopsis "Useful cryptographic primitives")
    (description "The crypto-tools egg implements useful cryptographic
primitives.  More specifically, provided are:

@itemize
@item binary blobs
@itemize
@item marshallers to and from hex strings
@item blob xor
@item blob padding using either PKCS#5 or ISO7816-4
@end itemize
@item Block cipher modes of operation
@itemize
@item CBC with or without incorporated encrypted IV in the ciphertext
@item CTR with or without incorporated IV in the ciphertext
@end itemize
@end itemize")
    (license license:bsd-3)))
