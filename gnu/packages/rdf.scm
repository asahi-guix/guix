;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2014, 2015 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2015, 2016, 2018 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2018–2021 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2019 Julien Lepiller <julien@lepiller.eu>
;;; Copyright © 2020 Alexandros Theodotou <alex@zrythm.org>
;;; Copyright © 2020 Pjotr Prins <pjotr.guix@thebird.nl>
;;; Copyright © 2020 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2020 pukkamustard <pukkamustard@posteo.net>
;;; Copyright © 2022 Marius Bakke <marius@gnu.org>
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

(define-module (gnu packages rdf)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix build-system waf)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages cyrus-sasl)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages dbm)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages time)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages xml))

(define-public raptor2
  (package
    (name "raptor2")
    (version "2.0.15")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.librdf.org/source/" name
                                 "-" version ".tar.gz"))
             (patches
              (search-patches "raptor2-heap-overflow.patch"))
             (sha256
              (base32
               "1vc02im4mpc28zxzgli68k6j0dakh0k3s389bm436yvqajxg19xd"))))
    (build-system gnu-build-system)
    (inputs
     (list curl libxml2 libxslt zlib))
    (arguments
     `(#:parallel-tests? #f))
    (home-page "https://librdf.org/raptor/")
    (synopsis "RDF syntax library")
    (description "Raptor is a C library providing a set of parsers and
serialisers that generate Resource Description Framework (RDF) triples
by parsing syntaxes or serialise the triples into a syntax.  The supported
parsing syntaxes are RDF/XML, N-Quads, N-Triples 1.0 and 1.1, TRiG,
Turtle 2008 and 2013, RDFa 1.0 and 1.1, RSS tag soup including all versions
of RSS, Atom 1.0 and 0.3, GRDDL and microformats for HTML, XHTML and
XML.  The serialising syntaxes are RDF/XML (regular, abbreviated, XMP),
Turtle 2013, N-Quads, N-Triples 1.1, Atom 1.0, RSS 1.0, GraphViz DOT,
HTML and JSON.")
    (license license:lgpl2.1+))) ; or any choice of gpl2+ or asl2.0

(define-public clucene
  (package
    (name "clucene")
    (version "2.3.3.4")
    (source (origin
             (method url-fetch)
             (uri (string-append "mirror://sourceforge/clucene/"
                                 "clucene-core-unstable/2.3/clucene-core-"
                                 version ".tar.gz"))
             (sha256
              (base32
               "1arffdwivig88kkx685pldr784njm0249k0rb1f1plwavlrw9zfx"))
             (patches (search-patches "clucene-pkgconfig.patch"
                                      "clucene-contribs-lib.patch"))))
    (build-system cmake-build-system)
    (inputs
     (list boost ; could also use bundled copy
           zlib))
    (arguments
     `(#:test-target "cl_test"
       #:configure-flags '("-DBUILD_CONTRIBS_LIB=ON")
       #:tests? #f)) ; Tests do not compile, as TestIndexSearcher.cpp uses
                     ; undeclared usleep. After fixing this, one needs to run
                     ; "make test" in addition to "make cl_test", then
                     ; SimpleTest fails.
                     ; Notice that the library appears to be unmaintained
                     ; with no reaction to bug reports.
    (home-page "http://clucene.sourceforge.net/")
    (synopsis "C text indexing and searching library")
    (description "CLucene is a high-performance, scalable, cross platform,
full-featured indexing and searching API.  It is a port of the very popular
Java Lucene text search engine API to C++.")
    (license license:lgpl2.1)))

(define-public lucene++
  (package
    (name "lucene++")
    (version "3.0.8")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/luceneplusplus/LucenePlusPlus")
                     (commit (string-append "rel_" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "12v7r62f7pqh5h210pb74sfx6h70lj4pgfpva8ya2d55fn0qxrr2"))
              (modules '((guix build utils)))
              (snippet
               #~(begin
                   (substitute* (list "src/config/core/CMakeLists.txt"
                                      "src/config/contrib/CMakeLists.txt")
                     (("include/pkgconfig")
                      "lib/pkgconfig")
                     (("include/cmake")
                      "share/cmake/lucene++"))))))
    (build-system cmake-build-system)
    (arguments
     (list #:configure-flags
           #~(list (string-append "-DLIB_DESTINATION:PATH="
                                  #$output "/lib")
                   "-DINSTALL_GTEST:BOOL=OFF")
           #:phases
           #~(modify-phases %standard-phases
               (replace 'check
                 ;; XXX Tests are built unconditionally during the 'build phase.
                 ;; There's no ‘test’ target.  README.md suggests running this.
                 (lambda* (#:key tests? #:allow-other-keys)
                   (when tests?
                     (invoke "src/test/lucene++-tester"
                             "--test_dir=../source/src/test/testfiles")))))))
    (native-inputs
     (list pkg-config))
    (inputs
     (list boost zlib))
    (home-page "https://github.com/luceneplusplus/LucenePlusPlus")
    (synopsis "Text search engine")
    (description "Lucene++ is an up to date C++ port of the popular Java
Lucene library, a high-performance, full-featured text search engine.")
    (license (list license:asl2.0 license:lgpl3+)))); either asl or lgpl.

