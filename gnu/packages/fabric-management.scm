;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017 Dave Love <fx@gnu.org>
;;; Copyright © 2018, 2019 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2019 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2019, 2023 Ludovic Courtès <ludo@gnu.org>
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

(define-module (gnu packages fabric-management)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages tcl))

;; Fixme: Done for the library, but needs support for running the daemon
;;        (shepherd definition).
;;        We should probably have a lib output, but that currently generates
;;        a cycle.
(define-public opensm
  (package
    (name "opensm")
    (version "3.3.24")
    (source
     (origin
       (method url-fetch)
       (uri
        (string-append "https://github.com/linux-rdma/opensm/releases/download/"
                       version "/opensm-" version ".tar.gz"))
       (sha256
        (base32 "0q74sx8y23h7picdzb4g5r84wcvc9hr9vzsdawkl812b38vmwcx3"))))
    (build-system gnu-build-system)
    (native-inputs
     (list bison
           flex
           ;; The 3.3.21 'release' tarball isn't properly bootstrapped.
           autoconf
           automake
           libtool))
    (inputs
     (list rdma-core))
    (arguments
     (list
      #:configure-flags #~'("--disable-static")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'install-doc
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((base (assoc-ref outputs "out"))
                     (doc (string-append base "/share/doc/"
                                         #$(package-name this-package)
                                         "-"
                                         #$(package-version this-package))))
                (for-each (lambda (file)
                            (install-file file doc))
                          (find-files "doc"))))))))
    (home-page "https://www.openfabrics.org/")
    (synopsis "OpenIB InfiniBand Subnet Manager and management utilities")
    (description "\
OpenSM is the OpenIB project's Subnet Manager for Infiniband networks.
The subnet manager is run as a system daemon on one of the machines in
the infiniband fabric to manage the fabric's routing state.  This package
also contains various tools for diagnosing and testing Infiniband networks
that can be used from any machine and do not need to be run on a machine
running the opensm daemon.")
    (license (list gpl2 bsd-2))))

(define-public infiniband-diags
  (package
    (name "infiniband-diags")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/linux-rdma/infiniband-diags/releases"
                           "/download/" version
                           "/infiniband-diags-" version ".tar.gz"))
       (sha256
        (base32 "11dbdnsx5hcvg6jh4ipm5j9wg420avpxw1jbsaj3zf4kwc5hw9id"))))
    (build-system gnu-build-system)
    (inputs
     (list rdma-core opensm glib))
    (outputs '("out" "lib"))
    (native-inputs
     ;; FIXME: needs rst2man for man pages
     (list perl pkg-config))
    (arguments
     (list #:configure-flags
           #~(list (string-append "CPPFLAGS=-I"
                                  #$(this-package-input "opensm")
                                  "/include/infiniband")
                   (string-append "--with-perl-installdir=" #$output:lib
                                  "/lib/perl5/vendor_perl")
                   "--disable-static")
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'install 'licence
                 (lambda* (#:key outputs #:allow-other-keys)
                   (let ((doc (string-append (assoc-ref outputs "lib")
                                             "/share/doc")))
                     (mkdir-p doc)
                     (install-file "COPYING" doc))))
               (add-after 'install 'move-perl
                 ;; Avoid perl in lib closure
                 (lambda* (#:key outputs #:allow-other-keys)
                   (let ((perlout (string-append (assoc-ref outputs "out")
                                                 "/lib"))
                         (perlin (string-append (assoc-ref outputs "lib")
                                                "/lib/perl5")))
                     (mkdir-p perlout)
                     (rename-file perlin perlout)))))))
    (home-page "https://github.com/linux-rdma/infiniband-diags")
    (synopsis "Infiniband diagnostic tools")
    (description "This is a set of command-line utilities to help configure,
debug, and maintain Infiniband (IB) fabrics.

In addition to the utilities, a sub-library, @file{libibnetdisc}, is provided
to scan an entire IB fabric and return data structures representing it.  The
interface to this library is not guaranteed to be stable.")
    (license (list gpl2 bsd-2)))) ; dual

(define-public ibutils
  (package
    (name "ibutils")
    (version "1.5.7-0.2.gbd7e502")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.openfabrics.org/downloads/ibutils/ibutils-"
                           version ".tar.gz"))
       (sha256
        (base32 "00x7v6cf8l5y6g9xwh1sg738ch42fhv19msx0h0090nhr0bv98v7"))))
    (build-system gnu-build-system)
    (inputs (list graphviz
                  tcl
                  tk
                  infiniband-diags
                  rdma-core
                  opensm
                  perl))
    (native-inputs (list swig))
    (arguments
     (list #:configure-flags
           #~(list (string-append "--with-osm="
                                  #$(this-package-input "opensm"))
                   (string-append "--with-tk-lib="
                                  #$(this-package-input "tk") "/lib")
                   "--disable-static"

                   ;; Address this link error:
                   ;; ld: .libs/ibis.o:/ibis/src/ibis.c:55: multiple definition of `IbisObj'; .libs/ibis_wrap.o:/ibis/src/ibis_wrap.c:3007: first defined here
                   "CFLAGS=-O2 -g -fcommon")))
    (synopsis "InfiniBand network utilities")
    (description "These command-line utilities allow for diagnosing and
testing InfiniBand networks.")
    (home-page "https://www.openfabrics.org/downloads/ibutils/")
    (license bsd-2)))

(define-public ucx
  (package
    (name "ucx")
    (version "1.15.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/openucx/ucx")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (patches (search-patches "ucx-tcp-iface-ioctl.patch"))
              (sha256
               (base32
                "1mk46vyfp8hsivk88s8gv0nf458jfs59fczpf66wwa3a9yp324jp"))))
    (build-system gnu-build-system)
    (arguments
     (list
      ;; These are some of the flags found in ;; 'contrib/configure-release'.
      #:configure-flags #~(list
                           "--disable-static"

                           ;; XXX: Disable optimizations specific to the build
                           ;; machine (AVX, etc.)  There's apparently no way to
                           ;; have them picked up at load time.
                           "--disable-optimizations"

                           "--disable-logging"
                           "--disable-debug"
                           "--disable-assertions"
                           "--disable-params-check"

                           (string-append "--with-verbs="
                                          #$(this-package-input "rdma-core"))

                           (string-append "--with-rdmacm="
                                          #$(this-package-input "rdma-core")))

      ;; Be verbose so that compiler flags are displayed.
      #:make-flags #~'("V=1")))
    (native-inputs
     (list autoconf automake libtool pkg-config))
    (inputs
     (list numactl rdma-core))
    (synopsis "Optimized communication layer for message passing in HPC")
    (description
     "Unified Communication X (UCX) provides an optimized communication layer
for message passing (MPI), portable global address space (PGAS) languages and
run-time support libraries, as well as RPC and data-centric applications.

UCX utilizes high-speed networks for inter-node communication, and shared
memory mechanisms for efficient intra-node communication.")
    (home-page "https://www.openucx.org/")
    (license bsd-3)

    ;; <ucm/bistro/bistro.h> lists only PowerPC64, AArch64, and x86_64 as
    ;; supported.
    (supported-systems '("x86_64-linux" "aarch64-linux" "powerpc64le-linux"))))
