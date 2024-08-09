;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 Ethan R. Jones <doubleplusgood23@gmail.com>
;;; Copyright © 2018–2021 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Fis Trivial <ybbs.daans@hotmail.com>
;;; Copyright © 2018, 2021, 2023 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2019, 2020, 2022 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2019 Pierre Neidhardt <mail@ambrevar.xyz>
;;; Copyright © 2019 Jan Wielkiewicz <tona_kosmicznego_smiecia@interia.pl>
;;; Copyright © 2020, 2021 Nicolò Balzarotti <nicolo@nixo.xyz>
;;; Copyright © 2020 Roel Janssen <roel@gnu.org>
;;; Copyright © 2020, 2021, 2023, 2024 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2020 Brice Waegeneire <brice@waegenei.re>
;;; Copyright © 2020, 2021, 2022, 2024 Vinicius Monego <monego@posteo.net>
;;; Copyright © 2020, 2022 Marius Bakke <marius@gnu.org>
;;; Copyright © 2020 Michael Rohleder <mike@rohleder.de>
;;; Copyright © 2020 Alexandros Theodotou <alex@zrythm.org>
;;; Copyright © 2020-2022 Greg Hogan <code@greghogan.com>
;;; Copyright © 2020 Brett Gilio <brettg@gnu.org>
;;; Copyright © 2020 Milkey Mouse <milkeymouse@meme.institute>
;;; Copyright © 2021 Raghav Gururajan <rg@raghavgururajan.name>
;;; Copyright © 2021 Felix Gruber <felgru@posteo.net>
;;; Copyright © 2021 Nicolò Balzarotti <nicolo@nixo.xyz>
;;; Copyright © 2021 Guillaume Le Vaillant <glv@posteo.net>
;;; Copyright © 2021 Nikolay Korotkiy <sikmir@disroot.org>
;;; Copyright © 2021 jgart <jgart@dismail.de>
;;; Copyright © 2021 Julien Lepiller <julien@lepiller.eu>
;;; Copyright © 2021 Disseminate Dissent <disseminatedissent@protonmail.com>
;;; Copyright © 2022-2024 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2022 muradm <mail@muradm.net>
;;; Copyright © 2022 Attila Lendvai <attila@lendvai.name>
;;; Copyright © 2022 Arun Isaac <arunisaac@systemreboot.net>
;;; Copyright © 2022, 2023, 2024 David Elsing <david.elsing@posteo.net>
;;; Copyright © 2022-2024 Zheng Junjie <873216071@qq.com>
;;; Copyright © 2022, 2023, 2024 Maxim Cournoyer <maxim.cournoyer@gmail.com>
;;; Copyright © 2022 Antero Mejr <antero@mailbox.org>
;;; Copyright © 2023 Sughosha <Sughosha@proton.me>
;;; Copyright © 2023 Artyom V. Poptsov <poptsov.artyom@gmail.com>
;;; Copyright © 2023 Liliana Marie Prikler <liliana.prikler@gmail.com>
;;; Copyright © 2023 Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>
;;; Copyright © 2023 Foundation Devices, Inc. <hello@foundationdevices.com>
;;; Copyright © 2023 Paul A. Patience <paul@apatience.com>
;;; Copyright © 2024 dan <i@dan.games>
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

(define-module (gnu packages cpp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system python)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system scons)
  #:use-module (guix modules)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages assembly)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bdw-gc)
  #:use-module (gnu packages benchmark)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages c)
  #:use-module (gnu packages check)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages code)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages datastructures)
  #:use-module (gnu packages disk)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages libunwind)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages logging)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages onc-rpc)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages popt)
  #:use-module (gnu packages pretty-print)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  ;; Using autoload to avoid a cycle.
  ;; Note that (gnu packages serialization) has #:use-module (gnu packages cpp)
  #:autoload   (gnu packages serialization) (cereal)
  #:use-module (ice-9 match))

