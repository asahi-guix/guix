;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016, 2017, 2019, 2021, 2022 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2017 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2017 Clément Lassieur <clement@lassieur.org>
;;; Copyright © 2017 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017, 2018, 2019, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
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

(define-module (gnu packages connman)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix licenses)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages enlightenment)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages samba)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages vpn))

(define-public connman
  (package
    (name "connman")
    (version "1.42")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "mirror://kernel.org/linux/network/connman/"
                            "connman-" version ".tar.xz"))
        (sha256
         (base32 "1an24caah35chc1c48p67ln8kpj9fr7slg5fklpfz0f0dzjbmrm3"))
        (patches
         (search-patches "connman-add-missing-libppp-compat.h.patch"))))
    (build-system gnu-build-system)
    (arguments
     (list #:configure-flags
           #~(list "--enable-nmcompat"
                   ;; PolKit doesn't need to be present at build time.
                   "--enable-polkit"
                   "--enable-iwd"
                   "--enable-l2tp"
                   "--enable-openconnect"
                   "--enable-openvpn"
                   "--enable-vpnc"
                   "--localstatedir=/var"
                   (string-append "--with-l2tp="
                                  #$(this-package-input "xl2tpd")
                                  "/sbin/xl2tpd")
                   (string-append "--with-openconnect="
                                  #$(this-package-input "openconnect")
                                  "/sbin/openconnect")
                   (string-append "--with-openvpn="
                                  #$(this-package-input "openvpn")
                                  "/sbin/openvpn")
                   (string-append "--with-vpnc="
                                  #$(this-package-input "vpnc")
                                  "/sbin/vpnc")
                   (string-append "--with-dbusconfdir=" #$output "/etc")
                   (string-append "--with-dbusdatadir=" #$output "/share"))))
    (native-inputs
     (list pkg-config
           python-wrapper))
    (inputs
     (list dbus
           glib
           gnutls
           iptables
           libmnl
           lz4 ; required by openconnect.pc
           readline
           ;; These inputs are needed for connman to include the interface to
           ;; these technologies so IF they are installed they can be used.
           ;; TODO: add neard, ofono
           openconnect
           openvpn
           ppp
           vpnc
           wpa-supplicant
           xl2tpd))
    (home-page "https://01.org/connman")
    (synopsis "Connection management daemon")
    (description "Connman provides a daemon for managing Internet connections.
The Connection Manager is designed to be slim and to use as few resources as
possible. It is fully modular system that can be extended through plug-ins.
The plug-in approach allows for easy adaption and modification for various use
cases.  Connman implements DNS resolving and caching, DHCP clients for both
IPv4 and IPv6, link-local IPv4 address handling and tethering (IP connection
sharing) to clients via USB, ethernet, WiFi, cellular and Bluetooth.")
    (license gpl2)))

(define-public econnman
  (package
    (name "econnman")
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://download.enlightenment.org/rel/apps/"
                           "econnman/econnman-" version ".tar.gz"))
       (sha256
        (base32
         "057pwwavlvrrq26bncqnfrf449zzaim0zq717xv86av4n940gwv0"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags '("--localstatedir=/var")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'set-home-directory
           ;; FATAL: Cannot create run dir '/homeless-shelter/.run' - errno=2
           (lambda _ (setenv "HOME" "/tmp") #t))
         (add-after 'install 'wrap-binary
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/econnman-bin")))
               (wrap-program bin
                 `("GUIX_PYTHONPATH" ":" prefix
                   (,(getenv "GUIX_PYTHONPATH"))))))))))
    (native-inputs (list pkg-config))
    (inputs
     (list bash-minimal                 ;for wrap-program
           efl
           python-wrapper
           python-dbus
           python-efl))
    (home-page "https://www.enlightenment.org")
    (synopsis "Connman User Interface written using the EFL")
    (description
     "An EFL user interface for the @code{connman} connection manager.")
    (license lgpl3)))

(define-public cmst
  (package
    (name "cmst")
    (version "2020.11.01")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/andrew-bibb/cmst/releases/download/"
             version "/cmst-" version ".tar.xz"))
       (sha256
        (base32 "0jn12wxwjznady6aniwmvahg1dj25p902sdwj0070biv6vx5c7dq"))))
    (inputs
     (list qtbase-5))
    (native-inputs
     (list qttools-5))
    (build-system gnu-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (invoke "qmake"
                     (string-append "PREFIX="
                                    (assoc-ref outputs "out")))))
         (add-before 'build 'fix-Makefiles
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (substitute* (find-files "." "Makefile")
                 (("INSTALL_ROOT)")
                  (string-append "INSTALL_ROOT)" out))
                 (("/usr") ""))
               (substitute* '("apps/cmstapp/cmstapp.pro"
                              "apps/cmstapp/code/control_box/controlbox.cpp"
                              "apps/rootapp/rootapp.pro"
                              "apps/rootapp/system/org.cmst.roothelper.service"
                              "cmst.pri"
                              "cmst.pro")
                 (("/usr") out)
                 (("/etc") (string-append out "/etc")))
               #t))))))
    (home-page "https://github.com/andrew-bibb/cmst")
    (synopsis "Qt frontend for Connman")
    (description
     "Cmst is a Qt based frontend for the @code{connman} connection manager.
This package also provides a systemtray icon.")
    (license x11)))
