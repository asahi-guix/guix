;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013 Cyril Roelandt <tipecaml@gmail.com>
;;; Copyright © 2015 Amirouche Boubekki <amirouche@hypermove.net>
;;; Copyright © 2016 Al McElrath <hello@yrns.org>
;;; Copyright © 2016, 2017 Nikita <nikita@n0.is>
;;; Copyright © 2015 Dmitry Bogatov <KAction@gnu.org>
;;; Copyright © 2015, 2023 Leo Famulari <leo@famulari.name>
;;; Copyright © 2016 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2017 Alex Griffin <a@ajgrf.com>
;;; Copyright © 2018–2021 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2021 Raghav Gururajan <rg@raghavgururajan.name>
;;; Copyright © 2021 Alexandru-Sergiu Marton <brown121407@posteo.ro>
;;; Copyright © 2021 Nikolay Korotkiy <sikmir@disroot.org>
;;; Copyright © 2022 Jai Vetrivelan <jaivetrivelan@gmail.com>
;;; Copyright © 2022 jgart <jgart@dismail.de>
;;; Copyright © 2022 Antero Mejr <antero@mailbox.org>
;;; Copyright © 2022 Ivan Vilata i Balaguer <ivan@selidor.net>
;;; Copyright © 2024 Clément Lassieur <clement@lassieur.org>
;;; Copyright © 2024 Zheng Junjie <873216071@qq.com>
;;; Copyright © 2024 cage <cage-dev@twistfold.it>
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

(define-module (gnu packages suckless)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages libbsd)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mpd)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages))