(define-public argagg
  (let ((commit "79e4adfa2c6e2bfbe63da05cc668eb9ad5596748") (revision "0"))
    (package
      (name "argagg")
      (version (git-version "0.4.6" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/vietjtnguyen/argagg")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1flkgh524lq3024p7ld5lg743s1v7qnbmgv77578rzmn2rjzr77n"))))
      (build-system cmake-build-system)
      (outputs '("out" "doc"))
      (arguments
       `(#:phases (modify-phases %standard-phases
                    (add-after 'install 'move-doc
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let* ((name ,(package-name argagg)) (out (assoc-ref
                                                                   outputs
                                                                   "out"))
                               (doc (assoc-ref outputs "doc")))
                          (mkdir-p (string-append doc "/share/doc"))
                          (rename-file
                           (string-append out "/share/doc/" name)
                           (string-append doc "/share/doc/" name))))))))
      (native-inputs (list doxygen))
      (home-page "https://github.com/vietjtnguyen/argagg")
      (synopsis "C++11 command line argument parser")
      (description
       "ArgAgg is yet another C++ command line argument/option
parser.  It was written as a simple and idiomatic alternative to other
frameworks like getopt, Boost program options, TCLAP, and others.  The goal is
to achieve the majority of argument parsing needs in a simple manner with an
easy to use API.")
      (license license:expat))))

(define-public asmjit
  (let ((commit "3ca5c186bf8922e5fe3018432e93651fd2fa4053")
        (revision "1"))
    (package
      (name "asmjit")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/asmjit/asmjit")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "10k1zc0w8m0vnh52id9qlm1sb99qmpvr6k0ha8ag2h223n0d591g"))))
      (build-system cmake-build-system)
      (arguments
       (list #:configure-flags #~(list "-DASMJIT_TEST=TRUE")))
      (home-page "https://asmjit.com/")
      (synopsis "Machine code generation for C++")
      (description "AsmJit is a lightweight library for machine code
generation written in C++ language.  It can generate machine code for X86 and
X86_64 architectures with the support for the whole instruction set from
legacy MMX to the newest AVX-512 and AMX.  It has a type-safe API that allows
C++ compiler to do semantic checks at compile-time even before the assembled
code is generated or executed.  It also provides an optional register
allocator that makes it easy to generate complex code without a significant
development effort.")
      (license license:zlib))))

(define-public castxml
  (package
    (name "castxml")
    (version "0.6.4")
    (source (origin
              (method git-fetch)
              (uri
               (git-reference
                (url "https://github.com/CastXML/CastXML")
                (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32 "0l5ys9zmllfgwhjrm897akbsf38iswfcarhxg27xfhiy0bmzcwsg"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list
         (string-append "-DCLANG_RESOURCE_DIR="
                        #$(this-package-native-input "clang") "/lib/clang/"
                        #$(version-major
                           (package-version (this-package-native-input "clang")))))))
    (inputs (list libffi))
    (native-inputs (list clang-17 llvm-17))
    (home-page "https://github.com/CastXML/CastXML")
    (synopsis "C-family abstract syntax tree XML output")
    (description "CastXML is a C-family abstract syntax tree XML output tool.
This project is maintained by Kitware in support of ITK, the Insight
Segmentation and Registration Toolkit.")
    (license license:asl2.0)))

(define-public range-v3
  (package
    (name "range-v3")
    (version "0.12.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ericniebler/range-v3.git")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0r85s5rmp5ixmik2y5y4w760pa38j1sg9hbr1fss2flibzvrf53d"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags #~(list "-DRANGES_NATIVE=OFF")))
    (native-inputs (list doxygen perl))
    (inputs (list boost))
    (synopsis "Range library for C++14/17/20")
    (description
     "Range-v3 is an extension of the Standard Template Library that
makes its iterators and algorithms more powerful by making them composable.
Unlike other range-like solutions which, seek to do away with iterators, in
range-v3 ranges are an abstraction layer on top of iterators.")
    (home-page "https://github.com/ericniebler/range-v3/")
    (license (list
              ;; Elements of Programming
              (license:x11-style "file:///LICENSE.txt")
              ;; SGI STL
              license:sgifreeb2.0
              ;; LibC++ (dual-licensed)
              license:expat
              license:ncsa
              ;; Others
              license:boost1.0))))

(define-public robin-hood-hashing
  (package
    (name "robin-hood-hashing")
    (version "3.11.5")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/martinus/robin-hood-hashing")
                    (commit version)))
              (modules '((guix build utils)))
              (snippet #~(delete-file-recursively "src/test/thirdparty"))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1qx6i09sp8c3l89mhyaql144nzh2h26ky9ms3n5l85qplx1vv2r7"))))
    (build-system cmake-build-system)
    (arguments
     (list #:tests? #f ;; Needs bundled libraries for tests.
           ;; By default this option is set to ON and removes the ability to
           ;; install the library.
           #:configure-flags
           #~(list "-DRH_STANDALONE_PROJECT=OFF")))
    (home-page "https://github.com/martinus/robin-hood-hashing")
    (synopsis "Unordered set and map data structures library")
    (description "This library provides a header-only unordered set and map
data structures for C++.")
    (license license:expat)))

(define-public c++-gsl
  (package
    (name "c++-gsl")
    (version "4.0.0")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://github.com/microsoft/GSL.git")
         (commit
          (string-append "v" version))))
       (file-name
        (git-file-name name version))
       (sha256
        (base32 "0dgb3rb6x2276d3v7x568m3zhqr67rhk8ynqgm3c304avnmcaw3i"))))
    (build-system cmake-build-system)
    (native-inputs
     (list googletest pkg-config))
    (synopsis "Guidelines Support Library")
    (description "c++-gsl contains functions and types that are suggested for
use by the C++ Core Guidelines maintained by the Standard C++ Foundation.")
    (home-page "https://github.com/microsoft/GSL/")
    (license license:expat)))

(define-public c2ffi
  (package
    (name "c2ffi")
    ;; As per the c2ffi README: the first three elements are encoding the
    ;; required Clang/LLVM version, and the last one is the c2ffi revision.
    (version "18.1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rpav/c2ffi")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03hw650wjrc4jb4ra8bwc4rnprr0fpnf3wlxzacfjysvl25jb0j6"))
       (modules '((guix build utils)))
       (snippet
        '(substitute* "CMakeLists.txt"
           ;; Guix seems to be packaging LLVM libs separately thus -lLLVM
           ;; won't work.  Instead every library used must be listed.
           (("c2ffi PUBLIC clang-cpp LLVM")
            "c2ffi PUBLIC clang-cpp LLVMCore LLVMSupport LLVMMCParser \
LLVMOption LLVMBitReader LLVMProfileData")))))
    (build-system cmake-build-system)
    (arguments
     '(;; If LLVM was built without RTTI, we need to also be built without
       ;; it.  See: https://stackoverflow.com/q/11904519
       #:configure-flags '("-DCMAKE_CXX_FLAGS=-fno-rtti")
       #:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (invoke "./bin/c2ffi" "--help")))))))
    (native-inputs
     (list clang-18)) ; CMakeLists.txt invokes `clang -print-resource-dir`
    (inputs
     (list clang-18)) ; Compiled with gcc, but links against libclang-cpp.so
    (home-page "https://github.com/rpav/c2ffi")
    (synopsis "Clang-based FFI wrapper generator")
    (description
     "@code{c2ffi} is a tool for extracting definitions from C, C++, and
Objective C headers for use with foreign function call interfaces.  It uses
the @code{Clang/LLVM} infrastructure to extract the data, and emits it in
various formats, including @code{json}.")
    (license license:gpl2+)))

(define-public expected-lite
  (package
    (name "expected-lite")
    (version "0.6.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/martinmoene/expected-lite")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0d58nqh2fwdzdpln2wlnf898wyfxdnskq6ff33azbg92d5ibzys2"))))
    (build-system cmake-build-system)
    (home-page "https://github.com/martinmoene/expected-lite")
    (synopsis "Expected objects in C++11 and later")
    (description "@i{expected lite} is a single-file header-only library for
objects that either represent a valid value or an error that can be passed by
value.  It is intended for use with C++11 and later.  The library is based on
the @code{std::expected} proposal (@url{http://wg21.link/p0323}).")
    (license license:boost1.0)))

(define-public libzen
  (package
    (name "libzen")
    (version "0.4.41")
    (source (origin
              (method url-fetch)
              ;; Warning: This source has proved unreliable 1 time at least.
              ;; Consider an alternate source or report upstream if this
              ;; happens again.
              (uri (string-append "https://mediaarea.net/download/source/"
                                  "libzen/" version "/"
                                  "libzen_" version ".tar.bz2"))
              (sha256
               (base32
                "0b8yj3rmmcv2fn3b5bnchfkk82fy4w5446c70sxccvfa7myps8zb"))))
    (native-inputs
     (list autoconf automake libtool))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       ;; The build scripts are not at the root of the archive.
       (modify-phases %standard-phases
         (add-after 'unpack 'pre-configure
           (lambda _
             (chdir "Project/GNU/Library"))))))
    (home-page "https://github.com/MediaArea/ZenLib")
    (synopsis "C++ utility library")
    (description "ZenLib is a C++ utility library.  It includes classes for handling
strings, configuration, bit streams, threading, translation, and cross-platform
operating system functions.")
    (license license:zlib)))

(define-public rttr
  (package
    (name "rttr")
    (version "0.9.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rttrorg/rttr/")
             (commit (string-append "v" version))))
       (sha256
        (base32 "1yxad8sj40wi75hny8w6imrsx8wjasjmsipnlq559n4b6kl84ijp"))
       (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     '(;; No check target. Setting test-target to "unit_test" runs it twice.
       #:tests? #f
       #:configure-flags
       '("-DBUILD_DOCUMENTATION=OFF" "-DBUILD_EXAMPLES=OFF")
       #:phases
       (modify-phases %standard-phases
         ;; library_test fails in chroot.
         (add-after 'unpack 'skip-library-test
           (lambda _
             (substitute* "src/unit_tests/unit_tests.cmake"
               (("misc/library_test.cpp") ""))
             #t)))))
    (native-inputs (list pkg-config))
    (home-page "https://github.com/rttrorg/rttr/")
    (synopsis "C++ Reflection Library")
    (description
     "RTTR stands for Run Time Type Reflection.  It describes the ability of a
computer program to introspect and modify an object at runtime.  It is also
the name of the library itself, which is written in C++.")
    (license license:expat)))

(define-public rct
  (let* ((commit "b3e6f41d9844ef64420e628e0c65ed98278a843a")
         (revision "2"))
    (package
      (name "rct")
      (version (git-version "0.0.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/Andersbakken/rct")
                      (commit commit)))
                (sha256
                 (base32
                  "1m2931jacka27ghnpgf1z1plkkr64z0pga4r4zdrfpp2d7xnrdvb"))
                (patches (search-patches "rct-add-missing-headers.patch"))
                (file-name (git-file-name name version))))
      (build-system cmake-build-system)
      (arguments
       '(#:configure-flags
         '("-DWITH_TESTS=ON"            ; To run the test suite
           "-DRCT_RTTI_ENABLED=ON")))
      (native-inputs
       (list cppunit pkg-config))
      (inputs
       (list openssl zlib))
      (home-page "https://github.com/Andersbakken/rct")
      (synopsis "C++ library providing Qt-like APIs on top of the STL")
      (description "Rct is a set of C++ tools that provide nicer (more Qt-like)
 APIs on top of Standard Template Library (@dfn{STL}) classes.")
      (license (list license:expat        ; cJSON
                     license:bsd-4)))))   ; everything else (LICENSE.txt)

(define-public pystring
  (package
    (name "pystring")
    (version "1.1.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/imageworks/pystring")
             (commit (string-append "v" version))))
       (sha256
        (base32 "0h12x24skrlx4fv0k5vl8wnar8gi6bq091yp93awkwsbnm8qwkzd"))
       (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     (list #:phases
           #~(modify-phases %standard-phases
               ;; The install phase doesn't install the header
               (add-after 'install 'install-header
                 (lambda _
                   (mkdir-p (string-append #$output "/include"))
                   (copy-file
                    (string-append #$(package-source this-package)
                                   "/pystring.h")
                    (string-append #$output
                                   "/include/pystring.h")))))))
    (native-inputs (list pkg-config))
    (home-page "https://github.com/imageworks/pystring")
    (synopsis "C++ functions matching the Python string methods")
    (description
     "Pystring is a collection of C++ functions which match the interface and
behavior of Python's string class methods using std::string.  Implemented in
C++, it does not require or make use of a python interpreter.  It provides
convenience and familiarity for common string operations not included in the
standard C++ library.  It's also useful in environments where both C++ and
Python are used.")
    (license license:bsd-3)))

(define-public dashel
  (package
    (name "dashel")
    (version "1.3.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/aseba-community/dashel")
             (commit version)))
       (sha256
        (base32 "0anks2l2i2qp0wlzqck1qgpq15a3l6dg8lw2h8s4nsj7f61lffwy"))
       (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments '(#:tests? #f))          ; no tests
    (native-inputs (list pkg-config))
    (home-page "https://github.com/aseba-community/dashel")
    (synopsis "Data stream helper encapsulation library")
    (description
     "Dashel is a data stream helper encapsulation C++ library.  It provides a
unified access to TCP/UDP sockets, serial ports, console, and files streams.
It also allows a server application to wait for any activity on any
combination of these streams.")
    (license license:bsd-3)))

(define-public xsimd
  (package
    (name "xsimd")
    (version "9.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/QuantStack/xsimd")
             (commit version)))
       (sha256
        (base32 "1fcy0djwpwvls6yqxqa82s4l4gvwkqkr8i8bibbb3dm0lqvhnw52"))
       (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags (list "-DBUILD_TESTS=ON")
       #:test-target "xtest"))
    (native-inputs
     (list googletest))
    (home-page "https://github.com/xtensor-stack/xsimd")
    (synopsis "C++ wrappers for SIMD intrinsics and math implementations")
    (description
     "xsimd provides a unified means for using @acronym{SIMD, single instruction
multiple data} features for library authors.  Namely, it enables manipulation of
batches of numbers with the same arithmetic operators as for single values.
It also provides accelerated implementation of common mathematical functions
operating on batches.")
    (license license:bsd-3)))

(define-public google-highway
  (package
    (name "google-highway")
    (version "1.0.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/highway")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0cx38hnislqyd4vd47mlpgjpr1zmpf1fms2bj6nb00fjv53q1sb7"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags (list "-DHWY_SYSTEM_GTEST=on"
                               "-DBUILD_SHARED_LIBS=ON")
       ,@(if (string-prefix? "i686-linux" (or (%current-system)
                                              (%current-target-system)))
             '(#:phases
               (modify-phases %standard-phases
                 (add-after 'unpack 'really-skip-precision-tests
                   (lambda _
                     (substitute* "hwy/contrib/math/math_test.cc"
                       (("Skipping math_test due to GCC issue with excess precision.*" m)
                        (string-append m "return;\n")))))))
             '())))
    (native-inputs
     (list googletest))
    (home-page "https://github.com/google/highway")
    (synopsis "SIMD library with runtime dispatch")
    (description "Highway is a performance-portable, length-agnostic C++
library for SIMD (Single Instruction, Multiple Data) with runtime dispatch.")
    (license license:asl2.0)))

(define-public xsimd-benchmark
  (package
    (inherit xsimd)
    (name "xsimd-benchmark")
    (arguments
     `(#:configure-flags (list "-DBUILD_BENCHMARK=ON" "-DBUILD_EXAMPLES=ON")
       #:tests? #f
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'remove-march=native
                    (lambda _
                      (substitute* "benchmark/CMakeLists.txt"
                        (("-march=native") ""))))
                  (replace 'install
                    (lambda* (#:key outputs #:allow-other-keys)
                      ;; Install nothing but the executables.
                      (let ((out (assoc-ref outputs "out")))
                        (install-file "benchmark/benchmark_xsimd"
                                      (string-append out "/bin"))
                        (install-file "examples/mandelbrot"
                                      (string-append out "/bin"))))))))
    (synopsis "Benchmark of the xsimd library")

    ;; Mark as tunable to take advantage of SIMD code in xsimd/xtensor.
    (properties '((tunable? . #t)))))

(define-public chaiscript
  (package
    (name "chaiscript")
    (version "6.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ChaiScript/ChaiScript")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0i1c88rn1wwz8nf3dpapcdkk4w623m3nksfy5yjai10k9irkzy3c"))
       (modules '((guix build utils)))
       ;; It's bundled catch2 fails to build.
       (snippet '(begin
                   (delete-file "unittests/catch.hpp")
                   (substitute* "unittests/compiled_tests.cpp"
                     (("catch[.]hpp") "catch2/catch.hpp"))
                   (substitute* "unittests/type_info_test.cpp"
                     (("catch[.]hpp") "catch2/catch.hpp"))))))
    (build-system cmake-build-system)
    (inputs (list catch2))
    (home-page "https://chaiscript.com/")
    (synopsis "Embedded scripting language designed for C++")
    (description
     "ChaiScript is one of the only embedded scripting language designed from
the ground up to directly target C++ and take advantage of modern C++
development techniques.  Being a native C++ application, it has some advantages
over existing embedded scripting languages:

@enumerate
@item Uses a header-only approach, which makes it easy to integrate with
existing projects.
@item Maintains type safety between your C++ application and the user scripts.
@item Supports a variety of C++ techniques including callbacks, overloaded
functions, class methods, and stl containers.
@end enumerate\n")
    (license license:bsd-3)))

(define-public fifo-map
  (package
    (name "fifo-map")
    (version "1.0.0")
    (home-page "https://github.com/nlohmann/fifo_map")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url home-page)
                    (commit (string-append "v" version))))
              (sha256
               (base32
                "0y59fk6ycrgjln9liwcja3l5j1vxpa5i671bynpbsjlyq5f2560q"))
              (patches (search-patches "fifo-map-remove-catch.hpp.patch"
                                       "fifo-map-fix-flags-for-gcc.patch"))
              (file-name (git-file-name name version))
              (modules '((guix build utils)))
              (snippet '(delete-file-recursively "./test/thirdparty"))))
    (inputs
     (list catch2-1))
    (build-system cmake-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests? (invoke "./unit"))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (inc (string-append out "/include/fifo_map")))
               (with-directory-excursion "../source"
                 (install-file "src/fifo_map.hpp" inc))))))))
    (synopsis "FIFO-ordered associative container for C++")
    (description "Fifo_map is a C++ header only library for associative
container which uses the order in which keys were inserted to the container
as ordering relation.")
    (license license:expat)))