(define-public lrdf
  (package
    (name "lrdf")
    (version "0.6.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/swh/LRDF")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "00wzkfb8y0aqd519ypz067cq099dpc89w69zw8ln39vl6f9x2pd4"))))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'remove-out-of-tree-references
           (lambda _
             ;; remove_test depends on an out-of-tree RDF file
             (substitute* "examples/Makefile.am"
               (("instances_test remove_test") "instances_test")
               (("\\$\\(TESTS\\) remove_test") "$(TESTS)"))
             #t))
         ;; The default bootstrap phase executes autogen.sh, which fails.
         (replace 'bootstrap
           (lambda _ (invoke "autoreconf" "-vif") #t)))))
    (inputs
     `(("raptor" ,raptor2)
       ("cyrus-sasl" ,cyrus-sasl)
       ("zlib" ,zlib)))
    (native-inputs
     (list autoconf automake libtool pkg-config))
    (home-page "https://github.com/swh/LRDF")
    (synopsis "Lightweight RDF library for accessing LADSPA plugin metadata")
    (description
     "LRDF is a library to make it easy to manipulate RDF files describing
LADSPA plugins.  It can also be used for general RDF manipulation.  It can
read RDF/XLM and N3 files and export N3 files, and it also has a light
taxonomic inference capability.")
    (license license:gpl2)))

(define-public rasqal
  (package
    (name "rasqal")
    (version "0.9.33")
    (source (origin
             (method url-fetch)
             (uri (string-append "http://download.librdf.org/source/" name
                                 "-" version ".tar.gz"))
             (sha256
              (base32
               "0z6rrwn4jsagvarg8d5zf0j352kjgi33py39jqd29gbhcnncj939"))))
    (build-system gnu-build-system)
    (native-inputs
     (list perl perl-xml-dom ; for the tests
           pkg-config))
    (inputs
     (list libgcrypt libxml2 mpfr pcre
           `(,util-linux "lib")))
    (propagated-inputs
     (list raptor2)) ; stipulated by rasqal.pc
    (arguments
     `(#:parallel-tests? #f
       ; test failure reported upstream, see
       ; http://bugs.librdf.org/mantis/view.php?id=571
       #:tests? #f))
    (home-page "http://librdf.org/rasqal/")
    (synopsis "RDF query library")
    (description "Rasqal is a C library that handles Resource Description
Framework (RDF) query language syntaxes, query construction and execution
of queries returning results as bindings, boolean, RDF graphs/triples or
syntaxes.  The supported query languages are SPARQL Query 1.0,
SPARQL Query 1.1, SPARQL Update 1.1 (no executing) and the Experimental
SPARQL extensions (LAQRS).  Rasqal can write binding query results in the
SPARQL XML, SPARQL JSON, CSV, TSV, HTML, ASCII tables, RDF/XML and
Turtle/N3 and read them in SPARQL XML, RDF/XML and Turtle/N3.")
    (license license:lgpl2.1+))) ; or any choice of gpl2+ or asl2.0

(define-public redland
  (package
    (name "redland")
    (version "1.0.17")
    (source (origin
             (method url-fetch)
             (uri (string-append "http://download.librdf.org/source/" name
                                 "-" version ".tar.gz"))
             (sha256
              (base32
               "109n0kp39p966dpiasad2bb7q66rwbcb9avjvimw28chnpvlf66y"))))
    (build-system gnu-build-system)
    (native-inputs
     (list perl ; needed for installation
           pkg-config))
    (propagated-inputs
     (list rasqal)) ; in Requires.private field of .pc
    (inputs
     (list bdb))
    (home-page "http://librdf.org/")
    (synopsis "RDF library")
    (description "The Redland RDF Library (librdf) provides the RDF API
and triple stores.")
    (license license:lgpl2.1+))) ; or any choice of gpl2+ or asl2.0

(define-public serd
  (package
    (name "serd")
    (version "0.30.8")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.drobilla.net/serd-"
                                 version ".tar.bz2"))
             (sha256
              (base32
               "11zs53yx40mv62vxsl15mvdh7s17y5v6lgcgahdvzxgnan7w8bk7"))))
    (build-system waf-build-system)
    (arguments
     `(#:tests? #f                      ; no check target
       #:phases
       (modify-phases %standard-phases
         (add-before
          'configure 'set-ldflags
          (lambda* (#:key outputs #:allow-other-keys)
            (setenv "LDFLAGS"
                    (string-append "-Wl,-rpath="
                                   (assoc-ref outputs "out") "/lib"))
            #t)))))
    (home-page "https://drobilla.net/software/serd/")
    (synopsis "Library for RDF syntax supporting Turtle and NTriples")
    (description
     "Serd is a lightweight C library for RDF syntax which supports reading
and writing Turtle and NTriples.  Serd is not intended to be a swiss-army
knife of RDF syntax, but rather is suited to resource limited or performance
critical applications (e.g. converting many gigabytes of NTriples to Turtle),
or situations where a simple reader/writer with minimal dependencies is
ideal (e.g. in LV2 implementations or embedded applications).")
    (license license:isc)))

(define-public sord
  (package
    (name "sord")
    (version "0.16.8")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://download.drobilla.net/sord-"
                                 version ".tar.bz2"))
             (sha256
              (base32
               "052y7zllrg0bzyky2rmrrwnnf16p6bk7q40rq9mgm0mzm8p9sa3w"))))
    (build-system waf-build-system)
    (arguments
     `(#:tests? #f                      ; no check target
       #:phases
       (modify-phases %standard-phases
         (add-before
          'configure 'set-ldflags
          (lambda* (#:key outputs #:allow-other-keys)
            (setenv "LDFLAGS"
                    (string-append "-Wl,-rpath="
                                   (assoc-ref outputs "out") "/lib"))
            #t)))))
    (inputs
     (list pcre))
    (native-inputs
     (list pkg-config))
    (propagated-inputs
     (list serd))                 ; required by sord-0.pc
    (home-page "https://drobilla.net/software/sord/")
    (synopsis "C library for storing RDF data in memory")
    (description
     "Sord is a lightweight C library for storing RDF data in memory.")
    (license license:isc)))

(define-public python-rdflib
  (package
    (name "python-rdflib")
    (version "6.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rdflib" version))
        (sha256
         (base32
          "0m7pyq771vl4zf9xd3pxjbg7x6ac97b3djfbv9qq9fch56ps1gwd"))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'adjust-tests
           (lambda _
             (for-each delete-file
                       '(;; This test needs a font that is not shipped.
                         "test/test_so_69984830.py"
                         ;; These tests need internet access.
                         "test/jsonld/test_onedotone.py"
                         "test/test_sparql_service.py"
                         "test/test_graph.py"))))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (invoke "pytest" "-vv" "test/")))))))
    (native-inputs
     (list python-pytest))
    (propagated-inputs
      (list python-html5lib python-isodate python-pyparsing))
    (home-page "https://github.com/RDFLib/rdflib")
    (synopsis "Python RDF library")
    (description
      "RDFLib is a Python library for working with RDF, a simple yet
powerful language for representing information.")
    (license (license:non-copyleft "file://LICENSE"
                                   "See LICENSE in the distribution."))))

(define-public python-rdflib-5
  (package
    (inherit python-rdflib)
    (version "5.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rdflib" version))
        (sha256
         (base32
          "0mdi7xh4zcr3ngqwlgqdqf0i5bxghwfddyxdng1zwpiqkpa9s53q"))))
    ;; XXX: Lazily disable tests because they require a lot of work
    ;; and this package is only transitional.
    (arguments '(#:tests? #f))))

(define-public python2-rdflib
  (package-with-python2 python-rdflib-5))

;; Note: This package is only needed for rdflib < 6.0; supersede when
;; the above are removed.
(define-public python-rdflib-jsonld
  (package
    (name "python-rdflib-jsonld")
    (version "0.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rdflib-jsonld" version))
        (sha256
         (base32
          "1v85f4hdlrrk0l1najmqmm79ijrvcj259kwsrrxiq1q5chr5azag"))))
    (build-system python-build-system)
    (native-inputs
     (list python-nose))
    (propagated-inputs
     (list python-rdflib))
    (home-page "https://github.com/RDFLib/rdflib-jsonld")
    (synopsis "rdflib extension adding JSON-LD parser and serializer")
    (description "This package provides an rdflib extension adding JSON-LD
parser and serializer.")
    (license license:bsd-3)))

(define-public python-cfgraph
  (package
    (name "python-cfgraph")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "CFGraph" version))
        (sha256
         (base32
          "0x7yz0lvqb6mkhl5fbml27sppmscgpf8v2ism9jzzf0h982ffzxm"))))
    (build-system python-build-system)
    (propagated-inputs
     (list python-rdflib))
    (home-page "https://github.com/hsolbrig/CFGraph")
    (synopsis "RDF Collections flattener for rdflib")
    (description
     "This package contains RDF Collections flattener for @code{rdflib}.")
    (license license:asl2.0)))

(define-public hdt-cpp
  (package
    (name "hdt-cpp")
    (version "1.3.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/rdfhdt/hdt-cpp")
                     (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1vsq80jnix6cy78ayag7v8ajyw7h8dqyad1q6xkf2hzz3skvr34z"))))
    (build-system gnu-build-system)
    (inputs
     (list serd zlib))
    (native-inputs
     (list autoconf automake libtool pkg-config))
    (home-page "https://github.com/rdfhdt/hdt-cpp")
    (synopsis "C++ implementation of the HDT compression format")
    (description "Header Dictionary Triples (HDT) is a compression format for
RDF data that can also be queried for Triple Patterns.  This package provides a
C++ library as well as various command-line tools to to work with HDT.")
(license license:lgpl2.1+)))

(define-public python-sparqlwrapper
  (package
    (name "python-sparqlwrapper")
    (version "1.8.5")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/RDFLib/sparqlwrapper.git")
                     (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1ia5h06zf6kpw6gdi7f80pzx10m79brj08zrbffb5wn9hzz8x528"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; The test suite simply queries external HTTP endpoints.
    (native-inputs
     (list python-nose))
    (propagated-inputs
     (list python-rdflib))
    (home-page "https://rdflib.dev/sparqlwrapper/")
    (synopsis "SPARQL Endpoint interface to Python")
    (description "Python wrapper around a SPARQL service.  It helps in creating
the query URI and, possibly, convert the result into a more manageable
format.")
    (license license:w3c)))