(define-public slscroll
  (package
    (name "slscroll")
    (version "0.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/tools/scroll-"
                           version ".tar.gz"))
       (sha256
        (base32 "1mpfrvn122lnaqid1pi99ckpxd6x679b0w91pl003xmdwsfdbcly"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no check target
       #:make-flags
       (list
        (string-append "CC=" ,(cc-for-target))
        (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (home-page "https://tools.suckless.org/scroll/")
    (synopsis "Scroll-back buffer program for st")
    (description "Scroll is a program that provides a scroll back buffer for
terminal like @code{st}.")
    (license license:isc)))

(define-public tabbed
  (package
    (name "tabbed")
    (version "0.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/tools/tabbed-"
                           version ".tar.gz"))
       (sha256
        (base32 "0hhwckyzvsj9aim2l6m69wmvl2n7gzd6b1ly8qjnlpgcrcxfllbn"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no check target
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (substitute* "config.mk"
               (("/usr/local")
                (assoc-ref outputs "out"))
               (("/usr/X11R6")
                (assoc-ref inputs "libx11"))
               (("/usr/include/freetype2")
                (string-append (assoc-ref inputs "freetype")
                               "/include/freetype2"))
               (("CC = cc")
                (string-append "CC = " ,(cc-for-target))))))
         (delete 'configure))))         ; no configure script
    (inputs
     `(("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("libx11" ,libx11)
       ("libxft" ,libxft)))
    (home-page "https://tools.suckless.org/tabbed/")
    (synopsis "Tab interface for application supporting Xembed")
    (description "Tabbed is a generic tabbed frontend to xembed-aware
applications.  It was originally designed for surf but also usable with many
other applications, i.e., st, uzbl, urxvt and xterm.")
    (license
     ;; Dual-licensed.
     (list
      license:expat
      license:x11))))

(define-public slstatus
  ;; No release tarballs yet.
  (let ((commit "84a2f117a32f0796045941260cdc4b69852b41e0")
        (revision "0"))
    (package
      (name "slstatus")
      (version (git-version "0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "git://git.suckless.org/slstatus.git")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "063a4fnvsjbc61alnbfdpxy0nwhh9ql9j6s9hkdv12713kv932ds"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f                    ;no test suite
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'patch
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (substitute* "config.mk"
                 (("/usr/local") (assoc-ref outputs "out"))
                 (("/usr/X11R6") (assoc-ref inputs "x11"))
                 (("CC = cc") (string-append "CC = " ,(cc-for-target))))))
           (delete 'configure))))       ;no configure script
      (inputs
       `(("x11" ,libx11)))
      (home-page "https://tools.suckless.org/slstatus/")
      (synopsis "Status monitor for window managers")
      (description "SlStatus is a suckless status monitor for window managers
that use WM_NAME or stdin to fill the status bar.
It provides the following features:
@itemize
@item Battery percentage/state/time left
@item CPU usage
@item CPU frequency
@item Custom shell commands
@item Date and time
@item Disk status (free storage, percentage, total storage and used storage)
@item Available entropy
@item Username/GID/UID
@item Hostname
@item IP address (IPv4 and IPv6)
@item Kernel version
@item Keyboard indicators
@item Keymap
@item Load average
@item Network speeds (RX and TX)
@item Number of files in a directory (hint: Maildir)
@item Memory status (free memory, percentage, total memory and used memory)
@item Swap status (free swap, percentage, total swap and used swap)
@item Temperature
@item Uptime
@item Volume percentage
@item WiFi signal percentage and ESSID
@end itemize")
      (license license:isc))))

(define-public blind
  (package
    (name "blind")
    (version "1.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://dl.suckless.org/tools/blind-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "0nncvzyipvkkd7zlgzwbjygp82frzs2hvbnk71gxf671np607y94"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no check target
       #:make-flags (list (string-append "CC=" ,(cc-for-target))
                          (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (synopsis "Command line video editing utilities")
    (home-page "https://tools.suckless.org/blind/")
    (description
     "Blind is a collection of command line video editing utilities.  It uses
a custom raw video format with a simple container.")
    (license license:isc)))

(define-public dwm
  (package
    (name "dwm")
    (version "6.5")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://dl.suckless.org/dwm/dwm-"
                                 version ".tar.gz"))
             (sha256
              (base32 "0acpl05rg6rg6nrg3rv4kp388iqzp1n6dhin30a97yzjm6zrxmr1"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:make-flags (list (string-append "FREETYPEINC="
                                         (assoc-ref %build-inputs "freetype")
                                         "/include/freetype2"))
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda _
             (substitute* "Makefile" (("\\$\\{CC\\}") "gcc"))
             #t))
        (replace 'install
          (lambda* (#:key outputs #:allow-other-keys)
            (let ((out (assoc-ref outputs "out")))
              (invoke "make" "install"
                      (string-append "DESTDIR=" out) "PREFIX="))))
        (add-after 'build 'install-xsession
          (lambda* (#:key outputs #:allow-other-keys)
            ;; Add a .desktop file to xsessions.
            (let* ((output (assoc-ref outputs "out"))
                   (xsessions (string-append output "/share/xsessions")))
              (mkdir-p xsessions)
              (with-output-to-file
                  (string-append xsessions "/dwm.desktop")
                (lambda _
                  (format #t
                    "[Desktop Entry]~@
                     Name=dwm~@
                     Comment=Dynamic Window Manager~@
                     Exec=~a/bin/dwm~@
                     TryExec=~@*~a/bin/dwm~@
                     Icon=~@
                     Type=Application~%"
                    output)))
              #t))))))
    (inputs
     (list freetype libx11 libxft libxinerama))
    (home-page "https://dwm.suckless.org/")
    (synopsis "Dynamic window manager")
    (description
     "dwm is a dynamic window manager for X.  It manages windows in tiled,
monocle and floating layouts.  All of the layouts can be applied dynamically,
optimising the environment for the application in use and the task performed.")
    (license license:x11)))

(define-public dmenu
  (package
    (name "dmenu")
    (version "5.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://dl.suckless.org/tools/dmenu-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "0pvr6da1v7hmbnacpgxcxv1sakg1nckmw347xhwrhx1dzpk573qs"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output)
             (string-append "FREETYPEINC="
                            (assoc-ref %build-inputs "freetype")
                            "/include/freetype2"))
       #:phases
       (modify-phases %standard-phases (delete 'configure))))
    (inputs
     (list freetype libxft libx11 libxinerama))
    (home-page "https://tools.suckless.org/dmenu/")
    (synopsis "Dynamic menu")
    (description
     "A dynamic menu for X, originally designed for dwm.  It manages large
numbers of user-defined menu items efficiently.")
    (license license:x11)))

(define-public spoon
  (package
    (name "spoon")
    (version "0.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "spoon-" version ".tar.gz"))
       (sha256
        (base32
         "1jpmg9k9f4f3lpz0k3cphqjswlyf8lz2sm8ccifiip93kd4rrdj0"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))))
    (inputs
     (list libx11 libxkbfile alsa-lib ; tinyalsa (unpackaged) would suffice
           libmpdclient))
    (home-page "https://git.2f30.org/spoon/")
    (synopsis "Set dwm status")
    (description
     "Spoon can be used to set the dwm status.")
    (license license:isc)))

(define-public slock
  (package
    (name "slock")
    (version "1.5")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://dl.suckless.org/tools/slock-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "0k8fvf9g27yyaqpyhk6apbkq6r4vjwxhff1qb9ignxx2yvxy7qdf"))))
    (build-system gnu-build-system)
    (arguments
     (list #:tests? #f                      ; no tests
           #:make-flags #~(list (string-append "CC=" #$(cc-for-target))
                                (string-append "PREFIX=" #$output))
           #:phases #~(modify-phases %standard-phases
                        (delete 'configure))))
    (inputs
     (list libx11 libxcrypt libxext libxinerama libxrandr))
    (home-page "https://tools.suckless.org/slock/")
    (synopsis "Simple X session lock")
    (description
     "Simple X session lock with trivial feedback on password entry.")
    (license license:x11)))

(define-public st
  (package
    (name "st")
    (version "0.9.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/st/st-"
                           version ".tar.gz"))
       (sha256
        (base32 "0js9z5kn8hmpxzfmb2g6zsy28zkpg88j3wih5wixc89b8x7ms8bb"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "TERMINFO="
                            (assoc-ref %outputs "out")
                            "/share/terminfo")
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (inputs
     `(("libx11" ,libx11)
       ("libxft" ,libxft)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)))
    (native-inputs
     (list ncurses ;provides tic program
           pkg-config))
    (home-page "https://st.suckless.org/")
    (synopsis "Simple terminal emulator")
    (description
     "St implements a simple and lightweight terminal emulator.  It
implements 256 colors, most VT10X escape sequences, utf8, X11 copy/paste,
antialiased fonts (using fontconfig), fallback fonts, resizing, and line
drawing.")
    (license (list license:x11
                   license:expat))))

(define-public xst
  (package
    (inherit st)
    (name "xst")
    (version "0.8.4.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gnotclub/xst")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1q64x7czpbcg0v509qchn5v96zdnx7jmvy0zxhjmkk3d10x5rqlw"))))
    (home-page "https://github.com/gnotclub/xst")
    (synopsis "Fork of st that uses Xresources")
    (description
     "@command{xst} uses Xresources and applies the following patches to
@command{st}:
@itemize
@item @uref{https://st.suckless.org/patches/alpha/, alpha}
@item @uref{https://st.suckless.org/patches/boxdraw/, boxdraw}
@item @uref{https://st.suckless.org/patches/clipboard/, clipboard}
@item @uref{https://st.suckless.org/patches/disable_bold_italic_fonts/, disable_bold_italic_fonts}
@item @uref{https://st.suckless.org/patches/externalpipe/, externalpipe}
@item @uref{https://st.suckless.org/patches/scrollback/, scrollback}
@item @uref{https://st.suckless.org/patches/spoiler/, spoiler}
@item @uref{https://st.suckless.org/patches/vertcenter/, vertcenter}
@end itemize")
    (license (list license:x11
                   license:expat))))

(define-public lukesmithxyz-st
  (let ((commit "e053bd6036331cc7d14f155614aebc20f5371d3a")
        (revision "0"))
    (package
      (inherit st)
      (name "lukesmithxyz-st")
      (version "0.8.4")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/LukeSmithxyz/st")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "12avzzapkkj4mvd00zh8b6gynk6jysh84jcwlkliyyd82lvyw22v"))))
      (arguments
       (substitute-keyword-arguments (package-arguments st)
         ((#:phases phases)
          `(modify-phases ,phases
             (add-after 'unpack 'remove-calls-to-git
               (lambda _
                 (substitute* "Makefile"
                   (("git submodule init") "")
                   (("git submodule update") ""))))))))
      (inputs (modify-inputs (package-inputs st)
                (prepend libxext harfbuzz)))
      (home-page "https://github.com/LukeSmithxyz/st")
      (synopsis "Luke Smith's fork of st")
      (description
       "This package is Luke's fork of the suckless simple terminal (st) with
Vim bindings and Xresource compatibility.")
      (license license:expat))))

(define-public sxmo-st
  (package
    (inherit st)
    (name "sxmo-st")
    (version "0.8.4.1")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://git.sr.ht/~mil/sxmo-st")
         (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1nl40q1pxf46hpbibz9m9d0giiy1p3lrhr9agw0fkyba2vzbbafa"))))
    (home-page "https://git.sr.ht/~mil/sxmo-st")
    (synopsis "St terminal emulator for the Simple X Mobile PinePhone environment")
    (license license:expat)))

(define-public surf
  (package
    (name "surf")
    (version "2.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/surf/surf-"
                           version ".tar.gz"))
       (sha256
        (base32 "0mrj0kp01bwrgrn4v298g81h6zyq64ijsg790di68nm21f985rbj"))))
    (build-system glib-or-gtk-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         ;; Use the right file name for dmenu and xprop.
         (add-before 'build 'set-dmenu-and-xprop-file-name
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "config.def.h"
               (("dmenu") (search-input-file inputs "/bin/dmenu"))
               (("xprop") (search-input-file inputs "/bin/xprop")))
             #t)))))
    (inputs
     `(("dmenu" ,dmenu)
       ("gcr" ,gcr-3)
       ("glib-networking" ,glib-networking)
       ("gsettings-desktop-schemas" ,gsettings-desktop-schemas)
       ("webkitgtk" ,webkitgtk-with-libsoup2)
       ("xprop" ,xprop)))
    (native-inputs
     (list pkg-config))
    (home-page "https://surf.suckless.org/")
    (synopsis "Simple web browser")
    (description
     "Surf is a simple web browser based on WebKit/GTK+.  It is able to
display websites and follow links.  It supports the XEmbed protocol which
makes it possible to embed it in another application.  Furthermore, one can
point surf to another URI by setting its XProperties.")
    (license (list license:expat
                   license:x11))))

(define-public sent
  (package
    (name "sent")
    (version "1")
    (source (origin
              (method url-fetch/tarbomb)
              (uri (string-append "https://dl.suckless.org/tools/sent-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "0cxysz5lp25mgww73jl0mgip68x7iyvialyzdbriyaff269xxwvv"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (delete 'configure) ;no configuration
                  (add-before 'build 'patch-farbfeld
                    (lambda* (#:key inputs #:allow-other-keys)
                      (substitute* "config.def.h"
                        (("2ff") (search-input-file inputs "/bin/2ff")))))
                  (add-after 'install 'install-doc
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (doc (string-append out "/share/doc/" ,name "-"
                                                 ,(package-version this-package))))
                        (install-file "README.md" doc)))))
       #:tests? #f                                ;no test suite
       #:make-flags
       (let ((pkg-config (lambda (flag)
                           (string-append "$(shell pkg-config " flag " "
                                          "xft fontconfig x11 libpng)"))))
         (list (string-append "CC="
                              ,(cc-for-target))
               (string-append "PREFIX=" %output)
               (string-append "INCS=-I. "
                              (pkg-config "--cflags"))
               (string-append "LIBS="
                              (pkg-config "--libs") " -lm")))))
    (native-inputs (list pkg-config))
    (inputs (list farbfeld libpng libx11 libxft fontconfig))
    (synopsis "Plain-text presentation tool")
    (description
     "Sent uses plain-text files and PNG images to create slideshow
presentations.  Each paragraph represents a slide in the presentation.
Especially for presentations using the Takahashi method this is very nice and
allows you to write down the presentation for a quick lightning talk within a
few minutes.")
    (home-page "https://tools.suckless.org/sent/")
    (license license:isc)))

(define-public wmname
  (package
    (name "wmname")
    (version "0.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/tools/wmname-"
                           version ".tar.gz"))
       (sha256
        (base32 "1i82ilhbk36hspc2j0fbpg27wjj7xnvzpv1ppgf6fccina4d36jm"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases                         ; no tests
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (inputs
     (list libx11))
    (home-page "https://tools.suckless.org/x/wmname/")
    (synopsis "Print or set the window manager name")
    (description "@command{wmname} prints/sets the window manager name
property of the root window similar to how @command{hostname} behaves.  It is
useful for fixing problems with JDK versions and other broken programs
assuming a reparenting window manager for instance.")
    (license (list license:x11
                   license:expat))))

(define-public xbattmon
  (package
    (name "xbattmon")
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "xbattmon-" version ".tar.gz"))
       (sha256
        (base32
         "1zr6y8lml9xkx0a3dbbsds2qz1bjxvskp7wsckkf8mlsqrbb3xsg"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))))
    (inputs
     (list libx11))
    (home-page "https://git.2f30.org/xbattmon/")
    (synopsis "Simple battery monitor for X")
    (description
     "Xbattmon is a simple battery monitor for X.")
    (license license:isc)))

(define-public wificurse
  (package
    (name "wificurse")
    (version "0.3.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "wificurse-" version ".tar.gz"))
       (sha256
        (base32
         "067ghr1xly5ca41kc83xila1p5hpq0bxfcmc8jvxi2ggm6wrhavn"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; No tests
       #:make-flags (list
                     (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)))) ; No configure script
    (home-page "https://git.2f30.org/wificurse/")
    (synopsis "Wifi DoS attack tool")
    (description
     "Wificurses listens for beacons sent from wireless access points
in the range of your wireless station.  Once received the program
extracts the BSSID of the AP and transmits deauthentication packets
using the broadcast MAC address.  This results to the disconnection
of all clients connected to the AP at the time of the attack.  This
is essencially a WiFi DoS attack tool created for educational
purposes only.  It works only in Linux and requires wireless card
drivers capable of injecting packets in wireless networks.")
    (license license:gpl3+)))

(define-public skroll
  (package
    (name "skroll")
    (version "0.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "skroll-" version ".tar.gz"))
       (sha256
        (base32
         "0km6bjfz4ssb1z0xwld6iiixnn7d255ax8yjs3zkdm42z8q9yl0f"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (home-page "https://2f30.org/")
    (synopsis "Commandline utility which scrolls text")
    (description
     "Skroll is a small utility that you can use to make a text scroll.
Pipe text to it, and it will scroll a given number of letters from right to
left.")
    (license license:wtfpl2)))

(define-public sbm
  (package
    (name "sbm")
    (version "0.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "sbm-" version ".tar.gz"))
       (sha256
        (base32
         "1nks5mkh5wn30kyjzlkjlgi31bv1wq52kbp0r6nzbyfnvfdlywik"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (home-page "https://git.2f30.org/sbm/")
    (synopsis "Simple bandwidth monitor")
    (description
     "Sbm is a simple bandwidth monitor.")
    (license license:isc)))

(define-public prout
  (package
    (name "prout")
    (version "0.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "prout-" version ".tar.gz"))
       (sha256
        (base32
         "1s6c3ygg1h1fyxkh8gd7nzjk6qhnwsb4535d2k780kxnwns5fzas"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (inputs
     (list cups-minimal zlib))
    (home-page "https://git.2f30.org/prout/")
    (synopsis "Smaller lp command")
    (description
     "Prout (PRint OUT) is a small utility one can use to send
documents to a printer.
It has no feature, and does nothing else.  Just set your default
printer in client.conf(5) and start printing.  No need for a local
cups server to be installed.")
    (license license:wtfpl2)))

(define-public noice
  (package
    (name "noice")
    (version "0.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "noice-" version ".tar.gz"))
       (sha256
        (base32 "0g01iwzscdv27c1idv93gd74kjzy3n9kazgm6qz08rygp96qx4xw"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)            ; no configure script
         (add-before 'build 'curses
           (lambda _
             (substitute* "Makefile"
               (("lcurses") "lncurses")))))))
    (inputs
     (list ncurses))
    (home-page "https://git.2f30.org/noice/")
    (synopsis "Small file browser")
    (description
     "Noice is a small curses-based file browser.")
    (license license:bsd-2)))

(define-public human
  (package
    (name "human")
    (version "0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "git://git.2f30.org/human.git")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0y0bsmvpwfwb2lwspi6a799y34h1faxc6yfanyw6hygxc8661mga"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (home-page "https://git.2f30.org/human/")
    (synopsis "Convert bytes to human readable formats")
    (description
     "Human is a small program which translate numbers into a
human readable format.  By default, it tries to detect the best
factorisation, but you can force its output.
You can adjust the number of decimals with the @code{SCALE}
environment variable.")
    (license license:wtfpl2)))

(define-public fortify-headers
  (package
    (name "fortify-headers")
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "fortify-headers-" version ".tar.gz"))
       (sha256
        (base32 "1dhz41jq1azcf7rbvga8w6pnx19l1j9r6jwj8qrlrfnjl9hdi9bb"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (home-page "https://git.2f30.org/fortify-headers/")
    (synopsis "Standalone fortify-source implementation")
    (description
     "This is a standalone implementation of fortify source.  It provides
compile time buffer checks.  It is libc-agnostic and simply overlays the
system headers by using the @code{#include_next} extension found in GCC.  It was
initially intended to be used on musl-based Linux distributions.

@itemize
@item It is portable, works on *BSD, Linux, Solaris and possibly others.
@item It will only trap non-conformant programs.  This means that fortify
  level 2 is treated in the same way as level 1.
@item Avoids making function calls when undefined behaviour has already been
  invoked.  This is handled by using @code{__builtin_trap()}.
@item Support for out-of-bounds read interfaces, such as @code{send()},
  @code{write()}, @code{fwrite()}, etc.
@item No ABI is enforced.  All of the fortify check functions are inlined
  into the resulting binary.
@end itemize\n")
    (license license:isc)))

(define-public colors
  (package
    (name "colors")
    (version "0.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "colors-" version ".tar.gz"))
       (sha256
        (base32
         "1lckmqpgj89841splng0sszbls2ag71ggkgr1wsv9y3v6y87589z"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (inputs
     (list libpng))
    (home-page "https://git.2f30.org/colors/")
    (synopsis "Extract colors from pictures")
    (description
     "Extract colors from PNG files.  It is similar to
strings(1) but for pictures.  For a given input file it outputs a
colormap to stdout.")
    (license license:isc)))

(define-public libgrapheme
  (package
    (name "libgrapheme")
    (version "2.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/libgrapheme/libgrapheme-"
                           version
                           ".tar.gz"))
       (sha256
        (base32 "099i2jm9c25nkbg5420wr12z0gd189gcw5j1ssjmpmbbwzfvv2x6"))))
    (build-system gnu-build-system)
    (arguments
     (list #:tests? #true
           #:test-target "test"
           #:phases #~(modify-phases %standard-phases
                        (add-after 'configure 'post-configure
                          (lambda _
                            ;; Remove ldconfing invocation in Makefile, which
                            ;; is not needed in Guix.
                            (substitute* "config.mk"
                              (("ldconfig") "")))))
           #:make-flags
           #~(list (string-append "CC=" #$(cc-for-target))
                   (string-append "PREFIX=" #$output))))
    (home-page "https://libs.suckless.org/libgrapheme/")
    (synopsis "C99 library for Unicode strings")
    (description "Libgrapheme is a simple freestanding C99 library providing
utilities to handle strings according to the Unicode standard.")
    (license license:isc)))

;; No new releases were made at github, this repository is more active than
;; the one at http://git.suckless.org/libutf/ and it is
;; done by the same developer.
(define-public libutf
  (let ((revision "1")
        (commit "ff4c60635e1f455b0a0b4200f8183fbd5a88225b"))
    (package
      (name "libutf")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/cls/libutf")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1ih5vjavilzggyr1j1z6w1z12c2fs5fg77cfnv7ami5ivsy3kg3d"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f                    ; no tests
         #:make-flags
         (list (string-append "CC=" ,(cc-for-target))
               (string-append "PREFIX=" %output))
         #:phases
         (modify-phases %standard-phases
           (delete 'configure))))       ; no configure script
      (inputs
       (list gawk))
      (home-page "https://github.com/cls/libutf")
      (synopsis "Plan 9 compatible UTF-8 library")
      (description
       "This is a C89 UTF-8 library, with an API compatible with that of
Plan 9's libutf, but with a number of improvements:

@itemize
@item Support for runes beyond the Basic Multilingual Plane.
@item utflen and utfnlen cannot overflow on 32- or 64-bit machines.
@item chartorune treats all invalid codepoints as though Runeerror.
@item fullrune, utfecpy, and utfnlen do not overestimate the length
of malformed runes.
@item An extra function, charntorune(p,s,n), equivalent to
fullrune(s,n) ? chartorune(p,s): 0.
@item Runeerror may be set to an alternative replacement value, such
as -1, to be used instead of U+FFFD.
@end itemize\n")
      (license license:expat))))

;; No release tarballs so far.
(define-public lchat
  (let ((revision "4")
        (commit "e3b64e67b9b9d832462382246474ce1e7d92217c"))
    (package
      (name "lchat")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/younix/lchat")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1qcjqbgmsskc04j2r6xl3amkwj05n520sq1wv2mqyqncz42qrxm0"))))
      (build-system gnu-build-system)
      (arguments
       `(#:test-target "test"
         #:make-flags
         (list (string-append "CC=" ,(cc-for-target))
               (string-append "PREFIX=" %output))
         #:phases
         (modify-phases %standard-phases
           (delete 'configure)          ; no configure script
           (add-before 'build 'libbsd
             (lambda _
               (substitute* "Makefile"
                 (("-lutf") "-lutf -lbsd"))))
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out  (assoc-ref outputs "out"))
                      (bin  (string-append out "/bin"))
                      (man1 (string-append out "/share/man/man1")))
                 (install-file "lchat" bin)
                 (install-file "lchat.1" man1)
                 #t))))))
      (inputs
       (list grep ncurses libutf libbsd))
      (home-page "https://github.com/younix/lchat")
      (synopsis "Line chat is a frontend for the irc client ii from suckless")
      (description
       "Lchat (line chat) is the little and small brother of cii.
It is a front end for ii-like chat programs.  It uses @code{tail -f} to get the
chat output in the background.")
      (license license:isc))))

(define-public snooze
  (package
    (name "snooze")
    (version "0.5")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://github.com/leahneukirchen/snooze")
         (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02ng3r1gzgpyjia4b60i11dj5bhn3xjsdcbwmxaam6dzb33dmgib"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; There are no tests.
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             ;; Set prefix path to root of package path in store instead
             ;; of /usr/local.
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://github.com/leahneukirchen/snooze")
    (synopsis "Run a command at a particular time")
    (description
"@command{snooze} is a tool for waiting until a particular time and then
running a command.")
    (license license:cc0)))

(define-public sbase
  ;; There are no tagged releases.
  (let ((commit "2c2a7f54ab55a022a617e510b6e00c3e2736fabd")
        (revision "0"))
    (package
      (name "sbase")
      (version (git-version "0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://git.suckless.org/sbase/")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "119v1lpgsx8bx9h57wg454ddhzz2awqavl3wrn35a704vifg28g0"))))
      (build-system gnu-build-system)
      (arguments
       (list
        #:tests? #f                     ;no test suite
        #:make-flags #~(list (string-append "CC=" #$(cc-for-target))
                             (string-append "PREFIX=" #$output))
        #:phases
        #~(modify-phases %standard-phases
            (delete 'configure))))
      (home-page "https://core.suckless.org/sbase/")
      (synopsis "Collection of UNIX tools")
      (description "@command{sbase} is a collection of UNIX tools similar to those of GNU
Coreutils, containing utilities commands such as @command{grep}, @command{cp},
@command{rm}, etc.")
      (license license:expat))))

(define-public scron
  (package
    (name "scron")
    (version "0.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.2f30.org/releases/"
                           "scron-" version ".tar.gz"))
       (sha256
        (base32
         "066fwa55kqcgfrsqgxh94sqbkxfsr691360xg4ljxr4i75d25s2a"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ; no configure script
    (home-page "https://git.2f30.org/scron/")
    (synopsis "Simple cron daemon")
    (description
     "Schedule commands to be run at specified dates and times.
Single daemon and configuration file.  Log to stdout or syslog.  No mail
support.")
    (license license:expat)))

(define-public sfm
  (package
    (name "sfm")
    (version "0.4")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "git://git.afify.dev/sfm.git")
         (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0g6k884mggryld0k054sjcj6kpkbca9cvr50w98klszym73yw0sp"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ;no check target
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))         ;no configure script
    (home-page "https://github.com/afify/sfm")
    (synopsis "Simple file manager")
    (description "sfm is a simple file manager.")
    (license license:isc)))

(define-public sfeed
  (package
    (name "sfeed")
    (version "2.0")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "git://git.codemadness.org/sfeed")
         (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0zmgkvq75a7h4rmk7izpsaxswlqh9zg446wxv7qcw0bh5xdckg0d"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f                       ;no check target
      #:make-flags
      #~(list (string-append "CC=" #$(cc-for-target))
              (string-append "PREFIX=" #$output))
      #:phases
      '(modify-phases %standard-phases
         (add-after 'unpack 'fix-ncurses
           (lambda _
             (substitute* "Makefile"
               (("-lcurses") "-lncurses"))))
         (delete 'configure))))         ;no configure script
    (inputs
     (list ncurses))
    (home-page "https://git.codemadness.org/sfeed")
    (synopsis "RSS and Atom parser")
    (description
     "@code{sfeed} converts RSS or Atom feeds from XML to a TAB-separated file.
There are formatting programs included to convert this TAB-separated format to
various other formats.  There are also some programs and scripts included to
import and export OPML and to fetch, filter, merge and order feed items.")
    (license license:isc)))

(define-public farbfeld
  (let ((commit "ab5e3dfc9cdb476218538c6687df9f44826d8f11") (revision "0"))
    (package
      (name "farbfeld")
      (version (git-version "4" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "git://git.suckless.org/farbfeld")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0pkmkvv5ggpzqwqdchd19442x8gh152xy5z1z13ipfznhspsf870"))))
      (build-system gnu-build-system)
      (inputs (list libpng libjpeg-turbo imagemagick))
      (arguments
       (list #:tests?
             #f ;no check target
             #:make-flags
             #~(list (string-append "PREFIX="
                                    #$output)
                     (string-append "CC="
                                    #$(cc-for-target)))
             #:phases
             #~(modify-phases %standard-phases
                 (add-before 'configure 'patch-2ff
                   (lambda* (#:key inputs outputs #:allow-other-keys)
                     (substitute* "2ff"
                       (("png2ff") (string-append #$output "/bin/png2ff"))
                       (("jpg2ff") (string-append #$output "/bin/jpg2ff"))
                       (("convert") (search-input-file inputs "/bin/convert")))))
                 (delete 'configure))))
      (synopsis "Image format and conversion tools")
      (description
       "farbfeld is a lossless image format which is easy to parse,
pipe and compress.")
      (home-page "https://git.suckless.org/farbfeld/")
      (license license:isc))))

(define-public snafu
  (let ((commit "e436fb4f61ca93a4ec85122506b2c2d4fec30eb6")
        (revision "0"))
    (package
      (name "snafu")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/jsbmg/snafu")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1c6ahxw0qz0703my28k2z0kgi0am5bp5d02l4rgyphgvjk1jfv8h"))))
      (arguments
       `(#:cargo-inputs
         (("rust-chrono" ,rust-chrono-0.4))
         #:tests? #f)) ; There are no tests.
      (build-system cargo-build-system)
      (home-page "https://github.com/jsbmg/snafu")
      (synopsis "Status text for DWM window manager")
      (description "@code{snafu} provides status text for DWM's builtin bar.  It
shows battery status, battery capacity, current WiFi connection, and the time in
a nice format.")
      (license license:isc))))

(define-public svkbd
  (package
    (name "svkbd")
    (version "0.4.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://dl.suckless.org/tools/svkbd-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "0nhgmr38pk1a8zrcrxd1ygh0m843a3bdchkv8phl508x7vy63hpv"))))
    (build-system gnu-build-system)
    (arguments
     (list #:tests? #f
           #:make-flags
           #~(list (string-append "CC=" #$(cc-for-target))
                   (string-append "PREFIX=" #$output))
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'unpack 'patch
                 (lambda* (#:key inputs outputs #:allow-other-keys)
                   (substitute* "config.mk"
                     (("/usr/local") #$output)
                     (("/usr/X11R6") #$libx11)
                     (("/usr/include/freetype2") (string-append #$freetype
                                                  "/include/freetype2")))))
               (delete 'configure)))) ;no configure script
    (native-inputs (list pkg-config))
    (inputs (list freetype libx11 libxft libxtst libxinerama))
    (propagated-inputs (list (libc-utf8-locales-for-target)))
    (home-page "https://tools.suckless.org/x/svkbd/")
    (synopsis "Virtual on-screen keyboard")
    (description "svkbd is a simple virtual keyboard, intended to be used in
environments, where no keyboard is available.")
    (license license:expat)))

(define-public lib9
  ;; no release since 2010
  (let ((commit "63916da7bd6d73d9a405ce83fc4ca34845667cce")
        (revision "0"))
    (package
      (name "lib9")
      (version (git-version "7" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.suckless.org/9base/")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "04j8js4s3jmlzi3m46q81bq76rn41an58ffhkbj9p5wwr5hvplh8"))))
      (build-system gnu-build-system)
      (arguments
       (list #:tests? #f ;no tests
             #:phases #~(modify-phases %standard-phases
                          (add-after 'unpack 'patch
                            (lambda _
                              (substitute* "config.mk"
                                (("^PREFIX.*=.*$")
                                 (string-append "PREFIX=\"" #$output "\"\n"))
                                (("^OBJTYPE.*=.*$")
                                 #$@(cond
                                     ((target-x86-64?)
                                      #~(string-append "OBJTYPE=x86_64\n"))
                                     ((target-x86?)
                                      #~(string-append "OBJTYPE=386\n"))
                                     ((target-powerpc?)
                                      #~(string-append "OBJTYPE=power\n"))
                                     ((target-arm32?)
                                      #~(string-append "OBJTYPE=arm\n"))))
                                (("^CFLAGS.*+=.*$")
                                 (string-append
                                  "CFLAGS+=-O2 -g -I. -fPIC -c -DPLAN9PORT "
                                  "-DPREFIX=\\\"" #$output "\\\"\n"))
                                (("^LDFLAGS.*+=.*$")
                                 "LDFLAGS+=\n")
                                (("^CC.*=.*$")
                                 (string-append "CC=" #$(cc-for-target) "\n")))
                              (substitute* "lib9/libc.h"
                                (("#define main.*p9main")
                                 ""))
                              (substitute* "lib9/main.c"
                                (("p9main\\(argc, argv\\);")
                                 "")
                                (("extern void p9main\\(int, char\\*\\*\\);")
                                 ""))
                              (substitute* "lib9/Makefile"
                                (("lib9.a")
                                 "lib9.so")
                                (("LIB9OFILES=\\\\")
                                 "LIB9OFILES=convM2D.o \\")
                                (("@\\$\\{AR\\} \\$\\{LIB\\} \\$\\{OFILES\\}")
                                 "gcc -shared  ${OFILES} -o lib9.so"))))
                          (add-after 'patch 'chdir
                            (lambda _
                              (chdir "lib9")))
                          (delete 'configure)))) ;no configure script
      (home-page "https://tools.suckless.org/9base/")
      (supported-systems '("x86_64-linux" "i686-linux" "armhf-linux"
                           "powerpc-linux"))
      (synopsis "Unix port of Plan 9's formatted I/O C library")
      (description
       "This package provides a ported version of the Plan 9 lib9 C library.
It also contains the Plan 9 libbio, libregexp, libfmt and libutf libraries.")
      (license (list license:expat ;modifications
                     license:lpl1.02))))) ;original plan9 code

(define-public xssstate
  (package
    (name "xssstate")
    (version "1.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://dl.suckless.org/tools/xssstate-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "04b03jz38pn5qhddg8a9hh01qqzrrdjvsq09qrxj9sx8lq2gbdn4"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f  ; no tests
      #:make-flags #~(list (string-append "CC="
                                          #$(cc-for-target))
                           (string-append "PREFIX=" #$output))
      #:phases #~(modify-phases %standard-phases
                   (delete 'configure))))
    (inputs (list libxscrnsaver))
    (home-page "https://tools.suckless.org/x/xssstate/")
    (synopsis "Simple tool to retrieve the X screensaver state")
    (description
     "A utility to retrieve the state of the X screensaver.  These
states include the idle time, the screensaver state and the length of time
until the screensaver should be activated.")
    (license license:x11)))

(define-public 9yacc
  (package
    (inherit lib9)
    (name "9yacc")
    (arguments
     (substitute-keyword-arguments (package-arguments lib9)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'patch 'patch-for-9yacc
              (lambda _
                (substitute* "yacc/yacc.c"
                  (("#9/yacc")
                   (string-append #$output "/lib")))
                (substitute* "config.mk"
                  (("^CFLAGS.*+=.*$")
                   (string-append "CFLAGS+=-O2 -g -c -DPLAN9PORT "
                                  "-DPREFIX=\\\"" #$output "\\\"\n")))))
            (replace 'chdir
              (lambda _
                (chdir "yacc")))
            (delete 'install-include)
            (add-after 'install 'install-yaccpar
              (lambda _
                (install-file "yaccpar" (string-append #$output "/lib"))
                (install-file "yaccpars" (string-append #$output "/lib"))))))))
    (inputs (list lib9))
    (synopsis "Port of Plan 9's yacc parser generator for Unix")
    (description
     "This package provides a ported version of the Plan 9 yacc parser
generator.")))

(define-public 9base
  (package
    (inherit 9yacc)
    (name "9base")
    (arguments
     (substitute-keyword-arguments (package-arguments 9yacc)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'patch-for-9yacc 'patch-for-9base
              (lambda _
                (substitute* "Makefile"
                  (("SUBDIRS  = lib9\\\\")
                   "SUBDIRS = \\")
                  (("@chmod 755 yacc/9yacc")
                   ""))
                (for-each (lambda (x)
                            (substitute* "Makefile"
                              (((string-append x "\\\\")) "\\")))
                          '("yacc" "diff" "hoc" "rc"))
                (substitute* "sam/Makefile"
                  (("\\$\\{CFLAGS\\}")
                   "${CFLAGS} -I."))
                (substitute* "config.mk"
                  (("^YACC.*=.*$")
                   (string-append "YACC=" #$(this-package-native-input "9yacc")
                                  "/bin/yacc\n")))))
            (delete 'chdir)
            (delete 'install-yaccpar)))))
    (native-inputs (list 9yacc))
    (inputs (list lib9))
    (propagated-inputs (list rc))
    (synopsis "Port of various Plan 9 tools for Unix")
    (description
     "This package provides ported versions of various Plan 9 userland tools
for Unix.")))