(define-public frozen
  ;; The test suite fails to compile with the latest 1.1.1 release; use a
  ;; newer commit (see:
  ;; https://github.com/serge-sans-paille/frozen/issues/163).
  (let ((commit "dd1f58c5f6c97fbf0832cc4e84676663839b913e")
        (revision "0"))
    (package
      (name "frozen")
      (version (git-version "1.1.1" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/serge-sans-paille/frozen")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "06i307a7v6alxfy24d47b1sjkz5f4mrqwl2vb4j8zx7wlgnrf08b"))))
      (build-system cmake-build-system)
      (home-page "https://github.com/serge-sans-paille/frozen")
      (synopsis "C++ constexpr alternative header-only library")
      (description "@code{frozen} is a header-only library that provides zero
cost initialization for immutable containers, fixed-size containers, and
various algorithms.  It provides features such as:
@itemize
@item
immutable (also known as frozen), @code{constexpr}-compatible versions of
{std::set}, {std::unordered_set}, {std::map} and {std::unordered_map}
@item
fixed-capacity, @code{constinit}-compatible versions of @code{std::map} and
@code{std::unordered_map} with immutable, compile-time selected keys mapped to
mutable values.
@item
zero cost initialization version of @code{std::search} for frozen needles
using Boyer-Moore or Knuth-Morris-Pratt algorithms.
@end itemize
The @code{unordered_*} containers are guaranteed perfect (no hash
collision) and the extra storage is linear with respect to the number of
keys.")
      (license license:asl2.0))))

(define-public json-dto
  (package
    (name "json-dto")
    (version "0.3.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Stiffstream/json_dto")
                    (commit (string-append "v." version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0wr1srp08fr2mv4fmnqr626pwiw60svn6wkvy2xg7j080mgwb3ml"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags #~(list "-DJSON_DTO_INSTALL_SAMPLES=OFF")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'change-directory
            (lambda _
              (chdir "dev"))))))
    (native-inputs (list catch2))
    (propagated-inputs (list rapidjson))    ;#include'd
    (home-page "https://github.com/Stiffstream/json_dto")
    (synopsis "JSON to C++ structures conversion library")
    (description "@code{json_dto} library is a small header-only helper for
converting data between JSON representation and C++ structs.  DTO stands for
data transfer object.")
    (license license:bsd-3)))

(define-public nlohmann-json
  (package
    (name "nlohmann-json")
    (version "3.11.2")
    (home-page "https://github.com/nlohmann/json")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url home-page)
                           (commit (string-append "v" version))))
       (sha256
        (base32 "0g6rfsbkvrxmacchz4kbr741yybj7mls3r4hgyfdd3pdbqhn2is9"))
       (file-name (git-file-name name version))
       (modules '((guix build utils)))
       (snippet
        #~(begin
            ;; Delete bundled software.  Preserve doctest_compatibility.h, which
            ;; is a wrapper library added by this package.
            (install-file "./tests/thirdparty/doctest/doctest_compatibility.h"
                          "/tmp")
            (delete-file-recursively "./tests/thirdparty")
            (install-file "/tmp/doctest_compatibility.h"
                          "./tests/thirdparty/doctest")

            ;; Adjust for the unbundled fifo_map and doctest.
            (substitute* (find-files "./tests/" "\\.h(pp)?")
              (("#include \"doctest\\.h\"") "#include <doctest/doctest.h>")
              (("#include <doctest\\.h>") "#include <doctest/doctest.h>"))
            (with-directory-excursion "tests/src"
              (let ((files (find-files "." "\\.cpp$")))
                (substitute* files
                  (("#include ?\"(fifo_map.hpp)\"" all fifo-map-hpp)
                   (string-append
                    "#include <fifo_map/" fifo-map-hpp ">")))))))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "-DJSON_MultipleHeaders=ON" ; For json_fwd.hpp.
              (string-append "-DJSON_TestDataDirectory="
                             (dirname
                              (search-input-directory %build-inputs
                                                      "json_nlohmann_tests"))))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'check
            (lambda* (#:key tests? parallel-tests? #:allow-other-keys)
              (if tests?
                  ;; Some tests need git and a full checkout, skip those.
                  (invoke "ctest" "-LE" "git_required"
                          "-j" (if parallel-tests?
                                   (number->string (parallel-job-count))
                                   "1"))
                  (format #t "test suite not run~%")))))))
    (native-inputs
     (list amalgamate
           (let ((version "3.1.0"))
             (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/nlohmann/json_test_data")
                     (commit (string-append "v" version))))
               (file-name (git-file-name "json_test_data" version))
               (sha256
                (base32
                 "0nbirc428qx0lpi940p7y24fzdjbwl6xig3h5rdbihyymmdzhvbc"))))))
    (inputs
     (list doctest fifo-map))
    (synopsis "JSON parser and printer library for C++")
    (description "@code{nlohmann::json} is a C++ JSON library that provides
intuitive syntax and trivial integration.")
    (license license:expat)))

(define-public json-modern-cxx
  (deprecated-package "json-modern-cxx" nlohmann-json))

(define-public tomlplusplus
  (package
   (name "tomlplusplus")
   (version "3.4.0")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/marzer/tomlplusplus")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "1hvbifzcc97r9jwjzpnq31ynqnj5y93cjz4frmgddnkg8hxmp6w7"))))
   (build-system meson-build-system)
   (arguments
    (list #:configure-flags
          #~(list "-Dbuild_tests=true")
          #:phases
          #~(modify-phases %standard-phases
              (add-after 'unpack 'set-test-locales
                (lambda _
                  (substitute* "tests/meson.build"
                    (("foreach locale : test_locales" all)
                     (format #f "test_locales = ['C', ~{'~a.utf8', ~}]~%~a"
                             ;; %default-utf8-locales in (gnu packages base).
                             '("de_DE" "el_GR" "en_US" "fr_FR" "tr_TR")
                             all))))))))
   (native-inputs (list cmake-minimal))
   (home-page "https://marzer.github.io/tomlplusplus/")
   (synopsis "Header-only TOML config file parser and serializer for C++17")
   (description
    "This package provides header-only TOML config file parser and serializer
for C++17.")
   (license license:expat)))

(define-public xtl
  (package
    (name "xtl")
    (version "0.7.5")
    (source (origin
              (method git-fetch)
              (uri
               (git-reference
                (url "https://github.com/QuantStack/xtl")
                (commit version)))
              (sha256
               (base32
                "1llfy6pkzqx2va74h9xafjylyvw6839a843mqc05n6x6wll5bkam"))
              (file-name (git-file-name name version))))
    (native-inputs
     (list doctest googletest nlohmann-json))
    (arguments
     (list
      #:configure-flags
      #~(list "-DBUILD_TESTS=ON")
      #:phases
      #~(modify-phases %standard-phases
          (replace 'check
            (lambda _
              (with-directory-excursion "test"
                (invoke "./test_xtl")))))))
    (home-page "https://github.com/QuantStack/xtl")
    (build-system cmake-build-system)
    (synopsis "C++ template library providing some basic tools")
    (description "xtl is a C++ header-only template library providing basic
tools (containers, algorithms) used by other QuantStack packages.")
    (license license:bsd-3)))

(define-public ccls
  (package
    (name "ccls")
    (version "0.20220729")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/MaskRay/ccls")
             (commit version)))
       (sha256
        (base32 "0cp534n7afl0rrr778cc0bnd8w091qmyqdpp5k1jh4wxla9s09br"))
       (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     '(#:tests? #f))                    ; no check target
    (inputs
     (list rapidjson))
    (native-inputs
     (list clang llvm))
    (home-page "https://github.com/MaskRay/ccls")
    (synopsis "C/C++/Objective-C language server")
    (description
     "@code{ccls} is a server implementing the Language Server Protocol (LSP)
for C, C++ and Objective-C languages.  It uses @code{clang} to perform static
code analysis and supports cross references, hierarchies, completion and
syntax highlighting.  @code{ccls} is derived from @code{cquery} which is not
maintained anymore.")
    (license license:asl2.0)))

(define-public concurrentqueue
  (package
    (name "concurrentqueue")
    (version "1.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cameron314/concurrentqueue/")
             (commit "3747268264d0fa113e981658a99ceeae4dad05b7")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1n5v7n27llzg7khg1jvi35jrcf9v6adw8gaic9ndxn65dp723ssy"))))
    (build-system cmake-build-system)
    (arguments '(#:tests? #false)) ;no check target
    (home-page "https://github.com/cameron314/concurrentqueue/")
    (synopsis "Multi-producer, multi-consumer lock-free concurrent queue for C++11")
    (description
     "This package provides a fast multi-producer, multi-consumer lock-free
concurrent queue for C++11.")
    (license license:bsd-2)))

(define-public spscqueue
  (package
    (name "spscqueue")
    (version "1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rigtorp/SPSCQueue/")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1428cj9x318afvnvnkhg0711iy4czqn86fi7ysgfhw91asa316rc"))))
    (build-system cmake-build-system)
    (home-page "https://github.com/rigtorp/SPSCQueue/")
    (synopsis "Single producer single consumer queue written in C++11")
    (description
     "This package provides a single producer single consumer wait-free and
lock-free fixed size queue written in C++11.")
    (license license:expat)))

(define-public syscmdline
  (package
    (name "syscmdline")
    (version "0.0.1.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/SineStriker/syscmdline")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "00n9vkyymp1dzixxl93f6pkpd3ndsk1vib7shhlxv4zvy5hjqhqw"))))
    (build-system cmake-build-system)
    (arguments
     (list #:configure-flags
           #~(list "-DSYSCMDLINE_BUILD_STATIC=OFF" ;build a shared library
                   "-DSYSCMDLINE_BUILD_TESTS=ON")
           #:phases #~(modify-phases %standard-phases
                        (replace 'check
                          ;; There isn't currently any exposed test target.
                          (lambda* (#:key tests? #:allow-other-keys)
                            (when tests?
                              (invoke "bin/tst_basic")))))))
    (home-page "https://github.com/SineStriker/syscmdline")
    (synopsis "C++ advanced command line parser")
    (description "SysCmdLine is a C++ command line parser that is inspired by
@code{QCommandLineParser} from Qt and @code{System.CommandLine} from C#.  It
has features such as:
@itemize
@item Support sub-commands
@item Support case-insensitive parsing
@item Support global options
@item Support mutually exclusive options
@item Support short options and group flags
@item Support help text customization
@item Support localization
@item Simple tips for typo correction
@item Highly configurable
@item Friendly interface
@end itemize")
    (license license:expat)))

(define-public gperftools
  (package
    (name "gperftools")
    (version "2.11")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gperftools/gperftools")
             (commit (string-append "gperftools-" version))))
       (sha256
        (base32 "1mwsa4y696m8zjya0k7xzr9vsgb24dq4aq13m21hb5ygy7nh47id"))
       (file-name (git-file-name name version))))
    (build-system gnu-build-system)
    (arguments
     ;; The tests are flaky when run in parallel. For more info:
     ;; https://bugs.gnu.org/46562
     `(#:parallel-tests? #f
       ,@(if (target-riscv64?)
             `(#:make-flags (list "LDFLAGS=-latomic"))
             '())))
    (native-inputs
     (list autoconf automake libtool
           ;; For tests.
           perl))
    (home-page "https://github.com/gperftools/gperftools")
    (synopsis "Multi-threaded malloc() and performance analysis tools for C++")
    (description
     "@code{gperftools} is a collection of a high-performance multi-threaded
malloc() implementation plus some thread-friendly performance analysis
tools:

@itemize
@item tcmalloc,
@item heap profiler,
@item heap checker,
@item CPU checker.
@end itemize\n")
    (license license:bsd-3)))

(define-public cpp-httplib
  ;; this package is not graftable, as everything is implemented in a single
  ;; header
  (package
    (name "cpp-httplib")
    (version "0.12.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/yhirose/cpp-httplib")
             (commit (string-append "v" version))))
       (sha256
        (base32 "1m1p6h1dsxg4kg5zziffb6xl8zgjbkw7gmgmmlnrhpl3bswam87n"))
       (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       '("-DBUILD_SHARED_LIBS=ON"
         "-DHTTPLIB_TEST=ON"
         "-DHTTPLIB_COMPILE=ON"
         "-DHTTPLIB_REQUIRE_BROTLI=ON"
         "-DHTTPLIB_REQUIRE_OPENSSL=ON"
         "-DHTTPLIB_REQUIRE_ZLIB=ON")
       #:make-flags
       '(,(string-append "CXX=" (cxx-for-target)))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-network-tests
           (lambda _
             (for-each
              (lambda (test)
                (substitute* "test/test.cc"
                  (((string-append "\\(" test))
                   (string-append "(DISABLED_" test))))
              ;; There are tests requiring network access, disable them
              '("AbsoluteRedirectTest" "BaseAuthTest" "CancelTest"
                "ConnectionErrorTest"
                "ChunkedEncodingTest" "ChunkedEncodingTest"
                "ClientDefaultHeadersTest"
                "DecodeWithChunkedEncoding" "DefaultHeadersTest"
                "DigestAuthTest" "HttpsToHttpRedirectTest"
                "HostnameToIPConversionTest"
                "RangeTest" "RedirectTest" "RelativeRedirectTest"
                "SSLClientTest" "SendAPI"
                "SpecifyServerIPAddressTest"
                "TooManyRedirectTest" "UrlWithSpace"
                "YahooRedirectTest" "YahooRedirectTest")))))))
    (native-inputs
     (list googletest python))
    (inputs
     (list brotli openssl zlib))
    (home-page "https://github.com/yhirose/cpp-httplib")
    (synopsis "C++ HTTP/HTTPS server and client library")
    (description "cpp-httplib is a C++11 single-file cross platform blocking
HTTP/HTTPS library, easy to setup.  It can also be used as a single-header
library.")
    (license license:expat)))

(define-public cpplint
  (package
    (name "cpplint")
    (version "1.5.5")
    (source
     (origin
       (method git-fetch)
       ;; Fetch from github instead of pypi, since the test cases are not in
       ;; the pypi archive.
       (uri (git-reference
             (url "https://github.com/cpplint/cpplint")
             (commit version)))
       (sha256
        (base32 "13l86aq0h1jga949k79k9x3hw2xqchjc162sclg2f99vz98zcz15"))
       (file-name (git-file-name name version))))
    (build-system pyproject-build-system)
    (arguments
     (list #:modules `((srfi srfi-1)
                       (srfi srfi-26)
                       ,@%pyproject-build-system-modules)
           #:phases
           #~(modify-phases (@ (guix build pyproject-build-system) %standard-phases)
               (add-before 'wrap 'reduce-GUIX_PYTHONPATH
                 (lambda _
                   ;; Hide the transitive native inputs from GUIX_PYTHONPATH
                   ;; to prevent them from ending up in the run-time closure.
                   ;; See also <https://bugs.gnu.org/25235>.
                   (let ((transitive-native-inputs
                          '#$(match (package-transitive-native-inputs
                                     this-package)
                               (((labels packages) ...) packages))))
                     ;; Save the original PYTHONPATH because we need it for
                     ;; tests later.
                     (setenv "TMP_PYTHONPATH" (getenv "GUIX_PYTHONPATH"))
                     (setenv "GUIX_PYTHONPATH"
                             (string-join
                              (filter (lambda (path)
                                        (not (any (cut string-prefix? <> path)
                                                  transitive-native-inputs)))
                                      (search-path-as-string->list
                                       (getenv "GUIX_PYTHONPATH")))
                              ":")))))
               (add-after 'wrap 'reset-GUIX_PYTHONPATH
                 (lambda _
                   (setenv "GUIX_PYTHONPATH"
                           (getenv "TMP_PYTHONPATH")))))))
    (native-inputs
     (list python-coverage
           python-pytest
           python-pytest-cov
           python-pytest-runner
           python-testfixtures))
    (home-page "https://github.com/cpplint/cpplint")
    (synopsis "Static code checker for C++")
    (description "@code{cpplint} is a command-line tool to check C/C++ files
for style issues following Google’s C++ style guide.  While Google maintains
its own version of the tool, this is a fork that aims to be more responsive
and make @code{cpplint} usable in wider contexts.")
    (license license:bsd-3)))

(define-public reproc
  (package
    (name "reproc")
    (version "14.2.4")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/DaanDeMeyer/reproc")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "09xnf8hmld1fk8j33zwlz1qcxnjdx1ncbg62csic9va4m1wc2v1d"))))
   (build-system cmake-build-system)
   (arguments
    (list #:tests? #f     ; No tests.
          #:configure-flags #~(list "-DBUILD_SHARED_LIBS=ON"
                                    "-DREPROC++=ON")))
   (native-inputs
    (list pkg-config))
   (synopsis "Process IO library")
   (description "reproc (Redirected Process) is a C/C++ library that
simplifies starting, stopping and communicating with external programs.  The
main use case is executing command line applications directly from C or C++
code and retrieving their output.")
   (home-page "https://github.com/DaanDeMeyer/reproc")
   (license license:expat)))

(define-public sobjectizer
  (package
    (name "sobjectizer")
    (version "5.8.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Stiffstream/sobjectizer")
             (commit (string-append "v." version))))
       (sha256
        (base32 "0ya5xlgm3arvzvcnsajw03kc3cibbdbap9p7kgpxn00byqbxixr7"))
       (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'change-directory
           (lambda _
             (chdir "dev"))))))
    (home-page "https://stiffstream.com/en/products/sobjectizer.html")
    (synopsis "Cross-platform actor framework for C++")
    (description
     "SObjectizer is a cross-platform \"actor frameworks\" for C++.
SObjectizer supports not only the Actor Model but also the Publish-Subscribe
Model and CSP-like channels.  The goal of SObjectizer is to simplify
development of concurrent and multithreaded applications in C++.")
    (license license:bsd-3)))

(define-public taskflow
  (package
    (name "taskflow")
    (version "3.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/taskflow/taskflow")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1cv74l181137lchc1rxygcg401cnq216ymq5qz2njsw99j342br3"))))
    (build-system cmake-build-system)
    (home-page "https://taskflow.github.io/")
    (synopsis
     "General-purpose parallel and heterogeneous task programming system")
    (description
     "Taskflow is a C++ library for writing parallel and heterogeneous task
programs.")
    (license license:expat)))

(define-public kokkos
  (package
    (name "kokkos")
    (version "4.3.01")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kokkos/kokkos")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "069j9wijw8vwp2844sdrp0wpq59wihykbhbacwadac01l467m3y7"))
       (modules '((guix build utils)))
       (snippet
        ;; Remove bundled googletest.
        #~(delete-file-recursively "tpls/gtest"))))
    (build-system cmake-build-system)
    (arguments
     (list #:configure-flags
           ;; deal.II uses only the serial backend, so do not enable the
           ;; others yet.
           #~(list "-DBUILD_SHARED_LIBS=ON"
                   "-DKokkos_ENABLE_SERIAL=ON"
                   "-DKokkos_ENABLE_TESTS=ON"
                   "-DKokkos_ENABLE_EXAMPLES=ON"
                   "-DKokkos_ENABLE_HWLOC=ON"
                   "-DKokkos_ENABLE_MEMKIND=ON")
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'install-license-files 'remove-cruft
                 (lambda _
                   (delete-file
                    (string-append #$output "/share/doc/"
                                   #$name "-" #$version
                                   "/LICENSE_FILE_HEADER")))))))
    (native-inputs
     (list googletest python))
    (inputs
     (list `(,hwloc "lib") memkind))
    (home-page "https://github.com/kokkos/kokkos")
    (synopsis "C++ abstractions for parallel execution and data management")
    (description
     "Kokkos Core implements a programming model in C++ for writing performance
portable applications targeting all major HPC platforms.  For that purpose it
provides abstractions for both parallel execution of code and data management.
Kokkos is designed to target complex node architectures with N-level memory
hierarchies and multiple types of execution resources.")

    ;; Code exhibits integer size mismatches when compiled on 32-bit systems.
    (supported-systems %64bit-supported-systems)

    (license license:asl2.0))) ; With LLVM exception

(define-public tweeny
  (package
    (name "tweeny")
    (version "3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mobius3/tweeny")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1adm4c17pi7xf3kf6sjyxibz5rdg1ka236p72xsm6js4j9gzlbp4"))))
    (arguments
     '(#:tests? #f))                    ;no check target
    (build-system cmake-build-system)
    (home-page "https://mobius3.github.io/tweeny/")
    (synopsis "Modern C++ tweening library")
    (description "@code{Tweeny} is an inbetweening library designed for the
creation of complex animations for games and other beautiful interactive
software.  It leverages features of modern @code{C++} to empower developers with
an intuitive API for declaring tweenings of any type of value, as long as they
support arithmetic operations.  The goal of @code{Tweeny} is to provide means to
create fluid interpolations when animating position, scale, rotation, frames or
other values of screen objects, by setting their values as the tween starting
point and then, after each tween step, plugging back the result.")
    (license license:expat)))

;;; This older LTS release is kept for tensorflow.
(define-public abseil-cpp-20200923.3
  (package
    (name "abseil-cpp")
    (version "20200923.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/abseil/abseil-cpp")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1p4djhm1f011ficbjjxx3n8428p8481p20j4glpaawnpsi362hkl"))
              (patches
               (search-patches "abseil-cpp-fix-strerror_test.patch"
                               "abseil-cpp-20200923.3-adjust-sysinfo.patch"
                               "abseil-cpp-20200923.3-duration-test.patch"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags (list "-DBUILD_SHARED_LIBS=ON"
                               "-DABSL_RUN_TESTS=ON"
                               "-DABSL_USE_EXTERNAL_GOOGLETEST=ON"
                               ;; Needed, else we get errors like:
                               ;;
                               ;; ld: CMakeFiles/absl_periodic_sampler_test.dir/internal/periodic_sampler_test.cc.o:
                               ;;   undefined reference to symbol '_ZN7testing4Mock16UnregisterLockedEPNS_8internal25UntypedFunctionMockerBaseE'
                               ;; ld: /gnu/store/...-googletest-1.10.0/lib/libgmock.so:
                               ;;   error adding symbols: DSO missing from command line
                               ;; collect2: error: ld returned 1 exit status
                               "-DCMAKE_EXE_LINKER_FLAGS=-lgtest -lpthread -lgmock")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-max
           (lambda _
             (substitute* "absl/debugging/failure_signal_handler.cc"
               (("std::max\\(SIGSTKSZ, 65536\\)")
                "std::max<size_t>(SIGSTKSZ, 65536)"))))
         (add-before 'configure 'remove-gtest-check
           ;; The CMakeLists fails to find our googletest for some reason, but
           ;; it works nonetheless.
           (lambda _
             (substitute* "CMakeLists.txt"
               (("check_target\\(gtest\\)") "")
               (("check_target\\(gtest_main\\)") "")
               (("check_target\\(gmock\\)") "")))))))
    (native-inputs
     (list googletest))
    (home-page "https://abseil.io")
    (synopsis "Augmented C++ standard library")
    (description "Abseil is a collection of C++ library code designed to
augment the C++ standard library.  The Abseil library code is collected from
Google's C++ code base.")
    (license license:asl2.0)))

;; This is for grpc-for-python-grpcio; keep this in sync with its actual
;; requirements.
(define-public abseil-cpp-20211102.0
  (let ((base abseil-cpp-20200923.3))
    (package
      (inherit base)
      (name "abseil-cpp")
      (version "20211102.0")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/abseil/abseil-cpp")
                      (commit "215105818dfde3174fe799600bb0f3cae233d0bf")))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "028vlxpmh65kb7s0cpba38qcwk1abyn5br0ffhvvjjh97vld69di"))))
      (arguments
       (substitute-keyword-arguments (package-arguments base)
         ((#:tests? _ #false) #false)
         ((#:configure-flags flags)
          #~(cons* "-DCMAKE_CXX_STANDARD=11" #$flags)))))))

(define-public abseil-cpp-20220623.1
  (let ((base abseil-cpp-20200923.3))
    (package
      (inherit base)
      (name "abseil-cpp")
      (version "20220623.1")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/abseil/abseil-cpp")
                      (commit version)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0vxh2a74g4s45yr8kdjqnzl64k10qdlc0hbnn987a4cnwdj4bp9r"))
                (patches
                 (search-patches "abseil-cpp-20220623.1-no-kepsilon-i686.patch"))))
      (arguments
       (substitute-keyword-arguments (package-arguments base)
         ((#:configure-flags flags)
          `(cons* "-DABSL_BUILD_TESTING=ON"
                  (delete "-DABSL_RUN_TESTS=ON" ,flags))))))))

(define-public abseil-cpp
  (let ((base abseil-cpp-20220623.1))
    (package
      (inherit base)
      (name "abseil-cpp")
      (version "20230802.1")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/abseil/abseil-cpp")
                      (commit version)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1ydkkbanrpkp5i814arzsk973kyzhhjhagnp392rq6rrv16apldq"))
                (patches
                 (search-patches "abseil-cpp-20220623.1-no-kepsilon-i686.patch"))))
      (arguments
       (substitute-keyword-arguments (package-arguments base)
         ((#:configure-flags flags #~'())
          (if (target-riscv64?)
              #~(cons* "-DCMAKE_SHARED_LINKER_FLAGS=-latomic"
                       #$flags)
              flags))
         ((#:phases phases)
          #~(modify-phases #$phases
              (add-before 'check 'set-env-vars
                (lambda* (#:key inputs #:allow-other-keys)
                 ;; absl_time_test requires this environment variable.
                 (setenv "TZDIR" (string-append #$(package-source base)
                                                "/absl/time/internal/cctz/testdata/zoneinfo")))))))))))

(define (abseil-cpp-for-c++-standard base version)
  (hidden-package
   (package/inherit base
     (arguments
      (substitute-keyword-arguments (package-arguments base)
        ((#:configure-flags flags)
         #~(cons* #$(string-append "-DCMAKE_CXX_STANDARD="
                                   (number->string version))
                  #$flags)))))))

(define (make-static-abseil-cpp version)
  (let ((base abseil-cpp))
    (hidden-package
     (package/inherit base
       (arguments
        (substitute-keyword-arguments (package-arguments base)
          ((#:configure-flags flags)
           #~(cons* "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
                    (delete "-DBUILD_SHARED_LIBS=ON" #$flags)))))))))

(define-public abseil-cpp-cxxstd17
  (abseil-cpp-for-c++-standard abseil-cpp 17))  ;XXX: the default with GCC 11?

(define-public abseil-cpp-cxxstd11
  (abseil-cpp-for-c++-standard abseil-cpp-20220623.1 11)) ;last version on C++11

(define-public static-abseil-cpp
  (make-static-abseil-cpp abseil-cpp))

(define-public pegtl
  (package
    (name "pegtl")
    (version "3.2.7")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/taocpp/PEGTL")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "01adjqqdr9yf4h379jl1x0526kvixfpqk4hdk9mna49qc4s5hpi1"))))
    (build-system cmake-build-system)
    (home-page "https://github.com/taocpp/PEGTL")
    (synopsis "Parsing Expression Grammar template library")
    (description "The Parsing Expression Grammar Template Library (PEGTL) is
a zero-dependency C++ header-only parser combinator library for creating
parsers according to a Parsing Expression Grammar (PEG).")
    (license license:expat)))

(define-public psascan
  (package
    (name "psascan")
    (version "0.1.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.cs.helsinki.fi/group"
                                  "/pads/software/pSAscan"
                                  "/pSAscan-" version ".tar.bz2"))
              (sha256
               (base32
                "1cphk4gf202nzkxz6jdjzls4zy27055gwpm0r8cn99gr6c8548cy"))
              (modules '((guix build utils)))
              (snippet '(begin (substitute* '("src/Makefile"
                                              "tools/delete-bytes-255/Makefile")
                                 (("-march=native") ""))))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #false ;there are none
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'chdir (lambda _ (chdir "src")))
          (delete 'configure)
          (replace 'install
            (lambda _
              (install-file "psascan"
                            (string-append #$output "/bin")))))))
    (inputs (list libdivsufsort))
    (properties '((tunable? . #t)))
    (home-page "https://www.cs.helsinki.fi/group/pads/pSAscan.html")
    (synopsis "Parallel external memory suffix array construction")
    (description "This package contains an implementation of the parallel
external-memory suffix array construction algorithm called pSAscan.  The
algorithm is based on the sequential external-memory suffix array construction
algorithm called SAscan.")
    ;; Code exhibits integer size mismatches when compiled on 32-bit systems.
    (supported-systems %64bit-supported-systems)
    (license license:expat)))

(define-public cxxopts
  (package
    (name "cxxopts")
    (version "3.1.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/jarro2783/cxxopts")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0d37qpsaq8ik7pl4vk8346vqcqyfzfbnpq8mhsa2gb2zf1lwr4wl"))))
    (build-system cmake-build-system)
    (synopsis "Lightweight C++ command line option parser")
    (description
     "A lightweight header-only C++ option parser library, supporting the
standard GNU style syntax for options.")
    (home-page "https://github.com/jarro2783/cxxopts/wiki")
    (license license:expat)))

(define-public folly
  (package
    (name "folly")
    (version "2023.11.06.00")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/facebook/folly")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0z0jhkma2qacc2kc27qsiwqwqkv07i9mwpc4vwcbawyzdajq6hd0"))))
    (build-system cmake-build-system)
    (arguments
     '(;; Tests must be explicitly enabled
       ;;#:configure-flags '("-DBUILD_TESTS=ON")))
       ;; Leave tests disabled; see https://github.com/facebook/folly/issues/1456
       #:tests? #f))
    (propagated-inputs
     (list boost gflags glog liburing))
    (inputs
     (list bzip2
           double-conversion
           fmt
           libaio
           libevent
           libiberty
           libsodium
           libunwind
           lz4
           openssl
           snappy
           zlib
           `(,zstd "lib")))
    (native-inputs
     (list googletest))
    (synopsis "Collection of C++ components complementing the standard library")
    (description
     "Folly (acronymed loosely after Facebook Open Source Library) is a library
of C++14 components that complements @code{std} and Boost.")
    (home-page "https://github.com/facebook/folly/wiki")
    ;; 32-bit is not supported: https://github.com/facebook/folly/issues/103
    (supported-systems '("aarch64-linux" "x86_64-linux"))
    (license license:asl2.0)))

(define-public poco
  (package
    (name "poco")
    (version "1.11.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pocoproject/poco")
                    (commit (string-append "poco-" version "-release"))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0qkf8vb4qwds6idk9fkw6wjvcdk5k8h77x3gv47l0i4jfl5hwn8b"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags #~(list "-DENABLE_TESTS=ON")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'disable-problematic-tests
            (lambda _
              (substitute* (list "Foundation/CMakeLists.txt" ; XXX: fails.
                                 ;; Require network access
                                 "Net/CMakeLists.txt"
                                 "MongoDB/CMakeLists.txt"
                                 "Redis/CMakeLists.txt")
                (("ENABLE_TESTS") "FALSE")))))))
    (home-page "https://pocoproject.org/")
    (synopsis "Portable C++ components")
    (description "This package provides a collection of C++ libraries intended
to be useful for building network-based applications.")
    (license license:boost1.0)))

(define-public aws-crt-cpp
  (package
    (name "aws-crt-cpp")
    ;; Update only when updating aws-sdk-cpp, and when updating also update
    ;; versions of library dependencies linked from from
    ;; https://github.com/awslabs/aws-crt-cpp/tree/{aws-crt-cpp commit}/crt
    (version "0.17.27")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/awslabs/aws-crt-cpp")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "14g8pn7yii1klby7phcw08qnld1qv11vwmbdz8cs3mlpqahxrh4i"))))
    (build-system cmake-build-system)
    (arguments
     '(#:configure-flags
       (list "-DBUILD_DEPS=OFF"
             "-DBUILD_SHARED_LIBS=ON"
             (string-append "-DCMAKE_PREFIX_PATH="
                          (assoc-ref %build-inputs "aws-c-common"))
             "-DENABLE_NET_TESTS=OFF")))
    (propagated-inputs
     (list aws-c-auth
           aws-c-cal
           aws-c-event-stream
           aws-c-http
           aws-c-mqtt
           aws-c-s3))
    (synopsis "C++ wrapper for Amazon Web Services C libraries")
    (description "The AWS Common Runtime (CRT) library provides a C++ wrapper
implementation for the following @acronym{AWS,Amazon Web Services} C libraries:
aws-c-auth, aws-c-cal, aws-c-common, aws-c-compression, aws-c-event-stream,
aws-c-http, aws-c-io, aws-c-mqtt, aws-checksums, and s2n.")
    (home-page "https://github.com/awslabs/aws-crt-cpp")
    (license license:asl2.0)))

(define-public aws-sdk-cpp
  (package
    (name "aws-sdk-cpp")
    ; When updating also check for a tagged update to aws-crt-cpp from
    ; https://github.com/aws/aws-sdk-cpp/tree/main/crt
    (version "1.9.306")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/aws/aws-sdk-cpp")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0k3f4xq4vvlwrwgpp0vka4pwzbnkylvrkbbkjksx6wq6g1a2gc2g"))))
    (build-system cmake-build-system)
    (arguments
     '(;; Tests are run during the build phase.
       #:tests? #f
       #:configure-flags
       (list "-DBUILD_DEPS=OFF"
             "-DBUILD_SHARED_LIBS=ON"
             (string-append "-DCMAKE_PREFIX_PATH="
                            (assoc-ref %build-inputs "aws-c-common")))))
    (propagated-inputs
     (list aws-crt-cpp))
    (inputs
     (list curl pulseaudio zlib))
    (synopsis "Amazon Web Services SDK for C++")
    (description
     "The AWS SDK for C++ provides a C++11 interface to the @acronym{AWS,Amazon
Web Services} API.  AWS provides on-demand computing infrastructure and software
services including database, analytic, and machine learning technologies.")
    (home-page "https://github.com/aws/aws-sdk-cpp")
    (license license:asl2.0)))

(define-public libexpected
  (package
    (name "libexpected")
    (version "1.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/TartanLlama/expected")
             (commit (string-append "v" version))
             ;; NOTE: Requires TL_CMAKE from custom
             ;; repository. Should not affect reproducibility.
             (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17akrv80h0n4cfmxwvlvbb8ycqza7y3qqygjyphv95rrabqm9r02"))
       (patches (search-patches "libexpected-use-provided-catch2.patch"))))
    (build-system cmake-build-system)
    (native-inputs
     (list catch2))
    (synopsis "C++11/14/17 std::expected with functional-style extensions")
    (description "@code{std::expected} is proposed as the preferred way to
represent objects which will either have an expected value, or an unexpected
value giving information about why something failed.  Unfortunately, chaining
together many computations which may fail can be verbose, as error-checking
code will be mixed in with the actual programming logic.  This implementation
provides a number of utilities to make coding with expected cleaner.")
    (home-page "https://tl.tartanllama.xyz/")
    (license license:cc0)))

(define-public immer
  (package
   (name "immer")
   (version "0.8.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/arximboldi/immer")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32 "03qkr42h0g6rivj3kq207gzgnv7hq88y69q16l2vg1lbvjcgca2g"))))
   (build-system cmake-build-system)
   (arguments (list #:test-target "check"
                    ;; -Werror appears to report false positives.
                    ;; See <https://github.com/arximboldi/immer/issues/223>.
                    #:configure-flags #~(list "-DDISABLE_WERROR=ON")))
   (inputs (list boost libgc c-rrb))
   (native-inputs (list catch2 doctest fmt pkg-config))
   (home-page "https://sinusoid.es/immer")
   (synopsis "Immutable data structures")
   (description "Immer is a library of persistent and immutable data structures
written in C++.")
   (license license:boost1.0)))

(define-public zug
  (package
   (name "zug")
   (version "0.1.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/arximboldi/zug")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32 "06vsbzx4ripidpb6ia7y1y8pmjk6gxzr93ilby90ahj6p2x08baf"))
            (modules '((guix build utils)))
            (snippet #~(delete-file-recursively "tools"))))
   (build-system cmake-build-system)
   (arguments (list #:test-target "check"))
   (native-inputs (list boost catch2))
   (home-page "https://sinusoid.es/zug")
   (synopsis "Higher-order sequence transformers")
   (description "Zug is a C++ library providing transducers, that is,
composable sequential transformations.")
   (license license:boost1.0)))

(define-public lager
  (package
   (name "lager")
   (version "0.1.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/arximboldi/lager")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32 "1by9d49qnkncifyjcq16zy605d7v4ps6hvc01q5nsp1nbswm94m4"))))
   (build-system cmake-build-system)
   (arguments (list #:test-target "check"
                    #:configure-flags #~(list "-Dlager_BUILD_EXAMPLES=no")
                    #:phases
                    #~(modify-phases %standard-phases
                        (add-after 'unpack 'delete-failing-tests
                          (lambda _
                            (delete-file-recursively "test/event_loop"))))))
   (inputs (list boost immer zug))
   (native-inputs (list catch2 cereal))
   (home-page "https://sinusoid.es/lager")
   (synopsis "Library for value-oriented design")
   (description "Lager is a library for value-oriented design implementing
the unidirectional data-flow architecture.  Apart from a store and various
event loops it also provides lenses and cursors.")
   (license license:expat)))

(define-public atomic-queue
  (package
    (name "atomic-queue")
    (version "1.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/max0x7ba/atomic_queue")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0ssff73wlvrsk2nma99dmvm0ijyzfr54jk37kxgpb694r7ajc90l"))))
    (build-system meson-build-system)
    (arguments
     `(#:configure-flags '("-Dbenchmarks=false")
       #:phases
       (modify-phases %standard-phases
         ,@(if (%current-target-system)
               `(;; boost is a test dependency. We don't run tests when
                 ;; cross-compiling. Disable all targets that depend on it.
                 (add-after 'unpack 'do-not-check-for-boost
                   (lambda _
                     (substitute* "meson.build"
                       (("unit_test_framework = [^\n]*" all)
                        "unit_test_framework = disabler()")))))
               '())
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (invoke "./tests"))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (copy-recursively "../source/include/atomic_queue"
                               (string-append (assoc-ref outputs "out")
                                              "/include/atomic_queue")))))))
     (native-inputs
      (list boost
            pkg-config))
    (home-page "https://github.com/max0x7ba/atomic_queue")
    (synopsis "C++ lockless queue")
    (description
     "This package contains a C++11 multiple-producer-multiple-consumer lockless
queues header library based on circular buffer with @code{std::atomic}.")
    (license license:expat)))

(define-public magic-enum
  (package
    (name "magic-enum")
    (version "0.9.5")
    (home-page "https://github.com/Neargye/magic_enum")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url home-page)
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "14ys5sn2v1mai8bclvi81cp65g6jblqpdsi94639hphca5v8gka3"))))
    (build-system cmake-build-system)
    (synopsis "C++17 header only library for compile time reflection of enums")
    (description "Magic Enum offers static reflection of enums, with
conversions to and from strings, iteration and related functionality.")
    (license license:expat)))

(define-public mcpp
  (package
    (name "mcpp")
    (version "2.7.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/mcpp/mcpp/"
                                  "V." version "/mcpp-" version ".tar.gz"))
              (sha256
               (base32
                "0r48rfghjm90pkdyr4khxg783g9v98rdx2n69xn8f6c5i0hl96rv"))))
    (build-system gnu-build-system)
    (arguments
     (list #:configure-flags #~(list "--enable-mcpplib" "--disable-static")))
    (home-page "https://mcpp.sourceforge.net/")
    (synopsis "C/C++ preprocessor")
    (description
     "@code{mcpp} is Matsui's CPP implementation precisely conformed to
standards.")
    (license license:bsd-2)))

(define-public cli11
  (package
    (name "cli11")
    (version "2.3.2")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/CLIUtils/CLI11")
              (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32 "1iif7kzp3yyjqg4yfar89rqmz44xkbi603gf9kjdqbgraw3f8zy7"))))
    (build-system cmake-build-system)
    (arguments
     (list #:configure-flags
           #~(list "-DCLI11_SINGLE_FILE=OFF"
                   "-DCLI11_BUILD_EXAMPLES=OFF")))
    (native-inputs
     (list catch2 doxygen googletest))
    (synopsis "Command line parser for C++11")
    (description
     "CLI11 is a command line parser for C++11 and beyond that provides a rich
feature set with a simple and intuitive interface.")
    (home-page "https://cliutils.github.io/CLI11/book/")
    (license license:bsd-3)))

(define-public caf
  (package
    (name "caf")
    (version "0.18.6")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/actor-framework/actor-framework")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "055y82044djphpwbazaxsvmb66c2xfdi8vyny8pzdxkdgxfh0vq1"))))
    (build-system cmake-build-system)
    (arguments
     '(#:configure-flags
       '("-DCAF_ENABLE_EXAMPLES=OFF")))
    (inputs
     (list openssl))
    (synopsis "C++ implementation of the actor model")
    (description "The C++ Actor Framework (CAF) offers a high-level C++17
programming environment using the actor model for concurrent, distributed
computation.")
    (home-page "https://www.actor-framework.org/")
    (license license:bsd-3)))

(define-public clipper
  (package
    (name "clipper")
    (version "6.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/polyclipping"
                           "/clipper_ver" version ".zip"))
       (sha256
        (base32 "09q6jc5k7p9y5d75qr2na5d1gm0wly5cjnffh127r04l47c20hx1"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f                      ;no check target
       #:phases (modify-phases %standard-phases
                  (replace 'unpack
                    (lambda* (#:key source #:allow-other-keys)
                      (and (invoke "unzip" source)
                           (chdir "cpp")))))))
    (native-inputs
     `(("unzip" ,unzip)))
    (home-page "https://sourceforge.net/projects/polyclipping")
    (synopsis "Polygon and line clipping and offsetting library")
    (description
     "The Clipper library performs line & polygon clipping - intersection,
union, difference & exclusive-or, and line & polygon offsetting.
The library is based on Vatti's clipping algorithm.")
    (license license:boost1.0)))

(define-public pcg-cpp
  (let ((commit "ffd522e7188bef30a00c74dc7eb9de5faff90092")
        (revision "2"))
    (package
      (name "pcg-cpp")
      (version (git-version "0.98.1" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/imneme/pcg-cpp")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0yxyqaphcc38zilpwpmssrl8ly1v6dimscqk2f4rcv1h22dinnqx"))))
      (build-system gnu-build-system)
      (arguments
       `(#:test-target "test"
         #:phases
          (modify-phases %standard-phases
            (delete 'configure))
         #:make-flags (list (string-append "PREFIX=" (assoc-ref %outputs "out")))))
      (synopsis "C++11 header only library for random number generation")
      (description "The Permuted Congruential Generator (PCG) extends the
Linear Congruential Generator (LCG) with a permutation function to increase
output randomness while retaining speed, simplicity, and conciseness.")
      (home-page "https://www.pcg-random.org")
      (license (list license:expat license:asl2.0))))) ; dual licensed

(define-public libconfini
  (package
    (name "libconfini")
    (version "1.16.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/madmurphy/libconfini")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "002lmf1b2phmc6s348k00yx5shrcc7psn3pgqvraxvr6n8g747jx"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       (list "--disable-static")
       #:phases
       (modify-phases %standard-phases
         (replace 'bootstrap
           (lambda _ (invoke "sh" "bootstrap" "--noconfigure"))))))
    (native-inputs
     (list autoconf automake libtool))
    (home-page "https://madmurphy.github.io/libconfini/html/index.html")
    (synopsis "INI file parser")
    (description "@code{libconfini} is an INI file parser library written in
C.  It focuses on standardization and parsing exactness and is at ease with
almost every type of file containing key/value pairs.")
    (license license:gpl3+)))

(define-public libcppgenerate
  ;; dbus-cxx requires an unreleased fix.
  (let ((commit "930c5503f76c877b72b9ff8546353d6f422bd010")
        (revision "0"))
    (package
      (name "libcppgenerate")
      (version (git-version "0.2" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/rm5248/libcppgenerate")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0csdg9b406i85aqgivjmvqjdnqbyiyjh3s0xsfsxppv7wlh7j85r"))))
      (build-system cmake-build-system)
      (arguments (list #:configure-flags #~'("-DENABLE_TESTS=ON")))
      (home-page "https://github.com/rm5248/libcppgenerate")
      (synopsis "C++ code generator library for C++")
      (description "@code{libcppgenerate} is a library for generating C++ code
from C++.")
      (license license:asl2.0))))

(define-public libcutl
  (package
    (name "libcutl")
    (version "1.10.0")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://www.codesynthesis.com/download/libcutl/"
                    (version-major+minor version)
                    "/libcutl-" version ".tar.bz2"))
              (sha256
               (base32
                "070j2x02m4gm1fn7gnymrkbdxflgzxwl7m96aryv8wp3f3366l8j"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Remove bundled sources.
                  (with-directory-excursion "cutl/details"
                    (for-each delete-file-recursively
                              ;; FIXME: Boost_RegEx isn't being detected.
                              (list
                               ;;"boost"
                               "expat")))))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags (list "--disable-static"
                               ;;"--with-external-boost"
                               "--with-external-expat")))
    (inputs
     (list ;;("boost ,boost)
           expat))
    (native-inputs
     (list gcc-10)) ;does not build with gcc-12
    (home-page "https://www.codesynthesis.com/projects/libcutl/")
    (synopsis "C++ utility library with generic and independent components")
    (description "libcutl is a C++ utility library.  It contains a collection
of generic and independent components such as meta-programming tests, smart
pointers, containers, compiler building blocks, etc.")
    (license (list license:expat        ;everything except...
                   license:boost1.0)))) ;...the files under cutl/details/boost

(define-public libxsd-frontend
  (package
    (name "libxsd-frontend")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.codesynthesis.com/download/"
                           "libxsd-frontend/" (version-major+minor version)
                           "/libxsd-frontend-" version ".tar.bz2"))
       (sha256
        (base32 "1nmzchsvwvn66jpmcx18anzyl1a3l309x1ld4zllrg37ijc31fim"))))
    (build-system gnu-build-system)
    (arguments
     `(#:test-target "test"
       #:imported-modules ((guix build copy-build-system)
                           ,@%default-gnu-imported-modules)
       #:modules (((guix build copy-build-system) #:prefix copy:)
                  (guix build gnu-build-system)
                  (guix build utils))
       #:make-flags (list (string-append "--include-dir="
                                         (assoc-ref %build-inputs "build")
                                         "/include/"))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'install
           (lambda args
             (apply (assoc-ref copy:%standard-phases 'install)
                    #:install-plan
                    '(("xsd-frontend" "include/xsd-frontend"
                       #:include-regexp ("\\.?xx$"))
                      ("xsd-frontend" "lib"
                       #:include-regexp ("\\.so$")))
                    args))))))
    (native-inputs
     (list build gcc-10))
    (inputs
     `(("libcutl" ,libcutl)
       ("libxerces-c" ,xerces-c)))
    (synopsis "XSD Front-end")
    (description "@code{libxsd-frontend} is a compiler frontend for the W3C
XML Schema definition language.  It includes a parser, semantic graph types
and a traversal mechanism.")
    (home-page "https://www.codesynthesis.com/projects/libxsd-frontend/")
    (license license:gpl2+)))

(define-public cli
  (package
    (name "cli")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.codesynthesis.com/download/"
                           "cli/" (version-major+minor version)
                           "/cli-" version ".tar.bz2"))
       (sha256
        (base32 "0bg0nsai2q4h3mldpnj0jz4iy4svs0bcfvmq0v0c9cdyknny606g"))))
    (build-system gnu-build-system)
    (arguments
     `(#:test-target "test"
       #:make-flags (list (string-append "--include-dir="
                                         (assoc-ref %build-inputs "build")
                                         "/include")
                          (string-append "install_prefix="
                                         (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch
           (lambda _
             (substitute* (find-files "." "\\.make$")
               (("build-0\\.3")
                (string-append (assoc-ref %build-inputs "build")
                               "/include/build-0.3")))
             ;; Add the namespace prefix, to avoid errors such as "error:
             ;; ‘iterate_and_dispatch’ was not declared in this scope".
             (substitute* (find-files "." "\\.?xx$")
               (("add \\(typeid \\(type\\), \\*this\\);" all)
                (string-append "traverser_map<B>::" all))
               (("iterate_and_dispatch \\(s\\.names_begin.*;" all)
                (string-append "edge_dispatcher::" all)))))
         (delete 'configure))))
    (native-inputs
     (list build gcc-10))
    (inputs
     (list libcutl))
    (synopsis "C++ Command Line Interface (CLI) definition language")
    (description "@code{cli} is a domain-specific language (DSL) for defining
command line interfaces of C++ programs.  It allows you to describe the
options that your program supports, their types, default values, and
documentation.")
    (home-page "https://codesynthesis.com/projects/cli/")
    (license license:expat)))

(define-public xsd
  (package
    (name "xsd")
    (version "4.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.codesynthesis.com/download/"
                           "xsd/" (version-major+minor version)
                           "/xsd-" version ".tar.bz2"))
       (sha256
        (base32 "1hi9ppxd34np8ydv1h0vgc2qpdmgcd1cdzgk30aidv670xjg91fx"))))
    (build-system gnu-build-system)
    (outputs '("out" "doc"))            ;3.8 MiB of doc and examples
    (arguments
     `(#:test-target "test"
       #:make-flags (list (string-append "--include-dir="
                                         (assoc-ref %build-inputs "build")
                                         "/include/")
                          (string-append "install_prefix="
                                         (assoc-ref %outputs "out")))
       #:phases (modify-phases %standard-phases
                  (add-after 'install 'move-doc
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((out (assoc-ref outputs "out"))
                            (doc (assoc-ref outputs "doc")))
                        (mkdir-p (string-append doc "/share/doc"))
                        (rename-file (string-append out "/share/doc/xsd")
                                     (string-append doc "/share/doc/xsd-"
                                                    ,version)))))
                  (delete 'configure))))
    (native-inputs
     (list build cli gcc-10))
    (inputs
     (list libcutl libnsl libxsd-frontend))
    (propagated-inputs
     ;; The code XSD generates requires the following library at run time;
     ;; propagate it for convenience.
     (list xerces-c))
    (synopsis "XML Data Binding for C++")
    (description "CodeSynthesis XSD (also known as libxsd or xsdcxx) is an XML
Schema to C++ data binding compiler.  Provided with an XML instance
specification (XML Schema), it generates C++ classes that represent the given
vocabulary as well as XML parsing and serialization code.  The data stored in
XML can then be accessed using types and functions that semantically
correspond to an application domain rather than dealing with the intricacies
of reading and writing XML.")
    (home-page "https://codesynthesis.com/projects/xsd/")
    ;; Exceptions are made to allow using the generated source files as well
    ;; as the libxsd library in free software projects whose license is
    ;; incompatible with the GPL v2.  Refer to the file named FLOSSE for the
    ;; details.
    (license license:gpl2+)))

(define-public jsonnet
  (package
    (name "jsonnet")
    (version "0.17.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/jsonnet")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ddz14699v5lqx3dh0mb7hfffr6fk5zhmzn3z8yxkqqvriqnciim"))
       (modules '((guix build utils)))
       (snippet
        #~(begin
            (rename-file "third_party/md5" ".md5")
            (delete-file-recursively "third_party")
            (delete-file-recursively "doc/third_party")
            (substitute* '("core/vm.cpp")
              (("#include \"json.hpp\"") "#include <nlohmann/json.hpp>"))
            (mkdir "third_party")
            (rename-file ".md5" "third_party/md5")))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags '("-DUSE_SYSTEM_GTEST=ON" "-DUSE_SYSTEM_JSON=ON"
                           "-DBUILD_STATIC_LIBS=OFF")))
    (native-inputs
     (list googletest pkg-config))
    (inputs
     (list nlohmann-json))
    (home-page "https://jsonnet.org/")
    (synopsis "Data templating language")
    (description "Jsonnet is a templating language extending JSON
syntax with variables, conditions, functions and more.")
    (license license:asl2.0)))

(define-public python-jsonnet
  (package
    (inherit jsonnet)
    (name "python-jsonnet")
    (build-system python-build-system)
    (arguments '())
    (synopsis "Python bindings for Jsonnet, the data templating language")
    (description "This package provides a Python library named @code{_jsonnet}
which can evaluate Jsonnet files and expressions.")))

(define-public simdjson
  (package
    (name "simdjson")
    (version "3.1.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/simdjson/simdjson")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0q784bm8xbz3p782dw02cdds6m71wk3acy94vva8krc9g88142ws"))))
    (build-system cmake-build-system)
    (arguments
     '(#:tests? #f                      ; tests require downloading dependencies
       #:configure-flags
       '("-DBUILD_SHARED_LIBS=ON")))
    (synopsis "JSON parser for C++ using SIMD instructions")
    (description
     "The simdjson library uses commonly available SIMD instructions and
microparallel algorithms to implement a strict JSON parser with UTF-8
validation.")
    (home-page "https://github.com/simdjson/simdjson")
    (license license:asl2.0)))

(define-public simdjson-0.6
  (package
    (inherit simdjson)
    (version "0.6.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/simdjson/simdjson")
                    (commit (string-append "v" version))))
              (file-name (git-file-name (package-name simdjson) version))
              (sha256
               (base32
                "038i9nmk85vpxvs546w6cyci0ppdrrp5wnlv1kffxw29x71a3g5l"))))))

(define-public bloomberg-bde-tools
  (let ((commit "f63dfe9114cd7df29623bd01f644b9f654253972"))
    (package
      (name "bloomberg-bde-tools")
      ;; Recent releases are not tagged so commit must be used for checkout.
      (version "3.118.0.0")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/bloomberg/bde-tools")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1a5sw4xjwd222na3zkflm2gkmzhnfq17i8qapyaxszpiayf3hw6v"))
                (patches
                 (search-patches
                  "bloomberg-bde-tools-fix-install-path.patch"))))
      (build-system copy-build-system)
      ;; Unable to be an inline dependency of bloomberg-bde due to patch.
      (properties '((hidden? . #t)))
      (synopsis "Tools for developing and building libraries modeled on BDE")
      (description
       "This package provides the cmake imports needed to build bloomberg-bde.")
      (home-page "https://github.com/bloomberg/bde-tools")
      (license license:asl2.0))))

(define-public bloomberg-bde
  (let ((commit "77a0f39d538c20ae28bece9a81cac99a9e1df95d"))
    (package
      (name "bloomberg-bde")
      ;; Recent releases are not tagged so commit must be used for checkout.
      (version "3.118.0.1")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/bloomberg/bde")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0nw5clkc9yipd03kijh4c8lxi9zkxfxcjhszl1xzwvgz8xmpampf"))
                (patches
                 (search-patches
                  "bloomberg-bde-cmake-module-path.patch"))
                ;;(modules '((guix build utils)))
                (snippet
                 `(begin
                    ;; FIXME: Delete bundled software. The third-party packages
                    ;; may be patched or modified from upstream sources.
                    ;;(for-each delete-file-recursively
                    ;; (list "thirdparty"))
                    ;; Delete failing tests.
                    (for-each
                     delete-file
                     (list "groups/bal/ball/ball_asyncfileobserver.t.cpp"
                           "groups/bal/ball/ball_fileobserver2.t.cpp"
                           "groups/bal/ball/ball_recordstringformatter.t.cpp"
                           "groups/bal/balst/balst_stacktraceresolver_filehelper.t.cpp"
                           "groups/bal/balst/balst_stacktraceutil.t.cpp"
                           "groups/bdl/bdlmt/bdlmt_eventscheduler.t.cpp"
                           "groups/bdl/bdlmt/bdlmt_timereventscheduler.t.cpp"
                           "groups/bdl/bdls/bdls_filesystemutil.t.cpp"
                           "groups/bsl/bslh/bslh_hash.t.cpp"
                           "groups/bsl/bslh/bslh_hashpair.t.cpp"
                           "groups/bsl/bsls/bsls_platform.t.cpp"
                           "groups/bsl/bsls/bsls_stackaddressutil.t.cpp"
                           "groups/bsl/bsls/bsls_stopwatch.t.cpp"
                           "groups/bsl/bsls/bsls_timeutil.t.cpp"
                           "groups/bsl/bslstl/bslstl_deque.1.t.cpp"
                           "groups/bsl/bslstl/bslstl_deque.2.t.cpp"
                           "groups/bsl/bslstl/bslstl_deque.3.t.cpp"
                           "groups/bsl/bslstl/bslstl_function_invokerutil.t.cpp"))
                    #t))))
      (build-system cmake-build-system)
      (arguments
       `(#:parallel-tests? #f           ; Test parallelism may fail inconsistently.
         ;; Set UFID to build shared libraries. Flag descriptions can be found at
         ;; https://bloomberg.github.io/bde-tools/bbs/reference/bbs_build_configuration.html#ufid
         #:configure-flags '("-DUFID=opt_dbg_exc_mt_64_shr_cpp20")
         #:phases
         (modify-phases %standard-phases
           ;; Explicitly build tests separate from the main build.
           (add-after 'build 'build-tests
             (lambda* (#:key make-flags #:allow-other-keys)
               (apply invoke "make" "all.t"
                 `(,@(if #:parallel-build?
                         `("-j" ,(number->string (parallel-job-count)))
                         '())
                 ,@make-flags)))))))
      (native-inputs
       (list bloomberg-bde-tools pkg-config python))
      (synopsis "Foundational C++ libraries used at Bloomberg")
      (description
       "The BDE Development Environment libraries provide an enhanced
implementation of STL containers, vocabulary types for representing common
concepts (like dates and times), and building blocks for developing
multi-threaded applications and network applications.")
      (home-page "https://github.com/bloomberg/bde")
      ;; Out-of-memory on i686-linux, compile errors with non-x86.
      (supported-systems '("x86_64-linux"))
      (license license:asl2.0))))

(define-public gulrak-filesystem
  (package
    (name "gulrak-filesystem")
    (version "1.5.12")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/gulrak/filesystem")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1qg10akvhp801xirkj4mqcpvcxj90z81ygpyg752xv110zj4914g"))))
    (build-system cmake-build-system)
    (synopsis "Header only C++ std::filesystem compatible library")
    (description "This package provides a header-only single-file
std::filesystem compatible helper library, based on the C++17 and C++20 specs,
but implemented for C++11, C++14, C++17 or C++20.")
    (home-page "https://github.com/gulrak/filesystem")
    (license license:expat)))

(define-public cpp-mustache
  (package
    (name "cpp-mustache")
    (version "5.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/kainjow/Mustache")
                    (commit "4ed8c0b5a2a43d59394bd6900dc04e738dbf8c02")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0qwrg35gby851viwd6dgrc346712701a0gll8a0m4xs8invxavrh"))))
    (build-system cmake-build-system)
    (arguments
     (list #:configure-flags
           #~(list
              (string-append "-DCMAKE_CXX_FLAGS=-I"
                             #$(this-package-native-input "catch2")
                             "/include/catch2/"))
           #:phases
           #~(modify-phases %standard-phases
               (replace 'check
                 (lambda* (#:key tests? #:allow-other-keys)
                   (when tests?
                     (invoke "./tests/mustache-unit-tests"))))
               (replace 'install
                 (lambda* (#:key outputs #:allow-other-keys)
                   (install-file "../source/mustache.hpp"
                                 (string-append (assoc-ref outputs "out")
                                                "/include")))))))
    (native-inputs (list catch2))
    (home-page "https://github.com/kainjow/Mustache")
    (synopsis "Mustache text templates for modern C++")
    (description "@code{cpp-mustache} is a Mustache implementation for C++ 11
and above.  It is header only and has zero dependencies.  It provides a
templated string type for compatibility with any STL-like string (std::string,
std::wstring, etc).")
    (license license:boost1.0)))

(define-public crc32c
  (package
    (name "crc32c")
    (version "1.1.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/google/crc32c")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0966lyy3w5cnrs0c0fkma4hga51k54hns72l4n76944awqssap7j"))
              (patches (search-patches "crc32c-unbundle-googletest.patch"))))
    (build-system cmake-build-system)
    (arguments
     (list #:configure-flags #~(list "-DBUILD_SHARED_LIBS=ON"
                                     "-DCRC32C_BUILD_BENCHMARKS=OFF"
                                     "-DCRC32C_USE_GLOG=OFF"
                                     (string-append
                                      "-DCRC32C_BUILD_TESTS="
                                      ;; TODO: perhaps infer #:tests?
                                      (if #$(%current-target-system)
                                          "OFF" "ON")))))
    (native-inputs (list googletest))
    (home-page "https://github.com/google/crc32c")
    (synopsis "Cyclic redundancy check")
    (description
     "This package provides architecture-specific implementations of the
CRC32C algorithm, which is specified in RFC 3720, section 12.1.")
    (license license:bsd-3)))

(define fast-float-test-files
  (let ((commit "97a0b2e638feb479387554cf253e346500541e7e"))
   (origin
    (method git-fetch)
    (uri (git-reference
          (url (string-append "https://github.com/fastfloat"
                              "/supplemental_test_files.git"))
          (commit "97a0b2e638feb479387554cf253e346500541e7e")))
    (file-name (string-append "fast-float-test-files-"
                              (string-take commit 8)))
    (sha256
     (base32
      "0dxbiyzyh7i847i89ablfzypfc3ckhm7f74w98jsh73v1mppmxlf")))))

(define-public fast-float
  (package
    (name "fast-float")
    (version "6.0.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/fastfloat/fast_float")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1xf4gbllha760cr0ri53zsja46dypj45lj070ijb5f78xavfd8f8"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags #~(list "-DFASTFLOAT_TEST=ON"
                                "-DSYSTEM_DOCTEST=ON")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-cmake-tests
            (lambda* (#:key inputs native-inputs #:allow-other-keys)
              (substitute* "tests/CMakeLists.txt"
                (("FetchContent_GetProperties\\(supplemental_test_files.*")
                 "")
                (("if\\(NOT supplemental_test_files_POPULATED.*")
                 (string-append
                  "set(supplemental_test_files_BINARY_DIR "
                  #$fast-float-test-files ")\nif(0)\n"))))))))
    (native-inputs (list doctest fast-float-test-files))
    (home-page "https://github.com/fastfloat/fast_float")
    (synopsis "Floating point number parser for C++")
    (description "@code{fast_float} is a header-only C++ library for parsing
floating point numbers from strings.  It implements the C++ from_chars
functions for the float and double types.")
    (license (list license:asl2.0 license:expat)))) ; dual licensed

(define-public pocketfft-cpp
  (let ((commit "daa8bb18327bc5c7d22c69428c25cf5dc64167d3")
        (revision "0"))
    (package
      (name "pocketfft-cpp")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/mreineck/pocketfft")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1dbkkqkmkxgmz1qjpsqzic5ig3qw1pqndbb3dvjc7xq5f2rdzyq1"))
                (patches (search-patches
                          "pocketfft-cpp-prefer-preprocessor-if.patch"))))
      (build-system copy-build-system)
      (arguments
       (list
        #:install-plan #~'(("pocketfft_hdronly.h" "include/"))))
      (home-page "https://github.com/mreineck/pocketfft")
      (synopsis "C++11 header-only Fast Fourier Transform library")
      (description "This package provides a single-header C++11 library for
computing Fast Fourier transformations.  It supports multidimensional arrays,
different floating point sizes and complex transformations.")
      (license license:bsd-3))))

(define-public sajson
  (let ((commit "ec644013e34f9984a3cc9ba568cab97a391db9cd")
        (revision "0"))
    (package
      (name "sajson")
      (version (git-version "1.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/chadaustin/sajson")
                      (commit commit)))
                (file-name (git-file-name name version))
                (patches
                 (search-patches "sajson-build-with-gcc10.patch"))
                (sha256
                 (base32
                  "0fjag27w7gvkc5pdhq3ad7yc09rabpzahndw1sgsg04ipznidmmq"))
                (modules '((guix build utils)))
                (snippet '(delete-file-recursively "third-party"))))
      (build-system scons-build-system)
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'disable-other-builds
              (lambda _
                (substitute* "SConstruct"
                  (("for name, tools in builds:")
                   "for name, tools in [('opt', [gcc, opt])]:"))))
            (add-after 'unpack 'use-external-unittest-cpp
              (lambda _
                (substitute* "SConscript"
                  (("unittestpp_env\\.Library") "_dummy = ")
                  (("test_env = env.Clone\\(tools=\\[unittestpp, sajson\\]\\)")
                   (string-append
                    "test_env = env.Clone(tools=[sajson])\n"
                    "test_env.Append(CPPPATH='"
                    (search-input-directory %build-inputs "/include/UnitTest++")
                    "', LIBPATH='"
                    (string-append #$(this-package-native-input "unittest-cpp")
                                   "/lib")
                    "', LIBS=['UnitTest++'])")))))
            (replace 'build
              (lambda* (#:key tests? #:allow-other-keys #:rest args)
                (when tests?
                  (apply (assoc-ref %standard-phases 'build)
                         args))))
            (replace 'check
              (lambda* (#:key tests? #:allow-other-keys)
                (when tests?
                  (invoke "build/opt/test")
                  (invoke "build/opt/test_unsorted"))))
            (replace 'install
              (lambda _
                (let ((out (string-append #$output "/include")))
                  (install-file "include/sajson.h" out)
                  (install-file "include/sajson_ostream.h" out)))))))
      (native-inputs (list unittest-cpp))
      (home-page "https://github.com/chadaustin/sajson")
      (synopsis "C++11 header-only, in-place JSON parser")
      (description "@code{sajson} is an in-place JSON parser with support for
parsing with only a single memory allocation.")
      (license license:expat))))

(define-public sajson-for-gemmi
  (package/inherit sajson
    (name "sajson-for-gemmi")
    (source (origin
              (inherit (package-source sajson))
              (patches (cons
                        (search-patch
                         "sajson-for-gemmi-numbers-as-strings.patch")
                        (origin-patches (package-source sajson))))))
    (arguments
     (substitute-keyword-arguments (package-arguments sajson)
       ;; This is a modified version used in gemmi, in which numbers are kept
       ;; as strings. Building the tests fails with the modification.
       ((#:tests? _ #f) #f)))
    (properties '((hidden? . #t)))))

(define-public optional-lite
  (package
    (name "optional-lite")
    (version "3.5.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/martinmoene/optional-lite")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
                (base32
                 "0jpsm94kp1504yk9s2km86zv8xrszz30qanmhz2ljmvsdblz2l47"))))
    (build-system cmake-build-system)
    (home-page "https://github.com/martinmoene/optional-lite")
    (synopsis "Nullable object for C++98, C++11 and later")
    (description
     "Optional lite is a single-file header-only library to represent optional
(nullable) objects and pass them by value.  The library aims to provide a
C++17-like optional for use with C++98 and later.  If available,
@code{std::optional} is used.")
    (license license:boost1.0)))

(define-public optionparser
  (package
    (name "optionparser")
    (version "1.7")
    (source (origin
              (method url-fetch)
              (uri
               (string-append "mirror://sourceforge/optionparser/"
                              "optionparser-" version ".tar.gz"))
              (sha256
               (base32
                "04gfxrdzwacaynb8scsz6rr7nh64n6yk6w9dh2qdhrxw4caqr0dk"))))
    (outputs '("out" "doc"))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (add-before 'build 'chdir
            (lambda _ (chdir "src")))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (begin
                  (invoke "./example_arg")
                  (invoke "./testparse")
                  (invoke "./testprintusage")
                  (invoke "./testodr")
                  (invoke "./example")))))
          (replace 'install
            (lambda _
              (install-file "optionparser.h"
                            (string-append #$output "/include"))))
          (add-after 'install 'install-doc
            (lambda _
              (copy-recursively
               "../html"
               (string-append #$output:doc "/share/doc/optionparser/html")))))))
    (native-inputs (list doxygen))
    (home-page "https://optionparser.sourceforge.net/")
    (synopsis "Header-only C++ library to parse command line options")
    (description "This package provides a header-only C++ library to parse
command line options.  It supports the short and long option formats of
getopt(), getopt_long() and getopt_long_only().")
    (license license:expat)))

(define-public safeint
  (package
    (name "safeint")
    (version "3.0.27")
    (home-page "https://github.com/dcleblanc/SafeInt")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url home-page)
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "01d2dpdhyw3lghmamknb6g39w2gg0sv53pgxlrs2la8h694z6x7s"))))
    (build-system cmake-build-system)
    (arguments
     (list #:phases #~(modify-phases %standard-phases
                        (replace 'install
                          (lambda _
                            (let ((include-dir (string-append #$output
                                                              "/include")))
                              (with-directory-excursion "../source"
                                (install-file "SafeInt.hpp" include-dir)
                                (install-file "safe_math.h" include-dir)
                                (install-file "safe_math_impl.h" include-dir)))))
                        (add-after 'install 'install-doc
                          (lambda _
                            (let ((doc-dir (string-append #$output
                                                          "/share/doc/safeint")))
                              (with-directory-excursion "../source"
                                (install-file "helpfile.md" doc-dir))))))))
    (synopsis "C and C++ library for managing integer overflows")
    (description
     "SafeInt is a class library for C++ that manages integer overflows.  It
also includes a C library that checks casting, multiplication, division,
addition and subtraction for all combinations of signed and unsigned 32-bit and
64-bit integers.")
    (license license:expat)))

(define-public wide-integer
  (let ((commit "22b8428746248e682d5276f8e8b7fb52af73ea47")
        (revision "1314"))              ; commit count
   (package
    (name "wide-integer")
    (version (git-version "0" revision commit))
    (source (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/ckormanyos/wide-integer")
                   (commit commit)))
             (file-name (git-file-name name version))
             (sha256
              (base32 "0bhjnbdcphv5kddddh8kpwjpjix23m12vmfsz0r6wjc5d27md33z"))
             (modules '((guix build utils)))
             (snippet #~(substitute* "CMakeLists.txt"
                          (("WideIntegerTargets") "wide-integer-targets")
                          (("WideIntegerConfig") "wide-integer-config")
                          (("WideInteger") "wide-integer")))))
    (build-system cmake-build-system)
    (native-inputs (list boost))
    (home-page "https://github.com/ckormanyos/wide-integer")
    (synopsis "C++ template for arbitrary-precision integers")
    (description "This package implements a generic template for extended
width signed and unsigned integral types.  Up to 63 limbs of any built-in
integer type are supported, and can be used to build powers of two like
int128_t, uint256_t, but also somewhat esoteric types such as int24_t,
uint80_t, or uint1536_t.  The provided types can be used in much the same
way as basic integer types.")
    (license license:boost1.0))))

(define-public wdl
  ;; No tag is available.
  (let ((commit "da86a62d11e46e4ecd8b16f9775cb5188340a0e2")
        (revision "0"))
    (package
      (name "wdl")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/justinfrankel/WDL")
                      (commit commit)))
                (file-name (git-file-name name version))
                ;; This patch fixes error of undefined functions, due to not
                ;; linking libraries, and invalid object.
                (patches
                 (search-patches "wdl-link-libs-and-fix-jnetlib.patch"))
                (sha256
                 (base32
                  "0hdb604szkbrlyffiw94rz8wx4nvmk3zdkycfirqgjs7mh0l6vbq"))
                (modules '((guix build utils)))
                ;; Unbundle third party libraries which are not needed.
                (snippet
                 '(with-directory-excursion "WDL"
                    (for-each delete-file-recursively
                              (list "cmath"
                                    "libpng"
                                    "lice/glew"
                                    "giflib"
                                    "jpeglib"
                                    "zlib"))))))
      (build-system gnu-build-system)
      (arguments
       (list
        #:test-target "test"
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'chdir
              (lambda _ (chdir "WDL/swell")))
            (delete 'configure)
            (replace 'build
              (lambda _
                (with-directory-excursion ".."
                  (invoke "make" "-Ceel2")     ;build eel2
                  (invoke "make" "-Cjnetlib")) ;build jnetlib
                (invoke "make" "SWELL_SUPPORT_GTK=true")
                (invoke "make" "libSwell.colortheme")))
            (replace 'install
              (lambda _
                (chdir "..")

                ;; Do not install these directories
                (delete-file-recursively "lice/test")
                (delete-file-recursively "swell/sample_project")

                ;; Install headers.
                (let ((include (string-append #$output "/include/WDL")))
                  (for-each
                   (lambda (file)
                     (install-file file
                                   (string-append include "/"
                                                  (dirname file))))
                   (find-files "." "\\.h$")))
                (install-file "swell/libSwell.so"
                              (string-append #$output "/lib"))
                (install-file "swell/libSwell.colortheme"
                              (string-append #$output "/share/WDL"))
                (install-file "eel2/loose_eel"
                              (string-append #$output "/libexec"))
                (install-file "jnetlib/jnl.a"
                              (string-append #$output "/lib")))))))
      (native-inputs (list pkg-config nasm))
      (inputs
       (list cairo
             fontconfig
             freetype
             gdk-pixbuf
             glib
             gtk+
             libxi
             libx11
             mesa
             zlib))
      (home-page "https://www.cockos.com/wdl/")
      (synopsis "Modestly reusable C++ libraries")
      (description
       "WDL is a modestly reusable C++ library that offers the following:
@itemize
@item Inline classes for cleanly managing memory allocations, lists,
queues, resource pools, strings, etc.
@item File reading/writing wrappers
@item Directory scanning API
@item SHA-1 implementation
@item Mergesort implementation
@item Blowfish implementation
@item Fast FFT implementation (based on DJBFFT)
@item Audio tools
@item LICE - Lightweight Image Compositing Engine
@item WDL Virtual Window system
@item Plush2 - Portable, lightweight software 3d rendering engine
@item SWELL - Simple Windows Emulation Layer
@item And more.
@end itemize")
      (license license:zlib))))

(define-public ftxui
  (package
    (name "ftxui")
    (version "5.0.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ArthurSonzogni/FTXUI")
                    (commit (string-append "v" version))))
              (sha256
               (base32
                "1qfk6jwasxhjk410igma7pdv1q664w8cgjf95ciln3hh1kiqcpi0"))
              (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (native-inputs (list googletest benchmark))
    (arguments
     (list #:configure-flags
           #~(list "-DFTXUI_BUILD_TESTS:BOOL=ON"
                   "-DFTXUI_BUILD_TESTS_FUZZER:BOOL=OFF")))
    (home-page "https://github.com/ArthurSonzogni/FTXUI")
    (synopsis "C++ Functional Terminal User Interface")
    (description
     "Functional Terminal (X) User interface (FTXUI) is a simple C++ library for
terminal based user interfaces.

Main features:
@itemize
@item Functional style.
@item Keyboard & mouse navigation.
@item Support for UTF8 and fullwidth chars.
@item Support for animations.
@item Support for drawing.
@item No dependencies.
@end itemize")
    (license license:expat)))

(define-public mapbox-variant
  (package
    (name "mapbox-variant")
    (version "1.2.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mapbox/variant")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32 "03cmxm34ralh8y07bs80gz3v4pql51206dn5h7lcnm7vishkk241"))
              (modules '((guix build utils)))
              (snippet #~(begin
                           (delete-file "test/include/catch.hpp")
                           (substitute* (find-files "test" "\\.[ch]pp")
                             (("\"catch.hpp\"") "<catch/catch.hpp>"))))))
    (build-system gnu-build-system)
    (arguments
     (list #:test-target "test"
           #:phases
           #~(modify-phases %standard-phases
               (delete 'bootstrap)
               (delete 'configure)
               (delete 'build)
               (replace 'install
                 (lambda* (#:key outputs #:allow-other-keys)
                   (copy-recursively "include"
                                     (string-append (assoc-ref outputs "out")
                                                    "/include")))))))
    (native-inputs (list catch2-1))
    (home-page "https://github.com/mapbox/variant")
    (synopsis "Implementation of std::variant for C++11/14")
    (description "This package provides a header-only implementation of
std::variant (formerly boost::variant) for C++11/14.")
    (license license:bsd-3)))

(define-public mpark-variant
  (package
    (name "mpark-variant")
    (version "1.4.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mpark/variant")
                    (commit (string-append "v" version))))
              (sha256
               (base32
                "0gz8d5qprlfqb42cfyyc4nbwhgarhw027a9nr52h3gbdn560j0j4"))
              (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags #~(list "-DMPARK_VARIANT_INCLUDE_TESTS=mpark")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'find-googletest
            (lambda _
              (substitute* "test/CMakeLists.txt"
                (("add_subdirectory.*3rdparty/googletest.*\n")
                 "find_package(GTest REQUIRED)\n")
                ((".*3rdparty/googletest.*\n") "")
                ((".*config_compiler_and_linker.*\n") "")
                (("gtest_main") "gtest gtest_main")))))))
    (native-inputs (list googletest))
    (home-page "https://github.com/mpark/variant")
    (synopsis "Implementation of std::variant for C++11/14/17")
    (description
     "MPark.Variant provides the C++17 std::variant for C++11/14/17.  It is
based on the implementation of std::variant in libc++.")
    (license license:boost1.0)))

(define-public tsl-hopscotch-map
  (package
    (name "tsl-hopscotch-map")
    (version "2.3.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Tessil/hopscotch-map")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "012pw37w000pdxdvps0wsqrw6597cm6i6kr5rpl303qmiwqicb2p"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-cmake-test
            (lambda _
              (let ((file (open-file "CMakeLists.txt" "a")))
                (display "\nenable_testing()\nadd_subdirectory(tests)" file)
                (close-port file))
              (substitute* "tests/CMakeLists.txt"
                (("set\\(Boost_USE_STATIC_LIBS.*") "")
                (("add_subdirectory\\(\\.\\..*")
                 "add_test(tsl_hopscotch_map_tests tsl_hopscotch_map_tests)\n")))))))
    (native-inputs (list boost))
    (home-page "https://github.com/Tessil/hopscotch-map")
    (synopsis "Hash maps and hash sets using hopscotch hashing")
    (description "This package provides a C++ implementation of several hash
map and a hash set variants using open addressing and hopscotch hashing to
resolve collisions.  It is intended to be fast and provides additional
features, such as heterogeneous lookups and different growth policies.")
    (license license:expat)))

(define-public tsl-sparse-map
  (package
    (name "tsl-sparse-map")
    (version "0.6.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Tessil/sparse-map")
                    (commit (string-append "v" version))))
              (sha256
               (base32
                "0rb7w0hzsj4qbm0dff1niaf75aag9lj0xqhgb3vg5h9hfic62ic2"))
              (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-cmake-test
            (lambda _
              (let ((file (open-file "CMakeLists.txt" "a")))
                (display "\nenable_testing()\nadd_subdirectory(tests)" file)
                (close-port file))
              (substitute* "tests/CMakeLists.txt"
                (("set\\(Boost_USE_STATIC_LIBS.*") "")
                (("add_subdirectory\\(\\.\\..*")
                 "add_test(tsl_sparse_map_tests tsl_sparse_map_tests)\n")))))))
    (native-inputs (list boost))
    (home-page "https://github.com/Tessil/sparse-map")
    (synopsis "Sparse hash map")
    (description "This package provides a C++ implementation of a hash map and
a hash set with open addressing and sparse quadratic probing.  It is intended
to be memory efficient and provides additional features, such as heterogeneous
lookups and different growth policies.")
    (license license:expat)))

(define-public tsl-ordered-map
  (package
    (name "tsl-ordered-map")
    (version "1.1.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Tessil/ordered-map")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0bz5zgabalb7z0j9scng4zmi95hy7iasry5gz15x6y6dsdz0qf3j"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-cmake-test
            (lambda _
              (let ((file (open-file "CMakeLists.txt" "a")))
                (display "\nenable_testing()\nadd_subdirectory(tests)" file)
                (close-port file))
              (substitute* "tests/CMakeLists.txt"
                (("set\\(Boost_USE_STATIC_LIBS.*") "")
                (("add_subdirectory\\(\\.\\..*")
                 "add_test(tsl_ordered_map_tests tsl_ordered_map_tests)\n")))))))
    (native-inputs (list boost))
    (home-page "https://github.com/Tessil/ordered-map")
    (synopsis "Order-preserving hash map and hash set")
    (description "This package provides a C++ implementation of a hash map and
a hash set which preserve the order of insertion.  It is intended for
efficient ordered insertions and lookup, while sacrifing performance for
ordered erase operations.")
    (license license:expat)))

(define-public tl-optional
  (package
    (name "tl-optional")
    (version "1.1.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/TartanLlama/optional")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0qkjplmhilbi1iqxx3pz0grcx5355ymk6wwd4h4309mk156xgx2q"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-cmake-test
            (lambda _
              (substitute* "CMakeLists.txt"
                (("FetchContent_Declare.*") "")
                ((".*http.*catchorg/Catch2.*") "")
                (("FetchContent_MakeAvailable\\(Catch2\\)")
                 "find_package(Catch2 REQUIRED)")))))))
    (native-inputs (list catch2))
    (home-page "https://github.com/TartanLlama/optional")
    (synopsis "Implementation of std::optional with extensions for C++11/14/17")
    (description "@code{tl::optional} provides a single-header implementation of
the std::optional for C++11/14/17, with support for monadic operations added in
C++23.")
    (license license:cc0)))
