;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015-2023 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2015 Federico Beffa <beffa@fbengineering.ch>
;;; Copyright © 2016, 2018, 2020-2024 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 David Thompson <davet@gnu.org>
;;; Copyright © 2016-2019, 2021, 2023 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2016, 2017, 2018 Theodoros Foradis <theodoros@foradis.org>
;;; Copyright © 2017 Julien Lepiller <julien@lepiller.eu>
;;; Copyright © 2018–2021 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Clément Lassieur <clement@lassieur.org>
;;; Copyright © 2018, 2019 Jonathan Brielmaier <jonathan.brielmaier@web.de>
;;; Copyright © 2018, 2019, 2020 Arun Isaac <arunisaac@systemreboot.net>
;;; Copyright © 2019 Tim Stahel <swedneck@swedneck.xyz>
;;; Copyright © 2019 Jovany Leandro G.C <bit4bit@riseup.net>
;;; Copyright © 2019 Steve Sprang <scs@stevesprang.com>
;;; Copyright © 2019 John Soo <jsoo1@asu.edu>
;;; Copyright © 2020 Brice Waegeneire <brice@waegenei.re>
;;; Copyright © 2020,2021 Vincent Legoll <vincent.legoll@gmail.com>
;;; Copyright © 2020, 2023 Marius Bakke <marius@gnu.org>
;;; Copyright © 2020, 2021 Ekaitz Zarraga <ekaitz@elenq.tech>
;;; Copyright © 2020 B. Wilson <elaexuotee@wilsonb.com>
;;; Copyright © 2020, 2021, 2022, 2023, 2024 Vinicius Monego <monego@posteo.net>
;;; Copyright © 2020, 2021, 2023 Morgan Smith <Morgan.J.Smith@outlook.com>
;;; Copyright © 2021 qblade <qblade@protonmail.com>
;;; Copyright © 2021 Gerd Heber <gerd.heber@gmail.com>
;;; Copyright © 2021, 2022 Guillaume Le Vaillant <glv@posteo.net>
;;; Copyright © 2021 Ivan Gankevich <i.gankevich@spbu.ru>
;;; Copyright © 2021, 2022 Petr Hodina <phodina@protonmail.com>
;;; Copyright © 2021 Foo Chuan Wei <chuanwei.foo@hotmail.com>
;;; Copyright © 2022 Evgeny Pisemsky <mail@pisemsky.site>
;;; Copyright © 2022 Olivier Dion <olivier.dion@polymtl.ca>
;;; Copyright © 2022 Peter Polidoro <peter@polidoro.io>
;;; Copyright © 2022 Malte Frank Gerdes <malte.f.gerdes@gmail.com>
;;; Copyright © 2022 Konstantinos Agiannis <agiannis.kon@gmail.com>
;;; Copyright © 2022 Greg Hogan <code@greghogan.com>
;;; Copyright © 2022 Artyom V. Poptsov <poptsov.artyom@gmail.com>
;;; Copyright © 2022 Maxim Cournoyer <maxim.cournoyer@gmail.com>
;;; Copyright © 2022, 2023 Felix Gruber <felgru@posteo.net>
;;; Copyright © 2023 Theofilos Pechlivanis <theofilos.pechlivanis@gmail.com>
;;; Copyright © 2023 Sharlatan Hellseher <sharlatanus@gmail.com>
;;; Copyright © 2023 pinoaffe <pinoaffe@gmail.com>
;;; Copyright © 2024 Juliana Sims <juli@incana.org>
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

(define-module (gnu packages engineering)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system ant)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system emacs)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix build-system qt)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix monads)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix svn-download)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bdw-gc)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages c)
  #:use-module (gnu packages check)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages code)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages dejagnu)
  #:use-module (gnu packages digest)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages file)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages fpga)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gd)
  #:use-module (gnu packages geo)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gperf)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages groff)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages linux)               ;FIXME: for pcb
  #:use-module (gnu packages lisp)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages man)
  #:use-module (gnu packages markup)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages openkinect)
  #:use-module (gnu packages openkinect)
  #:use-module (gnu packages parallel)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pretty-print)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages sagemath)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages stb)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages tbb)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages time)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages tree-sitter)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages web)
  #:use-module (gnu packages wxwidgets)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module ((srfi srfi-1) #:hide (zip)))

(define-public librecad
  (package
    (name "librecad")
    (version "2.2.0.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/LibreCAD/LibreCAD")
                     (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "04pyywkc0nzhdx1wi0g63hldmbpdp0wvlrhqv8p3m1z6wyyafgjn"))))
    (build-system qt-build-system)
    (arguments
     '(#:test-target "check"
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs #:allow-other-keys)
             (system* "qmake" (string-append "BOOST_DIR="
                                             (assoc-ref inputs "boost")))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out   (assoc-ref outputs "out"))
                    (bin   (string-append out "/bin"))
                    (share (string-append out "/share/librecad")))
               (mkdir-p bin)
               (install-file "unix/librecad" bin)
               (mkdir-p share)
               (copy-recursively "unix/resources" share)))))))
    (inputs
     (list bash-minimal boost muparser freetype qtbase-5 qtsvg-5))
    (native-inputs
     (list pkg-config which))
    (home-page "https://librecad.org/")
    (synopsis "Computer-aided design (CAD) application")
    (description
     "LibreCAD is a 2D Computer-aided design (CAD) application for creating
plans and designs.")
    (license license:gpl2)))

(define-public geda-gaf
  (package
    (name "geda-gaf")
    (version "1.10.2")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://ftp.geda-project.org/geda-gaf/stable/v"
                    (version-major+minor version) "/"
                    version "/geda-gaf-" version ".tar.gz"))
              (sha256
               (base32
                "19688b0671imy2i3jphcnq1120b8ymhr4wz2psiqylr82ljanqp8"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      '(modify-phases %standard-phases
         ;; tests require a writable HOME
         (add-before 'check 'set-home
           (lambda _
             (setenv "HOME" (getenv "TMPDIR"))))
         (add-after 'unpack 'disable-failing-tests
           (lambda _
             (substitute* "xorn/tests/Makefile.in"
               (("-Werror") ""))
             ;; This test returns its correct result in an unexpected order.
             (substitute* "libgeda/scheme/unit-tests/t0402-config.scm"
               (("\\(begin-config-test 'config-keys" m)
                (string-append "#;" m))))))
      #:configure-flags
      #~(let ((pcb #$(this-package-input "pcb")))
          (list (string-append "--with-pcb-datadir=" pcb "/share")
                (string-append "--with-pcb-lib-path="
                               pcb "/share/pcb/pcblib-newlib:"
                               pcb "/share/pcb/newlib")))))
    (inputs
     (list gamin
           gdk-pixbuf
           glib
           gtk+-2
           guile-2.0
           shared-mime-info
           m4
           pcb
           python-2)) ; for xorn
    (native-inputs
     (list groff pkg-config desktop-file-utils perl)) ; for tests
    (home-page "http://geda-project.org/")
    (synopsis "Schematic capture, netlister, symbols, symbol checker, and utils")
    (description
     "Gaf stands for “gschem and friends”.  It is a subset of the entire tool
suite grouped together under the gEDA name.  gEDA/gaf is a collection of tools
which currently includes: gschem, a schematic capture program; gnetlist, a
netlist generation program; gsymcheck, a syntax checker for schematic symbols;
gattrib, a spreadsheet programme that manipulates the properties of symbols of
a schematic; libgeda, libraries for gschem gnetlist and gsymcheck; gsch2pcb, a
tool to forward annotation from your schematic to layout using PCB; some minor
utilities.")
    (license license:gpl2+)))

(define-public lepton-eda
  ;; This is a fork of gEDA/gaf started in late 2016.  One of its goal is to
  ;; keep and to extend Guile support.
  (package
    (inherit geda-gaf)
    (name "lepton-eda")
    (version "1.9.18-20220529")
    (home-page "https://github.com/lepton-eda/lepton-eda")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url home-page)
                    (commit version)))
              (sha256
               (base32
                "06plrcab3s2rpyf0qv2gzc1yp33627xi8105niasgixckk6glnc2"))
              (file-name (git-file-name name version))))
    (arguments
     (list
      #:configure-flags
      #~(let ((pcb #$(this-package-input "pcb")))
          ;; When running "make", the POT files are built with the build time as
          ;; their "POT-Creation-Date".  Later on, "make" notices that .pot
          ;; files were updated and goes on to run "msgmerge"; as a result, the
          ;; non-deterministic POT-Creation-Date finds its way into .po files,
          ;; and then in .gmo files.  To avoid that, simply make sure 'msgmerge'
          ;; never runs.  See <https://bugs.debian.org/792687>.
          (list "ac_cv_path_MSGMERGE=true" "--with-gtk3"
                (string-append "--with-pcb-datadir=" pcb
                               "/share")
                (string-append "--with-pcb-lib-path=" pcb
                               "/share/pcb/pcblib-newlib:"
                               pcb "/share/pcb/newlib")
                "CFLAGS=-fcommon"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'fix-tests
            (lambda _
              ;; For logs and auto-compilation
              (setenv "HOME" "/tmp")

              ;; Ensure that readline is found by lepton-shell
              (substitute* "script.in"
                (("\\(eval-when \\(expand load eval\\)" m)
                 (string-append "
(add-to-load-path \"" #$(this-package-input "guile-readline")
"/share/guile/site/3.0\")
(set! %load-compiled-path (cons \""
#$(this-package-input "guile-readline")
"/lib/guile/3.0/site-ccache/"
"\" %load-compiled-path))
" m)))))
          (add-before 'build 'fix-dynamic-link
            (lambda* (#:key inputs #:allow-other-keys)
              (substitute* "liblepton/scheme/lepton/ffi/lib.scm"
                (("\"liblepton\"")
                 (string-append "\"" #$output "/lib/liblepton.so" "\""))
                (("\"libleptonattrib\"")
                 (string-append "\"" #$output "/lib/libleptonattrib.so" "\""))
                (("\"libleptongui\"")
                 (string-append "\"" #$output "/lib/libleptongui.so" "\""))
                (("\"libglib-2.0\"")
                 (string-append
                  "\"" (search-input-file inputs "/lib/libglib-2.0.so") "\""))
                (("\"libgobject-2.0\"")
                 (string-append
                  "\"" (search-input-file inputs "/lib/libgobject-2.0.so") "\""))
                (("\"libgtk-3\"")
                 (string-append
                  "\"" (search-input-file inputs "/lib/libgtk-3.so") "\"")))

              ;; For finding libraries when running tests before installation.
              (setenv "LIBLEPTONGUI"
                      (string-append (getcwd)
                                     "/libleptongui/src/.libs/libleptongui.so"))
              (setenv "LIBLEPTON"
                      (string-append (getcwd)
                                     "/libleptongui/src/.libs/liblepton.so"))
              (setenv "LD_LIBRARY_PATH"
                      (string-append (getcwd)
                                     "/libleptonattrib/src/.libs/:"
                                     (getenv "LIBRARY_PATH")))))
          (add-before 'bootstrap 'prepare
            (lambda _
              ;; Some of the scripts there are invoked by autogen.sh.
              (for-each patch-shebang
                        (find-files "build-tools"))

              ;; Make sure 'msgmerge' can modify the PO files.
              (for-each (lambda (po)
                          (chmod po #o666))
                        (find-files "." "\\.po$"))

              ;; This would normally be created by invoking 'git', but it
              ;; doesn't work here.
              (call-with-output-file "version.h"
                (lambda (port)
                  (format port "#define PACKAGE_DATE_VERSION \"~a\"~%"
                          #$(string-drop version
                                         (+ 1
                                            (string-index version #\-))))
                  (format port
                          "#define PACKAGE_DOTTED_VERSION \"~a\"~%"
                          #$(string-take version
                                         (string-index version #\-)))
                  (format port
                          "#define PACKAGE_GIT_COMMIT \"cabbag3\"~%")))))
          (add-after 'install 'compile-scheme-files
            (lambda _
              (unsetenv "LIBLEPTONGUI")
              (unsetenv "LIBLEPTON")
              (unsetenv "LD_LIBRARY_PATH")
              (invoke "make" "precompile"))))))
    (native-inputs
     (modify-inputs (package-native-inputs geda-gaf)
       (prepend autoconf
                automake
                desktop-file-utils
                libtool
                gettext-minimal
                texinfo
                groff
                which)))
    (inputs
     (list glib
           gtk+
           gtksheet
           guile-3.0
           guile-readline
           shared-mime-info
           m4
           pcb))
    (description
     "Lepton EDA ia an @dfn{electronic design automation} (EDA) tool set
forked from gEDA/gaf in late 2016.  EDA tools are used for electrical circuit
design, schematic capture, simulation, prototyping, and production.  Lepton
EDA includes tools for schematic capture, attribute management, bill of
materials (BOM) generation, netlisting into over 20 netlist formats, analog
and digital simulation, and printed circuit board (PCB) layout, and many other
features.")))

(define-public librnd
  (package
    (name "librnd")
    (version "4.0.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://www.repo.hu/projects/librnd/releases/"
                                  "librnd-" version ".tar.bz2"))
              (sha256
               (base32
                "0z578x3sd8yjfbhivy1hz4hlgiy43qq6x7mnby872plpm08vgqxz"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #false                   ;no check target
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'cc-is-gcc
            (lambda _ (setenv "CC" #$(cc-for-target))))
          (replace 'configure
            ;; The configure script doesn't tolerate most of our configure flags.
            (lambda _
              (invoke "sh" "configure"
                      (string-append "--prefix=" #$output)))))))
    (inputs
     (list gd gtk glib glu))
    (native-inputs
     (list pkg-config))
    (home-page "http://repo.hu/projects/librnd/")
    (synopsis "Two-dimensional CAD engine")
    (description "This is a flexible, modular two-dimensional CAD engine
@itemize
@item with transparent multiple GUI toolkit support;
@item a flexible, dynamic menu system;
@item a flexible, dynamic configuration system; and
@item support for user scripting in a dozen languages.
@end itemize")
    (license license:gpl2+)))

(define-public pcb
  (package
    (name "pcb")
    (version "4.3.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/pcb/pcb/pcb-" version
                                  "/pcb-" version ".tar.gz"))
              (sha256
               (base32
                "0ppv8cblw0h70laly4zp8gmbxkbzzhbbjgw13pssgaw4mx32z1df"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'check 'pre-check
            (lambda _
              (system "Xvfb :1 &")
              (setenv "DISPLAY" ":1"))))))
    (inputs
     (list dbus
           mesa
           glu
           gd
           gtk+-2
           gtkglext
           shared-mime-info
           tk))
    (native-inputs
     (list bison
           desktop-file-utils
           flex
           intltool
           pkg-config
           ;; For tests
           imagemagick
           gerbv
           ghostscript
           xorg-server-for-tests))
    (home-page "http://pcb.geda-project.org/")
    (synopsis "Design printed circuit board layouts")
    (description
     "GNU PCB is an interactive tool for editing printed circuit board
layouts.  It features a rats-nest implementation, schematic/netlist import,
and design rule checking.  It also includes an autorouter and a trace
optimizer; and it can produce photorealistic and design review images.")
    (license license:gpl2+)))

(define-public pcb-rnd
  (package (inherit pcb)
    (name "pcb-rnd")
    (version "3.1.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://repo.hu/projects/pcb-rnd/releases/"
                                  "pcb-rnd-" version ".tar.gz"))
              (sha256
               (base32
                "0szcsp2049wh3wslv7743wbjqllrmphi07yz0933sz4vf6f1c8dg"))))
    (arguments
     (list
      #:tests? #false                   ;no check target
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'cc-is-gcc
            (lambda _ (setenv "CC" #$(cc-for-target))))
          (replace 'configure
            ;; The configure script doesn't tolerate most of our configure flags.
            (lambda _
              (setenv "LIBRND_PREFIX" #$(this-package-input "librnd"))
              (invoke "sh" "configure"
                      (string-append "--prefix=" #$output)))))))
    (inputs
     (modify-inputs (package-inputs pcb)
       (append librnd)))
    (home-page "http://repo.hu/projects/pcb-rnd/")
    (description "PCB RND is a fork of the GNU PCB circuit board editing tool
featuring various improvements and bug fixes.")))

(define-public fastcap
  (package
    (name "fastcap")
    (version "2.0-18Sep92")
    (source (origin
              (method url-fetch/tarbomb)
              (uri (string-append "http://www.rle.mit.edu/cpg/codes/"
                                  name "-" version ".tgz"))
              (sha256
               (base32
                "0x37vfp6k0d2z3gnig0hbicvi0jp8v267xjnn3z8jdllpiaa6p3k"))
              (snippet
               ;; Remove a non-free file.
               '(begin
                  (delete-file "doc/psfig.sty")
                  #t))
              (patches (search-patches "fastcap-mulSetup.patch"
                                       "fastcap-mulGlobal.patch"))))
    (build-system gnu-build-system)
    (native-inputs
     ;; FIXME: with (texlive-updmap.cfg) citation references are rendered as
     ;; question marks.  During the build warnings like these are printed:
     ;; LaTeX Warning: Citation `nabors91' on page 2 undefined on input line
     ;; 3.
     `(("texlive" ,(texlive-updmap.cfg))
       ("ghostscript" ,ghostscript)))
    (arguments
     `(#:make-flags '("CC=gcc" "RM=rm" "SHELL=sh" "all")
       #:parallel-build? #f
       #:tests? #f ;; no tests-suite
       #:modules ((srfi srfi-1)
                  ,@%default-gnu-modules)
       #:phases
       (modify-phases %standard-phases
         (add-after 'build 'make-doc
           (lambda _
             (invoke "make" "CC=gcc" "RM=rm" "SHELL=sh" "manual")))
         (add-before 'make-doc 'fix-doc
           (lambda _
             (substitute* "doc/Makefile" (("/bin/rm") (which "rm")))
             (substitute* (find-files "doc" "\\.tex")
               (("\\\\special\\{psfile=([^,]*),.*scale=([#0-9.]*).*\\}"
                 all file scale)
                (string-append "\\includegraphics[scale=" scale "]{"
                               file "}"))
               (("\\\\psfig\\{figure=([^,]*),.*width=([#0-9.]*in).*\\}"
                 all file width)
                (string-append "\\includegraphics[width=" width "]{"
                               file "}"))
               (("\\\\psfig\\{figure=([^,]*),.*height=([#0-9.]*in).*\\}"
                 all file height)
                (string-append "\\includegraphics[height=" height "]{"
                               file "}"))
               (("\\\\psfig\\{figure=([^,]*)\\}" all file)
                (string-append "\\includegraphics{" file "}")))
             (substitute* '("doc/mtt.tex" "doc/tcad.tex" "doc/ug.tex")
               (("^\\\\documentstyle\\[(.*)\\]\\{(.*)\\}"
                 all options class)
                (string-append "\\documentclass[" options "]{"
                               class "}\n"
                               "\\usepackage{graphicx}\n"
                               "\\usepackage{robinspace}"))
               (("\\\\setlength\\{\\\\footheight\\}\\{.*\\}" all)
                (string-append "%" all))
               (("\\\\setstretch\\{.*\\}" all)
                (string-append "%" all)))
             #t))
         (delete 'configure)
         (add-before 'install 'clean-bin
           (lambda _
             (delete-file (string-append (getcwd) "/bin/README"))
             #t))
         (add-before 'install 'make-pdf
           (lambda _
             (setenv "HOME" "/tmp")     ; FIXME: for texlive font cache
             (with-directory-excursion "doc"
               (and
                (for-each (lambda (file)
                            (invoke "dvips" file "-o"))
                          (find-files "." "\\.dvi"))
                (for-each (lambda (file)
                            (invoke "ps2pdf" file))
                          '("mtt.ps" "ug.ps" "tcad.ps"))
                (invoke "make" "clean")))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (data (string-append out "/share"))
                    (bin (string-append out "/bin"))
                    (doc (string-append data "/doc/" ,name "-" ,version))
                    (examples (string-append doc "/examples")))
               (with-directory-excursion "bin"
                 (for-each (lambda (f)
                             (install-file f bin))
                           (find-files "." ".*")))
               (copy-recursively "doc" doc)
               (copy-recursively "examples" examples)
               #t))))))
    (home-page "https://www.rle.mit.edu/cpg/research_codes.htm")
    (synopsis "Multipole-accelerated capacitance extraction program")
    (description
     "Fastcap is a capacitance extraction program based on a
multipole-accelerated algorithm.")
    (license (license:non-copyleft #f "See fastcap.c."))))

(define-public fasthenry
  (package
    (name "fasthenry")
    (version "3.0-12Nov96")
    (source (origin
              (method url-fetch)
              (file-name (string-append name "-" version ".tar.gz"))
              (uri (string-append
                    "http://www.rle.mit.edu/cpg/codes/" name
                    "-" version ".tar.z"))
              (sha256
               (base32 "1a06xyyd40zhknrkz17xppl2zd5ig4w9g1grc8qrs0zqqcl5hpzi"))
              (patches (search-patches "fasthenry-spAllocate.patch"
                                       "fasthenry-spBuild.patch"
                                       "fasthenry-spUtils.patch"
                                       "fasthenry-spSolve.patch"
                                       "fasthenry-spFactor.patch"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags '("CC=gcc" "RM=rm" "SHELL=sh" "all")
       #:parallel-build? #f
       #:tests? #f ;; no tests-suite
       #:modules ((srfi srfi-1)
                  ,@%default-gnu-modules)
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'install
                  (lambda* (#:key outputs #:allow-other-keys)
                    (let* ((out (assoc-ref outputs "out"))
                           (data (string-append out "/share"))
                           (bin (string-append out "/bin"))
                           (doc (string-append data "/doc/" ,name "-" ,version))
                           (examples (string-append doc "/examples")))
                      (with-directory-excursion "bin"
                        (for-each (lambda (f)
                                    (install-file f bin))
                                  (find-files "." ".*")))
                      (copy-recursively "doc" doc)
                      (copy-recursively "examples" examples)
                      #t))))))
    (home-page "https://www.rle.mit.edu/cpg/research_codes.htm")
    (synopsis "Multipole-accelerated inductance analysis program")
    (description
     "Fasthenry is an inductance extraction program based on a
multipole-accelerated algorithm.")
    (license (license:non-copyleft #f "See induct.c."))))

(define-public fritzing
  (package
    (name "fritzing")
    (version "0.9.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fritzing/fritzing-app")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "083nz7vj7a334575smjry6257535h68gglh8a381xxa36dw96aqs"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              ;; Integrate parts library
              (copy-recursively
               (string-append #$(this-package-native-input "fritzing-parts")
                              "/share/library")
               "parts")
              ;; Use system libgit2 and boost.
              (substitute* "phoenix.pro"
                (("^LIBGIT_STATIC.*")
                 (string-append
                  "LIBGIT2INCLUDE=" #$(this-package-input "libgit2") "/include\n"
                  "LIBGIT2LIB=" #$(this-package-input "libgit2") "/lib\n"
                  "INCLUDEPATH += $$LIBGIT2INCLUDE\n"
                  "LIBS += -L$$LIBGIT2LIB -lgit2\n"))
                (("^.*pri/libgit2detect.pri.") ""))
              ;; Trick the internal mechanism to load the parts
              (substitute* "src/version/partschecker.cpp"
                ((".*git_libgit2_init.*")
                 "return \"083nz7vj7a334575smjry6257535h68gglh8a381xxa36dw96aqs\";"))
              ;; XXX: NixOS and Gento have a phase where they generate part
              ;; SQLite library, have proper investigation if it's required in
              ;; Guix as well.
              (invoke "qmake"
                      (string-append "QMAKE_LFLAGS_RPATH=-Wl,-rpath," #$output "/lib")
                      (string-append "PREFIX=" #$output)
                      "phoenix.pro"))))))
    (native-inputs
     (list fritzing-parts))
    (inputs
     (list boost
           libgit2
           qtbase-5
           qtserialport-5
           qtsvg-5
           zlib))
    (home-page "https://fritzing.org")
    (synopsis "Electronic circuit design")
    (description
     "The Fritzing application is @dfn{Electronic Design Automation} (EDA)
software with a low entry barrier, suited for the needs of makers and
hobbyists.  It offers a unique real-life \"breadboard\" view, and a parts
library with many commonly used high-level components.  Fritzing makes it very
easy to communicate about circuits, as well as to turn them into PCB layouts
ready for production.")
    ;; Documentation and parts are released under CC-BY-SA 3.0; source code is
    ;; released under GPLv3+.
    (license (list license:gpl3+ license:cc-by-sa3.0))))

(define-public fritzing-parts
  ;; XXX: Release of the parts stopped in 2016 and it looks like develop
  ;; branch has latest changes comparing to other branches.
  (let ((commit "d61d63de9294343b1b6e86f149e78e4b1d3a0009")
        (revision "0"))
    (package
      (name "fritzing-parts")
      (version (git-version "0.9.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/fritzing/fritzing-parts")
               (commit commit)))
         (file-name (git-file-name "fritzing-parts" version))
         (sha256
          (base32 "0g39ja1aqw5qx8alf61m6zcy6y78j9ky556x6x1cnd6g7kkzd861"))))
      (build-system copy-build-system)
      (arguments
       (list
        #:install-plan
        #~'(("." "share/library/"
             #:exclude-regexp (".github.*"
                               ".gitignore"
                               "CONTRIBUTING.md"
                               "LICENSE.txt"
                               "README.md")))
        #:modules '(((guix build gnu-build-system) #:prefix gnu:)
                    (guix build copy-build-system)
                    (guix build utils)
                    (ice-9 match))))
      (home-page "https://fritzing.org")
      (synopsis "Electronic components (parts library) for use in the Fritzing app")
      (description "This package contains all part definitions that are
required for Fritzing app.")
      (license license:cc-by-sa3.0))))

(define-public qelectrotech
  (package
    (name "qelectrotech")
    (version "0.9.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://git.tuxfamily.org/qet/qet.git/"
                           "snapshot/qet-" version ".tar.gz"))
       (sha256
        (base32 "1qkgagx2bk2jfzs3d91kki01y5bs5p85f4c8xjxn45hmw4rl512b"))))
    (build-system qt-build-system)
    (arguments
     ;; XXX: tests are built for the CMake build option but it seems to be
     ;; broken in 0.8.0.
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               ;; Patch hardcoded path before running qmake.
               (substitute* "qelectrotech.pro" (("\\/usr\\/local") out))
               (invoke "qmake")))))))
    (native-inputs
     (list pkg-config qttools-5))
    (inputs
     (list kcoreaddons-5 kwidgetsaddons-5 qtbase-5 qtsvg-5 sqlite))
    (home-page "https://qelectrotech.org/")
    (synopsis "CAD/CAE editor focusing on schematics drawing features")
    (description "QElectroTech, or QET in short, is a desktop application to
create diagrams and schematics.  The software is primarily intended to create
electrical documentation but it can also be used to draw any kinds of diagrams,
such as those made in pneumatics, hydraulics, process industries, electronics,
and others.")
    (license license:gpl2+)))

(define-public gerbv
  (package
    (name "gerbv")
    (version "2.10.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/gerbv/gerbv")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "06bcm5zw7whsnnmfld3gl2j907lxc68gnsbzr2pc4w6qc923rgmj"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags '("CFLAGS=-fcommon")))
    (native-inputs (list autoconf
                         automake
                         desktop-file-utils
                         gettext-minimal
                         `(,glib "bin")
                         libtool
                         pkg-config))
    (inputs (list cairo
                  ;; As of 2.10.0 gerbv is still GTK+2 only.  GTK 3/4 porting
                  ;; issue: https://github.com/gerbv/gerbv/issues/71.
                  gtk+-2))
    (home-page "https://gerbv.github.io/")
    (synopsis "Gerber file viewer")
    (description
     "Gerbv is a viewer for files in the Gerber format (RS-274X only), which
is commonly used to represent printed circuit board (PCB) layouts.  Gerbv lets
you load several files on top of each other, do measurements on the displayed
image, etc.  Besides viewing Gerbers, you may also view Excellon drill files
as well as pick-place files.")
    (license license:gpl2+)))

(define-public translate2geda
  ;; There has been no formal release yet.
  (let ((commit "4c19e7eefa338cea8f1ee999ea8b37f8d0698169")
        (revision "1"))
    (package
      (name "translate2geda")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/erichVK5/translate2geda")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1h062bbpw8nk0jamkya1k4lsgaia796jyviiz2gkdi6k1bxhwgpa"))))
      (build-system ant-build-system)
      (arguments
       `(#:tests? #f ; there are no tests
         #:jar-name "translate2geda.jar"
         #:source-dir "."
         #:main-class "translate2geda"
         #:phases
         (modify-phases %standard-phases
           (add-after 'install 'install-bin
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (bin (string-append out "/bin"))
                      (wrapper (string-append bin "/translate2geda")))
                 (mkdir-p bin)
                 (with-output-to-file wrapper
                   (lambda _
                     (format #t "#!/bin/sh~%exec ~a -jar ~a/share/java/translate2geda.jar"
                             (which "java") out)))
                 (chmod wrapper #o555))
               #t)))))
      (home-page "https://github.com/erichVK5/translate2geda")
      (synopsis "Utility for converting symbol and footprint formats to gEDA")
      (description
       "This package provides a utility for converting Kicad (@file{.mod},
@file{.lib}), Eagle (@file{.lbr}), gerber (@file{.gbr}, etc..),
BXL (@file{.bxl}), IBIS (@file{.ibs}), symdef, LT-Spice (@file{.asc}),
QUCS (@file{.sch}), and BSDL (@file{.bsd}) symbols and footprints and EggBot
fonts to gEDA.")
      (license license:gpl2+))))

(define-public libfive
  (let ((commit "b1ea998d8adb3884ab52798f7388f4354145f452")
        (revision "5"))
    (package
      (name "libfive")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/libfive/libfive")
                      (commit commit)))
                (sha256
                 (base32
                  "0j91qq9d7949d2zs5wxyqd0ly644nb5690s8xnr6pchjl9z6pqxv"))
                (file-name (git-file-name name version))))
      (build-system cmake-build-system)
      (arguments
       (list
        #:imported-modules `((guix build guile-build-system)
                             ,@%cmake-build-system-modules)
        #:modules '((guix build cmake-build-system)
                    ((guix build guile-build-system) #:prefix guile:)
                    (guix build utils))
        #:test-target "libfive-test"
        #:configure-flags #~(list
                             (string-append
                              "-DPYTHON_SITE_PACKAGES_DIR="
                              #$output "/lib/python"
                              #$(version-major+minor
                                 (package-version
                                  (this-package-input "python-wrapper")))
                              "/site-packages"))
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'remove-native-compilation
              (lambda _
                (substitute* "CMakeLists.txt" (("-march=native") ""))))
            (add-after 'unpack 'remove-environment-variable-override
              (lambda _
                (substitute* "studio/src/guile/interpreter.cpp"
                  (("qputenv\\(\"GUILE_LOAD_COMPILED_PATH\".*") ""))))
            (add-after 'unpack 'fix-library-location
              (lambda _
                (substitute* "libfive/bind/guile/libfive/lib.scm"
                  (("\\(get-environment-variable \"LIBFIVE_FRAMEWORK_DIR\"\\)" m)
                   (string-append m "\n\"" #$output "/lib/\""))
                  (("\\(get-environment-variable \"LIBFIVE_STDLIB_DIR\"\\)" m)
                   (string-append m "\n\"" #$output "/lib/\"")))
                (substitute* "libfive/bind/python/libfive/ffi.py"
                  (("os.environ.get\\('LIBFIVE_FRAMEWORK_DIR'\\)" m)
                   (string-append m " or \"" #$output "/lib/\"")))))
            (add-before 'build 'generate-bindings
              (lambda _
                ;; These files already exist but we regenerate them from source
                (with-directory-excursion "../source/libfive/stdlib"
                  (substitute* '("gen_scm.py" "gen_c.py" "gen_py.py")
                    (("datetime.now\\(\\)\\.strftime\\([^)]+)") "\"N/A\"")
                    (("os\\.getlogin\\(\\)") "\"guix\""))
                  (invoke "python" "gen_scm.py")
                  (invoke "python" "gen_c.py")
                  (invoke "python" "gen_py.py"))))
            (add-after 'unpack 'do-not-build-guile-bindings
              (lambda _
                (delete-file "libfive/bind/guile/CMakeLists.txt")
                (call-with-output-file
                    "libfive/bind/guile/CMakeLists.txt"
                  (lambda (port)
                    (display "add_custom_target(libfive-guile)\n" port)))))
            (add-after 'build 'guile-build
              (lambda args
                (apply (assoc-ref guile:%standard-phases 'build)
                       #:source-directory "../source/libfive/bind/guile"
                       args)))
            (add-after 'install 'wrap-studio
              (lambda _
                (let* ((effective-version (guile:target-guile-effective-version))
                       (scm (string-append #$output "/share/guile/site/"
                                           effective-version))
                       (go (string-append #$output "/lib/guile/"
                                          effective-version "/site-ccache"))
                       (py (string-append #$output "/lib/python"
                                          #$(version-major+minor
                                             (package-version
                                              (this-package-input "python-wrapper")))
                                          "/site-packages")))
                  (wrap-program (string-append #$output "/bin/Studio")
                    `("GUILE_LOAD_PATH" ":" prefix (,scm))
                    `("GUILE_LOAD_COMPILED_PATH" ":" prefix (,go))
                    `("GUIX_PYTHONPATH" ":" prefix (,py)))))))))
      (native-inputs
       (list pkg-config))
      (inputs
       (list bash-minimal boost eigen guile-3.0 libpng python-wrapper qtbase))
      (home-page "https://libfive.com")
      (synopsis "Tool for programmatic computer-aided design")
      (description
       "Libfive is a tool for programmatic computer-aided design (CAD).  In
libfive, solid models are defined as Scheme or Python scripts, and there are
no opaque function calls into the geometry kernel: everything is visible to
the user.  Even fundamental, primitive shapes are represented as code in the
user-level language.")
      (license (list license:mpl2.0               ;library
                     license:gpl2+))              ;Guile bindings and GUI

      ;; Mark as tunable to take advantage of SIMD code in Eigen.
      (properties '((tunable? . #t))))))

(define-public inspekt3d
  (let ((commit "703f52ccbfedad2bf5240bf8183d1b573c9d54ef")
        (revision "0"))
    (package
      (name "inspekt3d")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://gitlab.com/kavalogic-inc/inspekt3d.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0lan6930g5a9z4ack9jj0zdd0mb2s6q2xzpiwcjdc3pvl9b1nbw4"))
                (modules '((guix build utils)))
                ;; Allow builds with Guile 3.0.
                (snippet
                 '(substitute* "configure.ac"
                    (("2\\.2") "3.0 2.2")))))
      (build-system gnu-build-system)
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'patch-libfive-guile-location
              (lambda _
                (substitute* "inspekt3d/library.scm"
                  (("\\(load-extension \"libfive-guile\" \"scm_init_libfive_modules\"\\)") "#t")
                  (("\"libfive-guile")
                   (string-append "\""
                                  #$(this-package-input "libfive")
                                  "/lib/libfive-stdlib"))))))))
      (native-inputs
       (list autoconf automake pkg-config))
      (inputs
       (list mesa guile-3.0))
      (propagated-inputs
       `(("libfive" ,libfive)
         ("guile-opengl" ,guile3.0-opengl)))
      (home-page "https://gitlab.com/kavalogic-inc/inspekt3d/")
      (synopsis "Lightweight 3D viewer for Libfive written in Guile Scheme")
      (description
       "Inspekt3d is a lightweight 3D viewer for Libfive written in Guile Scheme.
The viewer can be used interactively with a REPL (for example Geiser in
Emacs).")
      (license license:gpl3+))))

(define-public kicad
  (package
    (name "kicad")
    (version "7.0.11")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/kicad/code/kicad.git")
                    (commit version)))
              (sha256
               (base32
                "1qn7w6pb1n5gx73z1zqbv140chh4307y8764z7xkdvric9i48qj4"))
              (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     `(#:out-of-source? #t
       #:tests? #f ;no tests
       #:build-type "Release"
       #:configure-flags
       ,#~(list "-DKICAD_SCRIPTING_PYTHON3=ON"
                (string-append "-DOCC_INCLUDE_DIR="
                               #$(this-package-input "opencascade-occt")
                               "/include/opencascade")
                "-DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON"
                "-DKICAD_USE_EGL=ON"    ;because wxWidgets uses EGL
                "-DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-ngspice-detection
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "eeschema/CMakeLists.txt"
               (("NGSPICE_DLL_FILE=\"\\$\\{NGSPICE_DLL_FILE\\}\"")
                (string-append "NGSPICE_DLL_FILE=\""
                               (assoc-ref inputs "libngspice")
                               "/lib/libngspice.so\"")))))
         (add-after 'install 'wrap-program
           ;; Ensure correct Python at runtime.
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (python (assoc-ref inputs "python"))
                    (file (string-append out "/bin/kicad"))
                    (path (string-append out "/lib/python"
                                         ,(version-major+minor (package-version
                                                                python))
                                         "/site-packages:"
                                         (getenv "GUIX_PYTHONPATH"))))
               (wrap-program file
                 `("GUIX_PYTHONPATH" ":" prefix
                   (,path))
                 `("PATH" ":" prefix
                   (,(string-append python "/bin:"))))))))))
    (native-search-paths
     (list (search-path-specification
            (variable "KICAD") ;to find kicad-doc
            (files '("")))
           (search-path-specification
            (variable "KICAD7_TEMPLATE_DIR")
            (files '("share/kicad/template")))
           (search-path-specification
            (variable "KICAD7_SYMBOL_DIR")
            (files '("share/kicad/symbols")))
           (search-path-specification
            (variable "KICAD7_FOOTPRINT_DIR")
            (files '("share/kicad/footprints")))
           (search-path-specification
            (variable "KICAD7_3DMODEL_DIR")
            (files '("share/kicad/3dmodels")))))
    (native-inputs (list boost
                         desktop-file-utils
                         gettext-minimal
                         pkg-config
                         swig
                         unixodbc
                         zlib))
    (inputs (list bash-minimal
                  cairo
                  curl
                  glew
                  glm
                  hicolor-icon-theme
                  libngspice
                  libsm
                  mesa
                  opencascade-occt
                  openssl
                  python-wrapper
                  gtk+
                  wxwidgets
                  python-wxpython
                  gdk-pixbuf))
    (home-page "https://www.kicad.org/")
    (synopsis "Electronics Design Automation Suite")
    (description
     "Kicad is a program for the formation of printed circuit
boards and electrical circuits.  The software has a number of programs that
perform specific functions, for example, pcbnew (Editing PCB), eeschema (editing
electrical diagrams), gerbview (viewing Gerber files) and others.")
    (license license:gpl3+)))

(define-public kicad-doc
  (package
    (name "kicad-doc")
    (version (package-version kicad))
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/kicad/services/kicad-doc.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "10iwp35xywdz15a83vialzfd46rjw6mlz174dxawm2rw4ws2n7j4"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags (list "-DBUILD_FORMATS=html")
       #:tests? #f ;no test suite
       #:phases
       (modify-phases %standard-phases
         (delete 'build))))
    (native-inputs (list asciidoc
                         gettext-minimal
                         git-minimal
                         perl
                         perl-unicode-linebreak
                         perl-yaml-tiny
                         po4a
                         ruby-asciidoctor
                         source-highlight))
    (home-page "https://kicad.org")
    (synopsis "KiCad official documentation")
    (description "This repository contains the official KiCad documentation.")
    (license license:gpl3+)))

(define-public kicad-symbols
  (package
    (name "kicad-symbols")
    (version (package-version kicad))
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/kicad/libraries/kicad-symbols.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "057zmhf4h3p3p4y6jqxch9cj1wqf129k6kmvx2gshb9lgda0kjr8"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f))                    ; no tests exist
    (home-page (package-home-page kicad))
    (synopsis "Official KiCad schematic symbol libraries")
    (description "This package contains the official KiCad schematic symbol
libraries.")
    ;; TODO: Exception: "To the extent that the creation of electronic designs
    ;; that use 'Licensed Material' can be considered to be 'Adapted Material',
    ;; then the copyright holder waives article 3 of the license with respect to
    ;; these designs and any generated files which use data provided as part of
    ;; the 'Licensed Material'."
    ;; See <https://github.com/KiCad/kicad-symbols/blob/master/LICENSE.md>.
    (license license:cc-by-sa4.0)))

(define-public kicad-footprints
  (package
    (inherit kicad-symbols)
    (name "kicad-footprints")
    (version (package-version kicad))
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/kicad/libraries/kicad-footprints.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1r9v8v41n0yrgwsqaksskmdgb9vyw1sb92xh81bwrv2ag3p5vdg7"))))
    (synopsis "Official KiCad footprint libraries")
    (description "This package contains the official KiCad footprint libraries.")))

(define-public kicad-packages3d
  (package
    (inherit kicad-symbols)
    (name "kicad-packages3d")
    (version (package-version kicad))
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/kicad/libraries/kicad-packages3D.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0lcy1av7ixg1f7arflk50jllpc1749sfvf3h62hkxsz97wkr97xj"))))
    (synopsis "Official KiCad 3D model libraries")
    (description "This package contains the official KiCad 3D model libraries.")))

(define-public kicad-templates
  (package
    (inherit kicad-symbols)
    (name "kicad-templates")
    (version (package-version kicad))
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/kicad/libraries/kicad-templates.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0mykfwwik7472i4r0isc5szj3dnmvd0538p0vlmzh4rcgj3pj3vm"))))
    (synopsis "Official KiCad project and worksheet templates")
    (description "This package contains the official KiCad project and
worksheet templates.")))

(define-public librseq
  ;; There's no release.
  (let ((commit "170f840b498e1aff068b90188727a656111bfc2f")
        (revision "1"))
    (package
      (name "librseq")
      (version (git-version "0.0.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/compudj/librseq.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0rdx59y8y9x8cfmmx5gl66gibkzpk3kw5lrrqhrxan8zr37a055y"))))
      (build-system gnu-build-system)
      (native-inputs (list autoconf automake libtool))
      (home-page "https://github.com/compudj/librseq")
      (synopsis "Userspace library for restartable sequences")
      (description "A restartable sequence is a critical region delimited by a
program where if its execution is preempted or interrupted, the kernel will
divert the program control flow to a defined abort handler.  They are a good
alternative to atomic operations for critical fast paths and are usually used
in the context of per-cpu data.  The library offers ABI headers to interface
with the kernel and various utilities such as per-cpu counters.")
      (license (list license:lgpl2.1 license:expat)))))

(define-public linsmith
  (package
    (name "linsmith")
    (version "0.99.33")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://sourceforge/linsmith/linsmith/linsmith-"
                    version "/linsmith-" version ".tar.gz"))
              (sha256
               (base32
                "1629p29casy9pgy8hzva1bmgrvh923qk01ls3anik6zqn6swkjfn"))))
    (build-system gnu-build-system)
    (arguments
     '(#:configure-flags '("CFLAGS=-fcommon")))
    (native-inputs
     (list pkg-config))
    (inputs
     (list gtk+-2 libgnomeui))
    (home-page "https://jcoppens.com/soft/linsmith/index.en.php")
    (synopsis "Smith Charting program")
    (description "LinSmith is a Smith Charting program, mainly designed for
educational use.  As such, there is an emphasis on capabilities that improve
the 'showing the effect of'-style of operation.")
    (license license:gpl2+)))

(define-public valeronoi
  (package
    (name "valeronoi")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ccoors/Valeronoi")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qkhrqkjsmm0h1bxf2ihkqfhdr18xx5x1i2ds1mla13zm0bw2570"))
       (snippet #~(begin
                    (use-modules (guix build utils))
                    (delete-file-recursively "3rdparty")
                    (substitute* '("tests/test_colormap.cpp"
                                   "tests/test_main.cpp")
                      (("catch\\.hpp")
                       "catch2/catch.hpp"))))))
    (build-system cmake-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (replace 'check
                    (lambda* (#:key tests? #:allow-other-keys)
                      (when tests?
                        (invoke "./valeronoi-tests")))))))
    (inputs (list boost
                  cgal
                  gmp
                  libxkbcommon
                  mpfr
                  openssl
                  qtbase
                  qtsvg))
    (native-inputs (list catch2))
    (home-page "https://github.com/ccoors/Valeronoi")
    (synopsis "WiFi mapping companion application for Valetudo")
    (description
     "Valeronoi (Valetudo + Voronoi) is a companion for Valetudo for generating
WiFi signal strength maps.  It visualizes them using a Voronoi diagram.")
    (license license:gpl3+)))

(define-public volk
  (package
    (name "volk")
    (version "3.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gnuradio/volk")
             (commit (string-append "v" version))
             (recursive? #t)))          ; for cpu_features git submodule
       (file-name (git-file-name name version))
       (sha256
        (base32 "0a59lnjh6hx2bmyn04f8r0ymwss1ss1iih2jwrl9jblkxsw0i3lh"))))
    (build-system cmake-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-check-lgpl-test
           ;; Disable the failing check-lgpl test that is supposed to be run
           ;; only by upstream developers to check the authors and licenses
           ;; of contributions in the git history.
           (lambda _
             (substitute* "scripts/licensing/count_contrib.sh"
               (("#!/bin/bash" all)
                (string-append all "\nexit 0")))))
         (add-after 'install 'remove-static-libraries
           ;; Remove libcpu_features.a (and any others that might appear).
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (lib (string-append out "/lib")))
               (for-each delete-file (find-files lib "\\.a$"
                                                 #:fail-on-error? #t)))))
         (add-after 'install 'wrap-pythonpath
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (python (assoc-ref inputs "python"))
                    (file (string-append out "/bin/volk_modtool"))
                    (path (string-append
                           out
                           "/lib/python"
                           ,(version-major+minor
                             (package-version python))
                           "/site-packages:"
                           (getenv "GUIX_PYTHONPATH"))))
               (wrap-program file
                 `("GUIX_PYTHONPATH" ":" prefix (,path))
                 `("PATH" ":" prefix
                   (,(string-append python "/bin:"))))))))))
    (inputs
     (list bash-minimal                 ;for wrap-program
           boost
           python-wrapper
           python-mako))
    (home-page "https://www.libvolk.org/")
    (synopsis "Vector-Optimized Library of Kernels")
    (description
     "@acronym{VOLK, Vector-Optimized Library of Kernels} contains procedures
with machine-specific optimizations for mathematical functions.  It also
provides a machine-independent interface to select the best such procedures to
use on a given system.")
    (license (list license:asl2.0 ; cpu_features
                   license:lgpl3+))))

(define-public libredwg
  (package
    (name "libredwg")
    (version "0.12.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnu/libredwg/libredwg-"
                           version ".tar.xz"))
       (sha256
        (base32 "1gginbl76vmpccjwx93cmg8ibap8l40swly3bjv7rhmdwv6ikpnk"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags '("--disable-bindings")))
    (native-inputs
     (list libxml2
           parallel
           perl
           pkg-config
           python-wrapper
           python-libxml2))
    (inputs
     (list pcre2))
    (home-page "https://www.gnu.org/software/libredwg/")
    (synopsis "C library to handle DWG (CAD-related) files")
    (description
     "GNU LibreDWG is a C library to handle DWG files.  It aims to be a free
replacement for the OpenDWG libraries.")
    (license license:gpl3+)))

(define-public minicom
  (package
    (name "minicom")
    (version "2.9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://salsa.debian.org/minicom-team/minicom.git")
             (commit (string-append "v" version))))
       (sha256
        (base32 "18k0hiljsiq80x93c3qrd1cmcjjvsk1ymin03vncjp1v35xn8248"))
       (file-name (git-file-name name version))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "--enable-lock-dir=/var/lock")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'make-git-checkout-writable
            (lambda _
              (for-each make-file-writable (find-files "."))))
          (replace 'bootstrap
            ;; autogen.sh needlessly hard-codes aclocal-1.14.
            (lambda _
              (invoke "autoreconf" "-vif")))
          (add-before 'configure 'patch-lock-check
            (lambda _
              (substitute* "configure"
                (("test -d [$]UUCPLOCK") "true")))))))
    (native-inputs
     (list autoconf-2.71 automake gettext-minimal pkg-config))
    (inputs
     (list ncurses))
    (home-page "https://salsa.debian.org/minicom-team/minicom")
    (synopsis "Serial terminal emulator")
    (description "@code{minicom} is a serial terminal emulator.")
    (license license:gpl2+)))

(define-public sterm
  (package
    (name "sterm")
    (version "20200306")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/wentasah/sterm")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "031pd8yz2bfzqbari6za1c3xcqmw94ap4vbrjzb3v6izjcrca58c"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; no tests
       #:make-flags
       (list (string-append "CC=" ,(cc-for-target))
             (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases (delete 'configure))))
    (synopsis "Simple serial terminal")
    (description "This is a minimalist terminal program like minicom or cu.
The only thing it does is creating a bidirectional connection between
stdin/stdout and a terminal device (e.g. serial line).
It can also set serial line baudrate, manipulate DTR/RTS modem lines,
send break and throttle transmission speed.")
    (home-page "https://github.com/wentasah/sterm")
    (license license:gpl3+)))

(define-public libmodbus
  (package
    (name "libmodbus")
    (version "3.1.10")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/stephane/libmodbus")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0nbpk1n56kclab8fl32dxi46v2bwax3gfk1zkc796srm7vj42sbv"))))
    (build-system gnu-build-system)
    (native-inputs (list autoconf automake libtool))
    (synopsis "Library for the Modbus protocol")
    (description "@code{libmodbus} is a library to send/receive data with a
device which respects the Modbus protocol.  This library can use a serial port
or an Ethernet connection.")
    (home-page "https://libmodbus.org/")
    (license license:lgpl2.1+)))
(define-public harminv
  (package
    (name "harminv")
    (version "1.4.1")
    (source (origin
              (method url-fetch)
              (uri
               (string-append "https://github.com/stevengj/harminv/"
                              "releases/download/v" version "/"
                              name "-" version ".tar.gz"))
              (sha256
               (base32
                "0w1n4d249vlpda0hi6z1v13qp21vlbp3ykn0m8qg4rd5132j7fg1"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags '("--enable-shared")
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'fix-tests
           (lambda _
             (substitute* "./sines-test.sh"
               ; change test frequency range - default fails
               (("0\\.15") "0.16"))
             #t)))))
    (native-inputs
     `(("fortran" ,gfortran)))
    (inputs
     (list openblas))
    (home-page "https://github.com/stevengj/harminv")
    (synopsis "Harmonic inversion solver")
    (description
     "Harminv is a free program (and accompanying library) to solve the problem of
harmonic inversion — given a discrete-time, finite-length signal that consists of a sum
of finitely-many sinusoids (possibly exponentially decaying) in a given bandwidth, it
determines the frequencies, decay constants, amplitudes, and phases of those sinusoids.")
    (license license:gpl2+)))

(define-public guile-libctl
  (package
    (name "guile-libctl")
    (version "4.2.0")
    (source (origin
              (method url-fetch)
              (uri
               (string-append
                "https://github.com/NanoComp/libctl/releases/download/v"
                version "/libctl-" version ".tar.gz"))
              (sha256
               (base32
                "0x8r56lpfq83kfbq28vr25icl19xpfd6fjrxzcpdmv30l9pash83"))))
    (build-system gnu-build-system)
    (arguments
      `(#:configure-flags '("--enable-shared")))
    (native-inputs
     `(("fortran" ,gfortran)))
    (inputs
     (list guile-2.2))
    (home-page "http://ab-initio.mit.edu/wiki/index.php/Libctl")
    (synopsis "Flexible control files implementation for scientific simulations")
    (description
     "Libctl is a Guile-based library implementing flexible control files
for scientific simulations.")
    (license license:gpl2+)))

(define-public mpb
  (package
    (name "mpb")
    (version "1.8.0")
    (source (origin
              (method url-fetch)
              (uri
               (string-append
                "https://github.com/NanoComp/mpb/releases/download/v"
                version "/mpb-" version ".tar.gz"))
              (sha256
               (base32
                "1jgrb7dd6qs6j6y1gnxmdgrh79l2bvqa6nk60a4pw1annsks4brd"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       (list (string-append "--with-libctl="
                            (assoc-ref %build-inputs "libctl")
                            "/share/libctl")
             "--enable-shared")))
    (native-inputs
     `(("fortran" ,gfortran)
       ("pkg-config" ,pkg-config)
       ("swig" ,swig)))
    (inputs
     `(("fftw" ,fftw)
       ("gsl" ,gsl)
       ("guile" ,guile-2.2)
       ("hdf5" ,hdf5)
       ("openblas" ,openblas)
       ("libctl" ,guile-libctl)
       ("readline" ,readline)
       ("zlib" ,zlib)))
    (home-page "http://ab-initio.mit.edu/wiki/index.php/MIT_Photonic_Bands")
    (synopsis "Computes band structures and electromagnetic modes of dielectric
structures")
    (description
     "MIT Photonic-Bands (MPB) computes definite-frequency eigenstates (harmonic modes)
of Maxwell's equations in periodic dielectric structures for arbitrary wavevectors, using
fully-vectorial and three-dimensional methods.")
    (license license:gpl2+)))

(define-public meep
  (package
    (name "meep")
    (version "1.29.0")
    (source (origin
              (method url-fetch)
              (uri
               (string-append
                "https://github.com/NanoComp/meep/releases/download/v"
                version "/meep-" version ".tar.gz"))
              (sha256
               (base32
                "1511849g6wlpa42kfrj6zvmc3ivad9ync8r01xp2ld7r5j39y9v8"))))
    (build-system gnu-build-system)
    (arguments
     (list #:configure-flags
           #~(list (string-append "--with-libctl="
                                  #$(this-package-input "guile-libctl")
                                  "/share/libctl"))))
    (native-inputs
     (list gfortran
           pkg-config
           swig))
    (inputs
     (list fftw
           gsl
           guile-2.2
           guile-libctl
           harminv
           hdf5
           mpb
           openblas
           zlib))
    (home-page "http://ab-initio.mit.edu/wiki/index.php/Meep")
    (synopsis "Finite-difference time-domain (FDTD) simulation software")
    (description
     "Meep is a finite-difference time-domain (FDTD) simulation software package
developed at MIT to model electromagnetic systems.")
    (license license:gpl2+)))

(define-public adms
  (package
    (name "adms")
    (version "2.3.7")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Qucs/ADMS")
                    (commit (string-append "release-" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0i37c9k6q1iglmzp9736rrgsnx7sw8xn3djqbbjw29zsyl3pf62c"))))
    (build-system gnu-build-system)
    (native-inputs
     (list autoconf
           automake
           bison
           flex
           libtool
           perl
           perl-xml-libxml))
    (home-page "https://github.com/Qucs/ADMS")
    (synopsis "Automatic device model synthesizer")
    (description
     "ADMS is a code generator that converts electrical compact device models
specified in high-level description language into ready-to-compile C code for
the API of spice simulators.  Based on transformations specified in XML
language, ADMS transforms Verilog-AMS code into other target languages.")
    (license license:gpl3)))

(define-public audmes
  (package
    (name "audmes")
    (version "20220420")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/audmes/audmes%20sources/"
                           "audmes-source-" version ".zip"))
       (sha256
        (base32 "0yxjq2p1ca2wy2idwrlxr3b4vbp0d9268jll90y7l55fbid8vkp2"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #false                   ;there are none
      #:phases
      '(modify-phases %standard-phases
         (add-after 'unpack 'prepare-csv.h
           (lambda* (#:key inputs #:allow-other-keys)
             (mkdir "libfccp")
             (install-file (search-input-file inputs "csv.h") "libfccp"))))))
    (inputs
     (list alsa-lib pulseaudio wxwidgets))
    (native-inputs
     (list unzip
           (let ((commit "4ade42d5f8c454c6c57b3dce9c51c6dd02182a66"))
             (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/ben-strasser/fast-cpp-csv-parser")
                     (commit commit)))
               (file-name (git-file-name "csv.h" (git-version "0" "0" commit)))
               (sha256
                (base32
                 "1y7ads97gkrjg1jc532n8gmjry0qhqxginw1gq7b4lk9s0pyl540"))))))
    (home-page "https://sourceforge.net/projects/audmes/")
    (synopsis "Oscilloscope and spectrum analyzer using sound card")
    (description
     "The audio measurement system is a system for audio measurement through
sound card.  It contains: generator, oscilloscope, audio spectrum
analyzer (FFT) and frequency sweep plot.")
    (license license:gpl2+)))

(define-public capstone
  (package
    (name "capstone")
    (version "5.0.1")
    (source (origin
              (method git-fetch)
              (patches (search-patches "capstone-fix-python-constants.patch"))
              (uri (git-reference
                    (url "https://github.com/capstone-engine/capstone")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1j4a6w8p3z5qrkzf0h5aklrnlpvscv6nlq7d3abbpxlyqvk8pach"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:make-flags (list (string-append "PREFIX=" (assoc-ref %outputs "out"))
                          (string-append "CC=" ,(cc-for-target)))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)            ; no configure script
         ;; cstool's Makefile ‘+=’s LDFLAGS, so we cannot pass it as a make flag.
         (add-before 'build 'fix-cstool-ldflags
           (lambda* (#:key outputs #:allow-other-keys)
             (setenv "LDFLAGS"
                     (string-append "-Wl,-rpath="
                                    (assoc-ref outputs "out") "/lib")))))))
    (home-page "https://github.com/capstone-engine/capstone")
    (synopsis "Lightweight multi-platform, multi-architecture disassembly framework")
    (description
     "Capstone is a lightweight multi-platform, multi-architecture disassembly
framework.  Capstone can disassemble machine code for many supported architectures
such as x86, x86_64, arm, arm64, mips, ppc, sparc, sysz and xcore.  It provides
bindings for Python, Java, OCaml and more.")
    (license license:bsd-3)))

;; FIXME: This package has a timestamp embedded in
;; lib/python3.5/site-packages/capstone/__pycache__/__iti__.cpython-35.pyc
(define-public python-capstone
  (package
    (inherit capstone)
    (name "python-capstone")
    (propagated-inputs
     (list capstone))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'chdir-and-fix-setup-py
           (lambda* (#:key inputs #:allow-other-keys)
             (chdir "bindings/python")
             ;; Do not build the library again, because we already have it.
             (substitute* "setup.py" ((".*   build_libraries.*") ""))
             ;; This substitution tells python-capstone where to find the
             ;; library.
             (substitute* "capstone/__init__.py"
               (("pkg_resources.resource_filename.*")
                (string-append "'" (dirname (search-input-file
                                             inputs "lib/libcapstone.so"))
                               "',\n")))))
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (when tests?
               (invoke "make" "check")))))))))


(define-public python-esptool-3.0
  (package
    (name "python-esptool")
    (version "3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "esptool" version))
       (sha256
        (base32
         "0d69rd9h8wrzjvfrc66vmz4qd5hly2fpdcwj2bdrlb7dbwikv5c7"))))
    (build-system python-build-system)
    (propagated-inputs
     (list python-ecdsa python-pyaes python-pyserial python-reedsolo
           python-cryptography python-bitstring))
    (home-page "https://github.com/espressif/esptool")
    (synopsis "Bootloader utility for Espressif ESP8266 & ESP32 chips")
    (description
     "@code{esptool.py} is a Python-based utility to communicate with the ROM
bootloader in Espressif ESP8266 & ESP32 series chips.")
    (license license:gpl2+)))

(define-public radare2
  (package
    (name "radare2")
    (version "5.1.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/radareorg/radare2")
                    (commit version)))
              (sha256
               (base32
                "0hv9x31iabasj12g8f04incr1rbcdkxi3xnqn3ggp8gl4h6pf2f3"))
              (file-name (git-file-name name version))))
    (build-system gnu-build-system)
    (arguments
     '(#:tests? #f                      ; tests require git and network access
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'mklibdir
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (mkdir-p (string-append (assoc-ref outputs "out") "/lib"))
             #t)))
       #:configure-flags
       (list "--with-openssl"
             "--with-rpath"
             "--with-syscapstone"
             "--with-sysmagic"
             "--with-syszip"
             "--with-sysxxhash")
       #:make-flags
       (list "CC=gcc")))
    ;; TODO: Add gmp and libzip and make the build system actually find them.
    (inputs
     (list capstone libuv openssl zip))
    (native-inputs
     (list pkg-config))
    (propagated-inputs
     ;; In the Libs: section of r_hash.pc.
     (list xxhash))
    (home-page "https://radare.org/")
    (synopsis "Reverse engineering framework")
    (description
     "Radare2 is a complete framework for reverse-engineering, debugging, and
analyzing binaries.  It is composed of a set of small utilities that can be
used together or independently from the command line.

Radare2 is built around a scriptable disassembler and hexadecimal editor that
support a variety of executable formats for different processors and operating
systems, through multiple back ends for local and remote files and disk
images.

It can also compare (@dfn{diff}) binaries with graphs and extract information
like relocation symbols.  It is able to deal with malformed binaries, making
it suitable for security research and analysis.")
    (license license:lgpl3)))

(define-public asco
  (package
    (name "asco")
    (version "0.4.11")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/asco/asco/" version "/ASCO-"
                           version ".tar.gz"))
       (sha256
        (base32 "0ggxv0p1zmfbvd1k17p2j1cskbjsa83fansz8ihxn7ax9qdicljv"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                                ; no tests
       #:make-flags '("all" "asco-mpi")
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-before 'build 'fix-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((coreutils (assoc-ref inputs "coreutils-minimal")))
               (substitute* '("errfunc.c" "asco.c")
                 (("(cp|nice) " _ command)
                  (string-append
                   (search-input-file inputs (string-append "bin/" command))
                   " ")))
               (substitute* "Makefile"
                 (("<FULL_PATH_TO_MPICH>/bin/mpicc") (which "mpicc"))))))
         (replace 'install                        ; no install target
           (lambda* (#:key outputs #:allow-other-keys)
             (for-each (lambda (file)
                         (install-file file (string-append
                                             (assoc-ref outputs "out")
                                             "/bin")))
                       '("asco" "asco-mpi" "asco-test"
                         "tools/alter/alter" "tools/log/log")))))))
    (native-inputs
     `(("mpi" ,openmpi)))
    (inputs
     (list coreutils-minimal))
    (home-page "https://asco.sourceforge.net/")
    (synopsis "SPICE circuit optimizer")
    (description
     "ASCO brings circuit optimization capabilities to existing SPICE simulators using a
high-performance parallel differential evolution (DE) optimization algorithm.")
    (license license:gpl2+)))

(define-public libngspice
  ;; Note: The ngspice's build system does not allow us to build both the
  ;; library and the executables in one go.  Thus, we have two packages.
  ;; See <https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27344#236>.
  (package
    (name "libngspice")
    (version "43")
    (source
     (origin
       (method url-fetch)
       (uri (list (string-append
                   "mirror://sourceforge/ngspice/ng-spice-rework/" version
                   "/ngspice-" version ".tar.gz")
                  (string-append
                   "mirror://sourceforge/ngspice/ng-spice-rework/"
                   "old-releases/" version "/ngspice-" version ".tar.gz")))
       (sha256
        (base32 "169nn6bw5628m2k8cy77yd1vs22plj83grisq58j07sk11pnmp8l"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f ;there are no tests for libngspice
      #:phases #~(modify-phases %standard-phases
                   (add-after 'install 'delete-scripts
                     (lambda _
                       (delete-file-recursively
                        (string-append #$output
                                       "/share/ngspice/scripts")))))
      #:configure-flags #~(list "--enable-openmp" "--enable-ciderlib"
                                "--enable-xspice" "--with-ngshared")))
    (native-inputs (list bison flex))
    (inputs (list libxaw openmpi))
    (home-page "https://ngspice.sourceforge.net/")
    (synopsis "Mixed-level/mixed-signal circuit simulator")
    (description
     "Ngspice is a mixed-level/mixed-signal circuit simulator.  It includes
@code{Spice3f5}, a circuit simulator, and @code{Xspice}, an extension that
provides code modeling support and simulation of digital components through
an embedded event driven algorithm.")
    (license (list license:lgpl2.0+ ;code in frontend/numparam
                   (license:non-copyleft "file:///COPYING") ;spice3 bsd-style
                   license:bsd-3 ;ciderlib
                   license:public-domain)))) ;xspice

(define-public ngspice
  ;; The ngspice executables (see libngpsice above.)
  (package
    (inherit libngspice)
    (name "ngspice")
    (arguments
     (substitute-keyword-arguments (package-arguments libngspice)
       ((#:tests? _ #f) #t)
       ((#:configure-flags flags)
        #~(cons "--with-readline=yes"
                (delete "--with-ngshared"
                        #$flags)))
       ((#:phases phases)
        #~(modify-phases #$phases
            (delete 'delete-scripts)))))
    (native-inputs (list perl))
    (inputs (list libngspice readline))))

(define trilinos-serial-xyce
  ;; Note: This is a Trilinos containing only the packages Xyce needs, so we
  ;; keep it private.  See
  ;; <https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27344#248>.
  ;; TODO: Remove when we have modular Trilinos packages?
  (package
    (name "trilinos-serial-xyce")
    (version "12.12.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/trilinos/Trilinos")
             (commit (string-append "trilinos-release-"
                                    (string-map (lambda (chr)
                                                  (case chr
                                                    ((#\.) #\-)
                                                    (else chr)))
                                                version)))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1smz3wlpfyjn0czmpl8bj4hw33p1zi9nnfygpsx7jl1523nypa1n"))))
    (build-system cmake-build-system)
    (arguments
     `(#:out-of-source? #t
       #:phases
       (modify-phases %standard-phases
         ;; Delete unneeded tribits(build system) directory which makes validate-runpath
         ;; phase to fail.
         (add-before 'validate-runpath 'delete-tribits
           (lambda* (#:key outputs #:allow-other-keys)
             (delete-file-recursively
              (string-append (assoc-ref outputs "out")
                             "/lib/cmake/tribits")))))
       #:configure-flags
       (list "-DCMAKE_CXX_FLAGS=-O3 -fPIC"
             "-DCMAKE_C_FLAGS=-O3 -fPIC"
             "-DCMAKE_Fortran_FLAGS=-O3 -fPIC"
             "-DTrilinos_ENABLE_NOX=ON"
             "-DNOX_ENABLE_LOCA=ON"
             "-DTrilinos_ENABLE_EpetraExt=ON"
             "-DEpetraExt_BUILD_BTF=ON"
             "-DEpetraExt_BUILD_EXPERIMENTAL=ON"
             "-DEpetraExt_BUILD_GRAPH_REORDERINGS=ON"
             "-DTrilinos_ENABLE_TrilinosCouplings=ON"
             "-DTrilinos_ENABLE_Ifpack=ON"
             "-DTrilinos_ENABLE_Isorropia=ON"
             "-DTrilinos_ENABLE_AztecOO=ON"
             "-DTrilinos_ENABLE_Belos=ON"
             "-DTrilinos_ENABLE_Teuchos=ON"
             "-DTeuchos_ENABLE_COMPLEX=ON"
             "-DTrilinos_ENABLE_Amesos=ON"
             "-DAmesos_ENABLE_KLU=ON"
             "-DAmesos_ENABLE_UMFPACK=ON"
             "-DTrilinos_ENABLE_Sacado=ON"
             "-DTrilinos_ENABLE_Kokkos=OFF"
             "-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF"
             "-DTPL_ENABLE_AMD=ON"
             "-DTPL_ENABLE_UMFPACK=ON"
             "-DTPL_ENABLE_BLAS=ON"
             "-DTPL_ENABLE_LAPACK=ON")))
    (native-inputs (list gfortran swig))
    (inputs (list boost lapack suitesparse))
    (home-page "https://trilinos.org")
    (synopsis "Engineering and scientific problems algorithms")
    (description
     "The Trilinos Project is an effort to develop algorithms and enabling
technologies within an object-oriented software framework for the solution of
large-scale, complex multi-physics engineering and scientific problems.  A
unique design feature of Trilinos is its focus on packages.")
    (license (list license:lgpl2.1+
                   license:bsd-3))))

(define-public xyce-serial
  (package
    (name "xyce-serial")
    (version "6.8")
    (source
     (origin (method url-fetch)
             (uri (string-append "https://archive.org/download/Xyce-"
                                 version "/Xyce-" version ".tar.gz"))
             (sha256
              (base32
               "09flp1xywbb2laayd9rg8vd0fjsh115y6k1p71jacy0nrbdvvlcg"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:configure-flags
       (list
        "CXXFLAGS=-O3"
        (string-append "ARCHDIR="
                       (assoc-ref %build-inputs "trilinos")))))
    (native-inputs
     `(("bison" ,bison-3.0)                  ;'configure' fails with Bison 3.4
       ("flex" ,flex)
       ("fortran" ,gfortran)))
    (inputs
     `(("fftw" ,fftw)
       ("suitesparse" ,suitesparse)
       ("lapack" ,lapack)
       ("trilinos" ,trilinos-serial-xyce)))
    (home-page "https://xyce.sandia.gov/")
    (synopsis "High-performance analog circuit simulator")
    (description
     "Xyce is a SPICE-compatible, high-performance analog circuit simulator,
capable of solving extremely large circuit problems by supporting large-scale
parallel computing platforms.  It also supports serial execution.")
    (license license:gpl3+)))

(define trilinos-parallel-xyce
  (package (inherit trilinos-serial-xyce)
    (name "trilinos-parallel-xyce")
    (arguments
     `(,@(substitute-keyword-arguments (package-arguments trilinos-serial-xyce)
           ((#:configure-flags flags)
            `(append (list "-DTrilinos_ENABLE_ShyLU=ON"
                           "-DTrilinos_ENABLE_Zoltan=ON"
                           "-DTPL_ENABLE_MPI=ON")
                     ,flags)))))
    (inputs
     `(("mpi" ,openmpi)
       ,@(package-inputs trilinos-serial-xyce)))))

(define-public xyce-parallel
  (package (inherit xyce-serial)
    (name "xyce-parallel")
    (arguments
     `(,@(substitute-keyword-arguments (package-arguments xyce-serial)
           ((#:configure-flags flags)
            `(list "CXXFLAGS=-O3"
                   "CXX=mpiCC"
                   "CC=mpicc"
                   "F77=mpif77"
                   "--enable-mpi"
                   (string-append
                    "ARCHDIR="
                    (assoc-ref %build-inputs "trilinos")))))))
    (propagated-inputs
     `(("mpi" ,openmpi)))
    (inputs
     `(("trilinos" ,trilinos-parallel-xyce)
       ,@(alist-delete "trilinos"
                       (package-inputs xyce-serial))))))

(define-public freehdl
  (package
    (name "freehdl")
    (version "0.0.8")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://downloads.sourceforge.net/qucs/freehdl-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "117dqs0d4pcgbzvr3jn5ppra7n7x2m6c161ywh6laa934pw7h2bz"))
              (patches
               (list (origin
                       ;; Fix build with GCC 7.  Patch taken from Arch Linux:
                       ;; https://github.com/archlinux/svntogit-community/tree/packages/freehdl/trunk
                       (method url-fetch)
                       (uri (string-append "https://raw.githubusercontent.com"
                                           "/archlinux/svntogit-community"
                                           "/3bb90d64dfe6883e26083cd1fa96226d0d59175a"
                                           "/trunk/build-fix.patch"))
                       (file-name "freehdl-c++-namespace.patch")
                       (sha256
                        (base32
                         "09df3c70rx81rnhlhry1wpdhji274nx9jb74rfprk06l4739zm08")))))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'patch-pkg-config
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "freehdl/freehdl-config"
               (("pkg-config")
                (search-input-file inputs "/bin/pkg-config"))
               (("cat")
                (search-input-file inputs "/bin/cat")))))
         (add-after 'patch-pkg-config 'setenv
           (lambda* (#:key inputs #:allow-other-keys)
             (setenv "CXX" (search-input-file inputs "/bin/g++"))
             (setenv "SYSTEM_LIBTOOL"
                     (search-input-file inputs "/bin/libtool"))))
         (add-after 'setenv 'patch-gvhdl
           (lambda _
             (substitute* "v2cc/gvhdl.in"
               (("--mode=link") "--mode=link --tag=CXX")
               (("-lm") "-lm FREEHDL/lib/freehdl/libieee.la"))))
         (add-after 'patch-gvhdl 'patch-freehdl-gennodes
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "freehdl/freehdl-gennodes.in"
               (("guile")
                (search-input-file inputs "/bin/guile"))
               (("\\(debug") ";(debug")
               (("\\(@ ") "(apply-emit")
               (("\\(@@ ") "(apply-mini-format"))))
         (add-after 'configure 'patch-freehdl-pc
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "freehdl.pc"
               (("=g\\+\\+")
                (string-append "=" (assoc-ref inputs "gcc-toolchain")
                               "/bin/g++"))
               (("=libtool")
                (string-append "=" (assoc-ref inputs "libtool")
                               "/bin/libtool")))))
         (add-after 'install-scripts 'make-wrapper
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               ;; 'gvhdl' invokes the C compiler directly, so hard-code its
               ;; file name.
               (wrap-program (string-append out "/bin/gvhdl")
                 `("CPLUS_INCLUDE_PATH" ":" prefix
                   (,(string-append (assoc-ref inputs "gcc-toolchain")
                                    "/include")))
                 `("LIBRARY_PATH" ":" prefix
                   (,(string-append (assoc-ref inputs "gcc-toolchain")
                                    "/lib")))
                 `("PATH" ":" prefix
                   (,(string-append (assoc-ref inputs "gcc-toolchain")
                                    "/bin")
                    ,(string-append (assoc-ref inputs "coreutils")
                                    "/bin"))))
               (wrap-program (string-append out "/bin/freehdl-config")
                 `("PKG_CONFIG_PATH" ":" prefix
                   (,(string-append out "/lib/pkgconfig"))))))))))
    (inputs
     (list bash-minimal
           coreutils

           ;; Lazily resolve the gcc-toolchain to avoid a circular dependency.
           (module-ref (resolve-interface '(gnu packages commencement))
                       'gcc-toolchain)

           guile-2.2
           perl
           pkg-config
           libtool))
    (native-inputs
     `(("pkg-config-native" ,pkg-config)
       ("libtool-native" ,libtool)))
    (home-page "http://www.freehdl.seul.org/")
    (synopsis "VHDL simulator")
    (description
     "FreeHDL is a compiler/simulator suite for the hardware description language VHDL.
  VHDL'93 as well as VHDL'87 standards are supported.")
    (license (list license:gpl2+
                   license:lgpl2.0+)))) ; freehdl's libraries

(define-public librepcb
  (package
    (name "librepcb")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://download.librepcb.org/releases/"
                           version "/librepcb-" version "-source.zip"))
       (modules `((guix build utils)))
       (snippet
        ;; Delete libraries that we already have or don't need.
        ;; TODO: try to unbundle more (see lib/).
        `(begin
           (let ((third-parties '("fontobene-qt5"
                                  "googletest"
                                  "hoedown"
                                  "muparser"
                                  "polyclipping"
                                  "quazip")))
             (with-directory-excursion "libs"
               (map (lambda (third-party)
                      (delete-file-recursively third-party))
                    third-parties)))))
       (sha256
        (base32 "02qfwyhdq1pklb5gkwn3rbsdhwvcgiksd21swaphz3kw6s4p9i8v"))))
    (build-system cmake-build-system)
    (inputs
     (list clipper
           fontconfig
           fontobene-qt5
           glu
           hoedown
           muparser
           opencascade-occt
           qtbase-5
           qtdeclarative-5
           qtquickcontrols2-5
           qtsvg-5
           quazip
           zlib))
    (native-inputs
     (list googletest
           pkg-config
           qttools-5
           unzip))
    (arguments
     `(#:configure-flags (list
                          "-DUNBUNDLE_FONTOBENE_QT5=ON"
                          "-DUNBUNDLE_GTEST=ON"
                          "-DUNBUNDLE_HOEDOWN=ON"
                          "-DUNBUNDLE_MUPARSER=ON"
                          "-DUNBUNDLE_POLYCLIPPING=ON"
                          "-DUNBUNDLE_QUAZIP=ON")
       #:phases (modify-phases %standard-phases
                  (replace 'check
                    (lambda* (#:key tests? #:allow-other-keys)
                      (when tests?
                        (let ((test-include (list "*"))
                              (test-exclude
                               (list
                                ;; These tests all fail when run by the build
                                ;; process even though they pass when manually
                                ;; run as a normal user.

                                ;; TODO: verify that the failing tests don't
                                ;; point to any actual underlying issues
                                "SystemInfoTest.testGetUsername"
                                "OrderPcbDialogTest.testAutoOpenBrowser"
                                "DxfImportDialogTest.testLayerName"
                                "DxfImportDialogTest.testCirclesAsDrills"
                                "DxfImportDialogTest.testJoinTangentPolylines"
                                "DxfImportDialogTest.testLineWidth"
                                "DxfImportDialogTest.testScaleFactor"
                                "DxfImportDialogTest.testPlacementPosition"
                                "GraphicsExportDialogTest.testPageSize"
                                "GraphicsExportDialogTest.testOrientation"
                                "GraphicsExportDialogTest.testMargins"
                                "GraphicsExportDialogTest.testShowPinNumbers"
                                "GraphicsExportDialogTest.testRotate"
                                "GraphicsExportDialogTest.testMirror"
                                "GraphicsExportDialogTest.testScale"
                                "GraphicsExportDialogTest.testPixmapDpi"
                                "GraphicsExportDialogTest.testBlackWhite"
                                "GraphicsExportDialogTest.testBackgroundColor"
                                "GraphicsExportDialogTest.testMinLineWidth"
                                "GraphicsExportDialogTest.testLayerColors"
                                "GraphicsExportDialogTest.testOpenExportedFiles"
                                "AddComponentDialogTest.testAddMore")))
                          (setenv "QT_QPA_PLATFORM" "offscreen")
                          (setenv "QT_QUICK_BACKEND" "software")
                          (display "Running unittests...\n")
                          (invoke "./tests/unittests/librepcb-unittests"
                                  (string-append
                                   "--gtest_filter="
                                   (string-join test-include ":")
                                   "-"
                                   (string-join test-exclude ":"))))))))))
    (home-page "https://librepcb.org/")
    (synopsis "Electronic Design Automation tool")
    (description "LibrePCB is @dfn{Electronic Design Automation} (EDA)
software to develop printed circuit boards.  It features human readable file
formats and complete project management with library, schematic and board
editors.")
    (license (list license:gpl3+
                   license:boost1.0 ; libs/optional/tests/catch.hpp,
                   license:expat ; libs/delaunay-triangulation,
                                 ; libs/parseagle, libs/type_safe
                   license:asl2.0 ; libs/parseagle
                   license:cc0 ; libs/optional
                   license:bsd-2)))) ; libs/optional/tests/catch.hpp

(define-public gpx
  (package
    (name "gpx")
    (version "2.5.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/markwal/GPX")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1yab269x8qyf7rd04vaxyqyjv4pzz9lp4sc4dwh927k23avr3rw5"))))
    (build-system gnu-build-system)
    (home-page "https://github.com/markwal/GPX")
    (synopsis "Converting gcode to x3g files for 3D printing")
    (description
     "GPX is a post processing utility for converting gcode output from 3D
slicing software to x3g files for standalone 3D printing on common 3D
printers.")
    (license license:gpl2+)))

(define-public gnucap
  (package
    (name "gnucap")
    (version "20171003")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://git.savannah.gnu.org/cgit/gnucap.git/snapshot/gnucap-"
                           version ".tar.gz"))
       (sha256
        (base32
         "16m09xa685qhj5fqq3bcgakrwnb74xhf5f7rpqkkf9fg8plzbb1g"))))
    (build-system gnu-build-system)
    (inputs
     (list readline))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               ;; Set correct rpath so that gnucap finds libgnucap.so.
               (substitute* (list "apps/configure" "lib/configure"
                                  "main/configure" "modelgen/configure")
                 (("LDFLAGS =")
                  (string-append "LDFLAGS = -Wl,-rpath=" out "/lib")))
               ;; gnucap uses a hand-written configure script that expects the
               ;; --prefix argument to be the first argument passed to it.
               (invoke "./configure" (string-append "--prefix=" out)))))
         (replace 'check
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out"))
                   (libpath "../lib/O:../apps/O"))
               (with-directory-excursion "tests"
                 ;; Make test return non-zero exit code when a test fails.
                 (substitute* "test"
                   (("/bin/sh") "/bin/sh -e")
                   (("\\|\\| echo \"\\*\\*\\*\\* \\$ii fails \\*\\*\\*\\*\"") ""))
                 ;; Fix expected plugin search path for test c_attach.1.gc
                 (substitute* "==out/c_attach.1.gc.out"
                   (("/usr/local/lib/gnucap")
                    (string-append libpath ":" out "/lib/gnucap")))
                 ;; Set library path so that gnucap can find libgnucap.so
                 ;; while running the tests.
                 (setenv "LD_LIBRARY_PATH" libpath)
                 (invoke "./test" "../main/O/gnucap" "" "test-output" "==out"))))))))
    (home-page "https://www.gnu.org/software/gnucap/")
    (synopsis "Mixed analog and digital circuit simulator")
    (description "GNUcap is a circuit analysis package.  It offers a general
purpose circuit simulator and can perform DC and transient analyses, fourier
analysis and AC analysis.  The engine is designed to do true mixed-mode
simulation.")
    (license license:gpl3+)))

(define-public cutter
  (package
    (name "cutter")
    (version "2.3.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rizinorg/cutter")
             (commit (string-append "v" version))
             (recursive? #t)))
       (modules '((guix build utils)))
       (snippet #~(delete-file-recursively "rizin"))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0d10g1wpw8p8hcxvw5q7ymfdxyrp4xqs6a49lf3gdgnmcpb248ad"))))
    (build-system qt-build-system)
    (arguments
     (list
      #:configure-flags #~(list "-DCUTTER_USE_BUNDLED_RIZIN=OFF")
      #:tests? #f)) ;no tests
    (native-inputs (list pkgconf))
    (inputs (list libzip
                  openssl
                  qtsvg-5
                  qttools-5
                  rizin
                  zlib))
    (home-page "https://cutter.re")
    (synopsis "Software reverse engineering platform")
    (description
     "Cutter is a reverse engineering platform powered by @code{rizin}.  It
aims to be an advanced and customizable reverse engineering platform while
keeping the user experience in mind.  Cutter is created by reverse engineers
for reverse engineers.")
    (license (list license:cc-by-sa3.0 ;the "Iconic" icon set
                   license:gpl3+))))   ;everything else

(define-public lib3mf
  (package
    (name "lib3mf")
    (version "2.2.0")
    (source
     (origin
      (method git-fetch)
      (uri (git-reference (url "https://github.com/3MFConsortium/lib3mf")
                          (commit (string-append "v" version))))
      (file-name (git-file-name name version))
      (sha256
       (base32
        "05zqvnzmi7j8rhp2mrskvxf1bxl7kb4c72dfx4y86219i1hx7i2q"))
      (modules '((guix build utils)))
      (snippet
       '(begin
          ;; Delete pre-compiled ACT.
          (delete-file-recursively "AutomaticComponentToolkit/bin")

          ;; Remove bundled software.  Preserve cpp-base64 as it has been
          ;; modified and cannot easily be unbundled.
          (for-each delete-file-recursively
                    '("Include/Libraries/libzip"
                      "Include/Libraries/zlib"
                      "Source/Libraries/libzip"
                      "Source/Libraries/zlib"))

          ;; Adjust header includes such that system headers are found.
          (substitute* '("Include/Common/OPC/NMR_OpcPackageReader.h"
                         "Include/Common/Platform/NMR_ImportStream_ZIP.h"
                         "Include/Common/Platform/NMR_ExportStream_ZIP.h"
                         "Include/Common/Platform/NMR_ImportStream_Compressed.h"
                         "Include/Common/Platform/NMR_ExportStream_Compressed.h"
                         "Source/Common/Platform/NMR_PortableZIPWriterEntry.cpp")
            (("Libraries/libzip/") "")
            (("Libraries/zlib/") ""))))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags (list "-DUSE_INCLUDED_ZLIB=0"
                               "-DUSE_INCLUDED_LIBZIP=0"
                               "-DUSE_INCLUDED_GTEST=0"
                               "-DUSE_INCLUDED_SSL=0")
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'provide-act
                    (lambda* (#:key native-inputs inputs #:allow-other-keys)
                      (let ((act (search-input-file (or native-inputs inputs)
                                                    "bin/act"))
                            (dir "AutomaticComponentToolkit/bin"))
                        (mkdir-p dir)
                        (symlink act (string-append dir "/act.linux"))))))))
    (native-inputs
     (list automatic-component-toolkit googletest pkg-config))
    (inputs
     (list `(,util-linux "lib") libzip libressl zlib))
    (synopsis "Implementation of the 3D Manufacturing Format (3MF) file standard")
    (description
     "Lib3MF is a C++ implementation of the 3D Manufacturing Format (3MF) file
standard.  It offers a way to integrate 3MF reading and writing capabilities, as
well as conversion and validation tools for input and output data.  The
specification can be downloaded at @url{http://3mf.io/specification/}.")
    (home-page "https://3mf.io/")
    (license license:bsd-2)))

(define-public python-pyvisa
  (package
    (name "python-pyvisa")
    (version "1.13.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "PyVISA" version))
              (sha256
               (base32
                "1iprr3h6d4w6v8ksgqpkgg545sai7i8hi5a5an394p26b25h1yl9"))
              (modules '((guix build utils)))
              (snippet '(begin
                          ;; Delete bundled python-prettytable.
                          (delete-file-recursively "pyvisa/thirdparty")))))
    (build-system pyproject-build-system)
    (arguments
     (list #:phases #~(modify-phases %standard-phases
                        (add-after 'unpack 'use-system-prettytable
                          (lambda _
                            (substitute* "pyvisa/shell.py"
                              (("from .thirdparty import prettytable")
                               "import prettytable")))))))
    (native-inputs (list python-pytest))
    (propagated-inputs (list python-dataclasses python-prettytable
                             python-typing-extensions))
    (home-page "https://pyvisa.readthedocs.io/en/latest/")
    (synopsis "Python binding for the VISA library")
    (description "PyVISA is a Python package for support of the
@acronym{VISA, Virtual Instrument Software Architecture}, in order to control
measurement devices and test equipment via GPIB, RS232, Ethernet or USB.")
    (license license:expat)))

(define-public python-pandapower
  (package
    (name "python-pandapower")
    (version "2.14.9")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pandapower" version ".zip"))
       (sha256
        (base32 "0c5vgiq795kd5q4wcy2x7s3l7x9xdj2nqyfx188dmhgqckrym161"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-pyproj python-pytest unzip))
    (propagated-inputs (list python-deepdiff
                             python-geojson
                             python-networkx
                             python-numpy
                             python-packaging
                             python-pandas
                             python-scipy
                             python-tqdm
                             python-typing-extensions))
    (home-page "https://www.pandapower.org/")
    (synopsis "Power system modelling and analysis")
    (description "@code{pandapower} is an easy to use network calculation
program aimed to automate the analysis and optimization of power systems.
It uses the data analysis library @code{pandas} and is compatible with the
commonly used @code{MATPOWER} / @code{PYPOWER} case format.  @code{pandapower}
allows using different solvers including an improved Newton-Raphson power flow
implementation, all @code{PYPOWER} solvers, the C++ library solvers for fast
steady-state distribution power system analysis of @code{PowerGridModel}, the
Newton-Raphson power flow solvers in the C++ library lightsim2grid, and the
@code{PowerModels.jl} library.")
    (license license:bsd-3)))

(define-public python-pandapipes
  (package
    (name "python-pandapipes")
    (version "0.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pandapipes" version ".zip"))
       (sha256
        (base32 "06yqqd25hxa6q49qcbpy0njwxkqzfhbff4frrrxd84391njgvdhq"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-nbmake
                         python-pytest
                         python-pytest-xdist
                         unzip))
    (propagated-inputs (list python-matplotlib
                             python-pandapower
                             python-shapely))
    (home-page "http://www.pandapipes.org")
    (synopsis "Simulation of multi energy grids")
    (description
     "This package provides a pipeflow calculation tool that complements
@code{pandapower} in the simulation of multi energy grids.")
    (license license:bsd-3)))

(define-public python-scikit-rf
  (package
    (name "python-scikit-rf")
    (version "1.1.0")
    (source (origin
              (method git-fetch) ;PyPI misses some files required for tests
              (uri (git-reference
                    (url "https://github.com/scikit-rf/scikit-rf")
                    (commit (string-append "v" version))))
              (sha256
               (base32
                "0ji1c8b9cbgb0w18dx976hza690npkypz8kav4a3yin2wysjvf64"))
              (file-name (git-file-name name version))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-matplotlib
                             python-networkx
                             python-numpy
                             python-openpyxl
                             python-pandas
                             python-pyqt
                             python-pyqtgraph
                             python-qtpy
                             python-scipy))
    (native-inputs (list python-coverage
                         python-flake8
                         python-nbval
                         python-networkx
                         python-pytest
                         python-pytest-cov
                         python-pytest-mock
                         python-pyvisa))
    (home-page "https://scikit-rf.org/")
    (synopsis "Radio frequency and Microwave Engineering Scikit")
    (description "Scikit-rf, or @code{skrf}, is a Python package for RF and
Microwave engineering.")
    (license license:bsd-3)))

(define-public python-lcapy
  (package
    (name "python-lcapy")
    (version "1.23")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "lcapy" version))
       (sha256
        (base32 "13swd2nd2s20hixy4as924sr223flcvcy9zw3qlzsrcvhppzb84n"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      ;; This test fails by FileNotFoundError (a schematic file), possibly
      ;; because it's not included in PyPI.
      #:test-flags #~(list "-k" "not test_circuitgraph")))
    (propagated-inputs (list python-ipython
                             python-matplotlib
                             python-networkx
                             python-numpy
                             python-property-cached
                             python-scipy
                             python-sympy
                             python-wheel))
    (native-inputs (list python-pytest))
    (home-page "https://github.com/mph-/lcapy")
    (synopsis "Symbolic linear circuit analysis")
    (description "Lcapy is a Python package for linear circuit analysis.  It
uses SymPy for symbolic mathematics.

Lcapy can symbolically analyse circuits described with netlists or by
series/parallel combinations of components.  It can also manipulate
ontinuous-time and discret-time expressions.")
    (license license:lgpl2.1+)))

(define-public openscad
  (package
    (name "openscad")
    (version "2021.01")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://files.openscad.org/openscad-" version
                           ".src.tar.gz"))
       (sha256
        (base32
         "0n83szr88h8snccjrslr96mgw3f65x3sq726n6x5vxp5wybw4f6r"))))
    (build-system cmake-build-system)
    (inputs
     `(("boost" ,boost)
       ("cgal" ,cgal)
       ("double-conversion" ,double-conversion)
       ("eigen" ,eigen)
       ("fontconfig" ,fontconfig)
       ("glew" ,glew)
       ("gmp" ,gmp)
       ("harfbuzz" ,harfbuzz)
       ("lib3mf" ,lib3mf)
       ("libxml2" ,libxml2)
       ("libzip" ,libzip)
       ("mpfr" ,mpfr)
       ("opencsg" ,opencsg)
       ("qscintilla" ,qscintilla)
       ("qtbase" ,qtbase-5)
       ("qtmultimedia-5" ,qtmultimedia-5)))
    (native-inputs
     `(("bison" ,bison)
       ("flex" ,flex)
       ("gettext" ,gettext-minimal)
       ("pkg-config" ,pkg-config)
       ("which" ,which)
       ;; the following are only needed for tests
       ("imagemagick" ,imagemagick)
       ("ps" ,procps)
       ("python" ,python)
       ("xvfb" ,xorg-server-for-tests)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (invoke "qmake"
                     (string-append "PREFIX=" (assoc-ref outputs "out")))
             #t))
         (replace 'check
           (lambda _
             (with-directory-excursion "tests"
               (invoke "cmake" ".")
               (invoke "make")
               (invoke "ctest" "--exclude-regex"
                       (string-join
                        (list
                         "astdumptest_allexpressions"
                         "echotest_function-literal-compare"
                         "echotest_function-literal-tests"
                         "echotest_allexpressions"
                         "lazyunion-*"
                         "pdfexporttest_centered"
                         "pdfexporttest_simple-pdf"

                         ;; Broken due since cgal@5.2 +
                         ;; https://github.com/CGAL/cgal/pull/5371 (security)
                         ;; FIXME: Investigate or wait for future releases to
                         ;; fix it.
                         ;; Unsure if wrong test-suite or wrong security
                         ;; patch.
                         "cgalpngtest_nef3_broken"
                         "opencsgtest_nef3_broken"
                         "csgpngtest_nef3_broken"
                         "throwntogethertest_nef3_broken")
                        "|")))
             ;; strip python test files since lib dir ends up in out/share
             (for-each delete-file
                       (find-files "libraries/MCAD" ".*\\.py"))
             #t)))))
    (synopsis "Script-based 3D modeling application")
    (description
     "OpenSCAD is a 3D Computer-aided Design (CAD) application.  Unlike an
interactive modeler, OpenSCAD generates 3D models from a script, giving you
full programmatic control over your models.")
    (home-page "https://www.openscad.org/")
    (license license:gpl2+)))

(define-public emacs-scad-mode
  (package
    (inherit openscad)
    (name "emacs-scad-mode")
    (native-inputs '())
    (inputs '())
    (build-system emacs-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'chdir-elisp
           ;; Elisp directory is not in root of the source.
           (lambda _
             (chdir "contrib")
             #t)))))
    (synopsis "Emacs major mode for editing editing OpenSCAD code")
    (description "@code{scad-mode} provides an Emacs major mode for editing
OpenSCAD code.  It supports syntax highlighting, indenting and refilling of
comments.")))

(define-public freecad
  (package
    (name "freecad")
    (version "0.21.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/FreeCAD/FreeCAD")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0s720q6vxlh78jzahqp69nl8wagb42l05dym5aqhfnr31dx666hc"))
       ;; https://github.com/FreeCAD/FreeCAD/pull/11496
       (patches (search-patches "freecad-vtk-9.3.patch"))))
    (build-system qt-build-system)
    (native-inputs
     (list doxygen
           graphviz
           qttools-5
           pkg-config
           python-pyside-2-tools
           swig))
    (inputs
     (list bash-minimal
           boost
           coin3d
           double-conversion
           eigen
           fmt
           fontconfig
           freetype
           gl2ps
           glew
           hdf5-1.10
           jsoncpp
           libarea
           libjpeg-turbo
           libmedfile
           libspnav
           libtheora
           libtiff
           libxi
           libxml++
           libxmu
           lz4
           netcdf
           opencascade-occt
           openmpi
           proj
           python-gitpython
           python-matplotlib
           python-pivy
           python-ply
           python-pyside-2
           python-pyyaml
           python-shiboken-2
           python-wrapper
           qtbase-5
           qtdeclarative-5
           qtsvg-5
           qtwebchannel-5
           qtwebengine-5
           qtx11extras
           qtxmlpatterns
           sqlite
           tbb-2020                     ; Same version as opencascade-occt
           vtk
           xerces-c
           zlib))
    (arguments
     `(#:tests? #f                      ; Project has no tests
       #:configure-flags
       ,#~(list
           "-DBUILD_QT5=ON"
           "-DBUILD_FLAT_MESH:BOOL=ON"
           "-DBUILD_ENABLE_CXX_STD:STRING=C++17"
           (string-append "-DCMAKE_INSTALL_LIBDIR=" #$output "/lib"))
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'restore-pythonpath
           (lambda _
             (substitute* "src/Main/MainGui.cpp"
               (("_?putenv\\(\"PYTHONPATH=\"\\);") ""))))
         (add-after 'install 'wrap-pythonpath
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (wrap-program (string-append out "/bin/FreeCAD")
                 (list "GUIX_PYTHONPATH"
                       'prefix (list (getenv "GUIX_PYTHONPATH"))))))))))
    (home-page "https://www.freecadweb.org/")
    (synopsis "Your Own 3D Parametric Modeler")
    (description
     "FreeCAD is a general-purpose, feature-based, parametric 3D modeler for
CAD, MCAD, CAx, CAE, and PLM.  It is aimed directly at mechanical engineering
and product design but also fits a wider range of uses in engineering, such as
architecture or other engineering specialties.  It is modular, allowing for
extension and customization.")
    (license
     (list
      license:lgpl2.1+
      license:lgpl2.0+
      license:gpl3+
      license:bsd-3))))

(define-public libmedfile
  (package
    (name "libmedfile")
    (version "4.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://files.salome-platform.org/Salome/other/med-"
             version ".tar.gz"))
       (sha256
        (base32
         "017h9p0x533fm4gn6pwc8kmp72rvqmcn6vznx72nkkl2b05yjx54"))))
    (build-system cmake-build-system)
    (inputs (list hdf5-1.10))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'install 'remove-test-output
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (delete-file-recursively
                (string-append out "/bin/testc"))
               #t))))))
    (home-page "https://www.salome-platform.org")
    (synopsis "Library to read and write MED files")
    (description
     "The purpose of the MED module is to provide a standard for storing and
recovering computer data associated to numerical meshes and fields, and to
facilitate the exchange between codes and solvers.

The persistent data storage is based upon HDF format (like CGNS, a standard
developed by Boeing and NASA in the area of Computational Fluid Dynamic).

MED also provides structures to hold data on meshes and fields.  These
structures are exchanged between solvers, hide the communication level (CORBA
or MPI), and offer persistence (read/write in .med files).

The main benefit of a common exchange format is reduced complexity of code
coupling.  It also allows sharing such high level functionalities as
computation of nodal connectivity of sub-elements (faces and edges),
arithmetic operations on fields, entity location functionalities, and
interpolation toolkit.")
    (license license:gpl3+)))

(define-public python-motulator
  (package
    (name "python-motulator")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "motulator" version))
       (sha256
        (base32 "01qv4d4rgkwk653vz1qz1nmakniv86572j5ikrxwd63rwv5ckggf"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f)) ; there are no tests
    (propagated-inputs (list python-matplotlib python-numpy python-scipy))
    (native-inputs (list python-hatchling
                         python-ipykernel
                         python-toml))
    (home-page "https://aalto-electric-drives.github.io/motulator/")
    (synopsis "Motor Drive Simulator in Python")
    (description "This package includes simulation models for an induction
motor, a synchronous reluctance motor, and a permanent-magnet synchronous
motor.  The motor models are simulated in the continuous-time domain while the
control algorithms run in discrete time.  The default solver is the explicit
Runge-Kutta method of order 5(4) from @code{scipy.integrate.solve_ivp.}")
    (license license:expat)))

(define-public cgns
  (package
    (name "cgns")
    (version "4.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/CGNS/CGNS")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0jig1y7lv9qk1ri2gqws7ffpajmhxnank7gbyna9hfaghsxdlnvd"))))
    (build-system cmake-build-system)
    (arguments
     (list #:configure-flags
           '(list "-DCGNS_ENABLE_TESTS=ON"
                  "-DCGNS_ENABLE_FORTRAN=ON")))
    (inputs (list hdf5 gfortran))
    (home-page "https://cgns.org/")
    (synopsis "Read and write computational fluid dynamics analysis data")
    (description "This package provides software that reads, writes, and
modifies data in the @dfn{CFD General Notation System} (CGNS) format.  The
format is meant for recording and recovering computer data associated with the
numerical solution of fluid dynamics equations.  The format is a conceptual
entity established by the documentation; the software is a physical product
supplied to enable developers to access and produce data recorded in that
format.")
    (license license:zlib)))

(define-public libarea
  (let ((revision "1")
        (commit "8f8bac811c10f1f01fda0d742a18591f61dd76ee"))
    (package
      (name "libarea")
      (version (git-version "0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/Heeks/libarea")
                             (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0pvqz6cabxqdz5y26wnj6alkn8v5d7gkx0d3h8xmg4lvy9r3kh3g"))))
      (build-system gnu-build-system)
      (inputs (list boost python-wrapper))
      (native-inputs
       `(("cmake" ,cmake-minimal)))
      (arguments
       `(#:tests? #f
         #:phases
         (modify-phases %standard-phases
           (add-after 'configure 'cmake-configure
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out"))
                     (cmake (assoc-ref inputs "cmake")))
                 (mkdir-p "build")
                 (invoke "cmake"
                         (string-append "-DCMAKE_INSTALL_PREFIX=" out)))))
           (delete 'configure))))
      (home-page "https://github.com/Heeks/libarea")
      (synopsis
       "Library and python module for pocketing and profiling operations")
      (description
       "Area is a CAM-related software for pocketing operation.

This project provides library and associated python-module to compute pocket
operations.")
      (license (list
                license:bsd-3
                license:gpl3+)))))

(define-public libspnav
  (package
    (name "libspnav")
    (version "0.2.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/FreeSpacenav/libspnav")
                    (commit (string-append "libspnav-" version))))
              (sha256
               (base32
                "098h1jhlj87axpza5zgy58prp0zn94wyrbch6x0s7q4mzh7dc8ba"))
              (file-name (git-file-name name version))))
    (build-system gnu-build-system)
    (inputs
     (list libx11))
    (arguments `(#:tests? #f))
    (home-page "https://spacenav.sourceforge.net/")
    (synopsis
     "Library for communicating with spacenavd or 3dxsrv")
    (description
     "The libspnav library is provided as a replacement of the magellan
library.  It provides a cleaner, and more orthogonal interface.  libspnav
supports both the original X11 protocol for communicating with the driver, and
the new alternative non-X protocol.  Programs that choose to use the X11
protocol, are automatically compatible with either the free spacenavd driver
or the official 3dxserv, as if they were using the magellan SDK.

Also, libspnav provides a magellan API wrapper on top of the new API.  So, any
applications that were using the magellan library, can switch to libspnav
without any changes.  And programmers that are familiar with the magellan API
can continue using it with a free library without the restrictions of the
official SDK.")
    (license license:bsd-3)))

(define-public openctm
  (let ((revision 603))
    ;; Previous versions don't compile, they need to link libGL and libGLU.
    ;; Fixed in this revision.
    (package
      (name "openctm")
      (version (string-append "1.0.3." (number->string revision)))
      (source
       (origin
         (method svn-fetch)
         (uri (svn-reference
               (url "https://svn.code.sf.net/p/openctm/code/trunk")
               (revision revision)))
         (file-name (string-append name "-" version "-checkout"))
         (sha256
          (base32 "01wb70m48xh5gwhv60a5brv4sxl0i0rh038w32cgnlxn5x86s9f1"))))
      (build-system gnu-build-system)
      (native-inputs
       (list pkg-config))
      (inputs
       `(("mesa" ,mesa)
         ("glu" ,glu)
         ("glut" ,freeglut)
         ("gtk" ,gtk+-2)))
      (arguments
       `(#:tests? #f                              ;no tests
         #:phases
         (modify-phases %standard-phases
           (replace 'configure
             (lambda* (#:key outputs #:allow-other-keys)
               (rename-file "Makefile.linux" "Makefile")
               (let ((out (assoc-ref outputs "out")))
                 ;; Create output directories.
                 (mkdir-p (string-append out "/lib"))
                 (mkdir-p (string-append out "/include"))
                 (mkdir-p (string-append out "/bin"))
                 ;; Fix rpath.
                 (substitute* "tools/Makefile.linux"
                   (("-rpath,\\.")
                    (string-append "-rpath," out "/lib/"))
                   (("/usr/local")
                    out))
                 ;; Set right output.
                 (substitute* "Makefile"
                   (("/usr/lib")
                    (string-append out "/lib"))
                   (("\\/usr\\/local")
                    out))
                 #t))))))
      (synopsis "3D triangle mesh format and related tools and libraries")
      (description "OpenCTM is a file format, a software library and a tool set
for compression of 3D triangle meshes.  The geometry is compressed to a
fraction of comparable file formats (3DS, STL, COLLADA...), and the format is
accessible through a simple API")
      (license license:zlib)
      (home-page "https://openctm.sourceforge.net/"))))

(define-public lib3ds
  (package
    (name "lib3ds")
    (version "1.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://storage.googleapis.com/google-code-archive-downloads"
             "/v2/code.google.com/lib3ds/lib3ds-" version ".zip"))
       (sha256
        (base32 "1qr9arfdkjf7q11xhvxwzmhxqz3nhcjkyb8zzfjpz9jm54q0rc7m"))))
    (build-system gnu-build-system)
    (native-inputs
     (list unzip))
    (home-page "https://code.google.com/archive/p/lib3ds")
    (synopsis "3DS format file toolkit")
    (description "Lib3ds is a toolkit for handling the 3DS format for 3D
model files.  Its main goal is to simplify the creation of 3DS import and
export filters.")
    (license license:lgpl2.1+)))

(define-public meshlab
  (package
    (name "meshlab")
    (version "2022.02")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/cnr-isti-vclab/meshlab")
                    (commit (string-append "MeshLab-" version))
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32 "0dkh9qw9z2160s6gjiv0a601kp6hvl66cplvi8rfc892zcykgiwd"))))
    (build-system cmake-build-system)
    (inputs
     (list qtbase-5
           mesa
           glu
           glew
           muparser
           gmp
           eigen
           libfreenect
           lib3ds
           openctm
           qhull))
    (arguments
     (list #:tests? #f                  ; Has no tests
           #:configure-flags
           #~(list (string-append "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath="
                                  #$output "/lib/meshlab")
                   (string-append "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath="
                                  #$output "/lib/meshlab")
                   (string-append "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath="
                                  #$output "/lib/meshlab"))
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'unpack 'go-to-source-dir
                 (lambda _ (chdir "src"))))))
    (synopsis "3D triangular mesh processing and editing software")
    (home-page "https://www.meshlab.net/")
    (description "MeshLab is a system for the processing and editing of large,
unstructured, 3D triangular meshes.  It is aimed to help the processing of the
typical, not-so-small unstructured models arising in 3D scanning, providing a
set of tools for editing, cleaning, healing, inspecting, rendering and
converting this kind of meshes.  These tools include MeshLab proper, a
versatile program with a graphical user interface, and @samp{meshlabserver}, a
program that can perform mesh processing tasks in batch mode, without a GUI.")
    (license license:gpl3+)))

(define-public poke
  (package
    (name "poke")
    (version "4.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/poke/poke-" version
                                  ".tar.gz"))
              (sha256
               (base32 "1plv26x38jy2g97f7gj2kivjwlgcx5cja3m41qa56yin3vk3dbwa"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Delete files generated by Bison.
                  (delete-file "gl/parse-datetime.c")
                  (delete-file "gl/parse-datetime-gen.h")
                  (delete-file "jitter/example-vms/structured/structured-parser.c")
                  (delete-file "jitter/example-vms/structured/structured-parser.h")
                  (delete-file "jitter/jitterc/jitterc-parser.c")
                  (delete-file "jitter/jitterc/jitterc-parser.h")
                  (delete-file "jitter/jitter/jitter-routine-parser.c")
                  (delete-file "jitter/jitter/jitter-routine-parser.h")
                  (delete-file "libpoke/pkl-tab.c")
                  (delete-file "libpoke/pkl-tab.h")
                  (delete-file "poke/pk-map-tab.c")
                  (delete-file "poke/pk-map-tab.h")
                  ;; Delete files generated by flex.
                  (delete-file "jitter/example-vms/structured/structured-scanner.c")
                  (delete-file "jitter/example-vms/structured/structured-scanner.h")
                  (delete-file "jitter/jitterc/jitterc-scanner.c")
                  (delete-file "jitter/jitterc/jitterc-scanner.h")
                  (delete-file "jitter/jitter/jitter-routine-scanner.c")
                  (delete-file "jitter/jitter/jitter-routine-scanner.h")
                  (delete-file "libpoke/pkl-lex.c")
                  (delete-file "libpoke/pkl-lex.h")
                  (delete-file "poke/pk-map-lex.c")
                  (delete-file "poke/pk-map-lex.h")
                  ;; Other generated files:
                  (delete-file "jitter/example-vms/jitterlisp/jitterlispvm-vm1.c")
                  (delete-file "jitter/example-vms/jitterlisp/jitterlispvm-vm2.c")
                  (delete-file "jitter/example-vms/jitterlisp/jitterlispvm-vm.h")
                  (delete-file "jitter/example-vms/structured/structuredvm-vm1.c")
                  (delete-file "jitter/example-vms/structured/structuredvm-vm2.c")
                  (delete-file "jitter/example-vms/structured/structuredvm-vm.h")
                  (delete-file "jitter/example-vms/structured/structuredvm-vm-main.c")
                  (delete-file "jitter/example-vms/uninspired/uninspired-vm1.c")
                  (delete-file "jitter/example-vms/uninspired/uninspired-vm2.c")
                  (delete-file "jitter/example-vms/uninspired/uninspired-vm.h")
                  (delete-file "jitter/example-vms/uninspired/uninspired-vm-main.c")
                  (delete-file "libpoke/pvm-vm.h")
                  (delete-file "libpoke/pvm-vm1.c")
                  (delete-file "libpoke/pvm-vm2.c")))))
    (build-system gnu-build-system)
    (native-inputs (list bison dejagnu flex libtool pkg-config))
    ;; FIXME: Enable NBD support by adding `libnbd' (currently unpackaged).
    (inputs (list libgc readline libtextstyle))
    (arguments
     (list
      #:imported-modules `((guix build emacs-build-system)
                           (guix build emacs-utils)
                           ,@%default-gnu-imported-modules)
      #:modules '((guix build gnu-build-system)
                  ((guix build emacs-build-system) #:prefix emacs:)
                  (guix build utils))
      #:configure-flags
      #~(list "--disable-static"
              (string-append "--with-vimdir=" #$output
                             "/share/vim/vimfiles/pack/guix/start/poke")
              (string-append "--with-lispdir="
                             (emacs:elpa-directory #$output)))))
    (home-page "https://www.gnu.org/software/poke/#documentation")
    (synopsis "Editing of arbitrary binary data")
    (description "GNU poke is an interactive, extensible editor for binary data.
Not limited to editing basic entities such as bits and bytes, it provides a
full-fledged procedural, interactive programming language designed to describe
data structures and to operate on them.")
    (license license:gpl3+)))

(define-public emacs-poke
  ;; The 'emacs-poke' name may eventually refer to 'poke' from ELPA, which is
  ;; a different beast.
  (deprecated-package "emacs-poke" poke))

(define-public pcb2gcode
  (package
   (name "pcb2gcode")
   (version "2.5.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/pcb2gcode/pcb2gcode")
           (commit (string-append "v" version))
           (recursive? #t)))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "01s41znkcq9x1rinsdqrrdj8p35isckrcxs14ajsi7wr39n1m5kk"))))
   (build-system gnu-build-system)
   (inputs
    (list boost
          geos
          gerbv
          glibmm
          gtkmm-2
          (librsvg-for-system)))
   (native-inputs
    (list autoconf automake libtool pkg-config))
   (home-page "https://github.com/pcb2gcode/pcb2gcode")
   (synopsis "Generate G-code for milling PCBs")
   (description "pcb2gcode is a command-line program for isolation routing
and drilling of PCBs.  It takes Gerber files as input and outputs G-code files
for the milling of PCBs.  It also includes an autoleveller for the automatic
dynamic calibration of the milling depth.")
   (license license:gpl3+)))

;; libdxfrw has no readme, no version release, no tags.  Initial commit says
;; "libdxfrw-0.6.3 import", but it shares no git history with "upstream"
;; https://github.com/codelibs/libdxfrw.  Both are difficult to package
;; separately as they don't install properly.  Copying in-tree instead of
;; #:recursive #t to avoid downloading the other bigger dependencies which
;; aren't needed.
(define libdxfrw-sources
  (origin
    (method git-fetch)
    (uri (git-reference (url
                         "https://github.com/solvespace/libdxfrw")
                        (commit
                         "0b7b7b709d9299565db603f878214656ef5e9ddf")))
    (sha256 (base32
             "0d2wjq81466m3hb5cffiy99vhx0irwwy47yfxp318k2q4cvd5z2a"))))

(define-public solvespace
  (let ((commit "70bde63cb32a7f049fa56cbdf924e2695fcb2916")
        (version "3.1"))
    (package
      (name "solvespace")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/solvespace/solvespace")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1hbdln44k00a6vlklv2mq2c9zda3i9d5x0f7ks85w4v6zskhqnra"))))
      (build-system cmake-build-system)
      (native-inputs (list pkg-config gettext-minimal))
      (arguments
       (list
        #:build-type "Release"
        #:phases #~(modify-phases %standard-phases
                     (add-after 'unpack 'unpack-libdxfrw
                       (lambda _
                         (copy-recursively #$libdxfrw-sources
                                           "extlib/libdxfrw")))
                     (add-before 'configure 'embed-git-commit-hash
                       (lambda _
                         ;; `git describe` doesn't work here, so embed
                         ;; the commit hash directly in CMakeLists.txt as
                         ;; described instead.
                         (substitute* "CMakeLists.txt"
                           (("include\\(GetGitCommitHash\\)")
                            (string-append "set(GIT_COMMIT_HASH "
                                           #$commit ")")))))
                     (add-before 'configure 'use-packaged-mimalloc
                       (lambda _
                         (substitute* "CMakeLists.txt"
                           (("message\\(STATUS \"Using in-tree mimalloc\"\\)")
                            "message(STATUS \"Using guix packaged mimalloc\")")
                           (("add_subdirectory\\(extlib/mimalloc EXCLUDE_FROM_ALL\\)")
                            "find_package(mimalloc REQUIRED)"))))
                     (add-after 'install 'wrap-program
                       (lambda* (#:key inputs outputs #:allow-other-keys)
                         (wrap-program (string-append (assoc-ref outputs "out")
                                                      "/bin/solvespace")
                           ;; For GtkFileChooserDialog.
                           `("GSETTINGS_SCHEMA_DIR" =
                             (,(string-append (assoc-ref inputs "gtk+")
                                              "/share/glib-2.0/schemas")))))))))
      (inputs
       (list bash-minimal
             cairo
             eigen
             freetype
             gtkmm-3
             json-c
             libpng
             libspnav            ;spaceware
             mimalloc
             mesa
             zlib))
      (synopsis
       "Parametric 2D/3D @acronym{CAD, computer-aided design} software")
      (description
       "SOLVESPACE is a parametric 3D @acronym{CAD,
computer-aided design} tool.  Applications include:

@itemize
@item modeling 3D parts — draw with extrudes, revolves, helixes and
      Boolean (union / difference / intersection) operations
@item modeling 2D parts — draw the part as a single section,
      and export DXF, PDF, SVG; use 3D assembly to verify fit
@item 3D-printed parts — export the STL or other triangle mesh
      expected by most 3D printers
@item preparing CAM data — export 2D vector art for a waterjet
      machine or laser cutter; or generate STEP or STL, for import into
      third-party CAM software for machining
@item mechanism design — use the constraint solver to simulate planar
      or spatial linkages, with pin, ball, or slide joints
@item plane and solid geometry — replace hand-solved trigonometry and spreadsheets
      with a live dimensioned drawing
@end itemize")
      (home-page "https://solvespace.com/")
      (license license:gpl3+))))

(define-public syscall-intercept
  ;; Upstream provides no tag. Also, last version update is 4 years old.
  (let ((commit "304404581c57d43478438d175099d20260bae74e")
        (revision "0"))
    (package
      (name "syscall-intercept")
      (version (git-version "0.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/pmem/syscall_intercept/")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "17sw78xp5wjzv25adpbq3khl8fi0avj7bgpi57q3jnvl3c68xy5z"))))
      (native-inputs
       (list perl pkg-config))
      (inputs
       (list capstone))
      (build-system cmake-build-system)
      (arguments
       `(#:build-type "Release"
         ;; FIXME: "syscall_format_logging" test fails.
         #:tests? #f))
      (home-page "https://github.com/pmem/syscall_intercept")
      (synopsis "System call intercepting library")
      (description
       "The system call intercepting library provides a low-level interface
for hooking Linux system calls in user space.  This is achieved by
hot-patching the machine code of the standard C library in the memory of
a process.")
      (license license:bsd-2))))

(define-public xfoil
  (package
    (name "xfoil")
    (version "6.99")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://web.mit.edu/drela/Public/web/xfoil/xfoil"
                           version ".tgz"))
       (sha256
        (base32
         "0h5y5v0qlyvi4qc943x394npz4779i8f52iksxshxkjj7xj500jw"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-after 'unpack 'edit-files
           (lambda* (#:key outputs #:allow-other-keys)
             ;; The instructions in orrs/README say that orrs/bin/osmap.f
             ;; should be edited, but that file is never used by XFOIL.
             ;; Instead, it is osrc/osmap.f that is used.
             (substitute* "osrc/osmap.f"
               (("^[ ]{6}DATA OSFILE / '/var/local/codes/orrs/osmap.dat' /")
                (let ((replacement (string-append (make-string 6 #\space)
                                                  "DATA OSFILE / '"
                                                  (assoc-ref outputs "out")
                                                  "/share/xfoil/osmap.dat' /")))
                  ;; In fixed form Fortran, lines cannot exceed 72 columns.
                  ;; The Guix store path exceeds this limit.
                  (string-append
                    (substring replacement 0 72) "\n"
                    (make-string 5 #\space) "&" (substring replacement 72)))))
             (substitute* "orrs/bin/Makefile_DP"
               (("^FC = ifort")
                "FC = gfortran")
               (("^FLG = -O -r8")
                "FLG = -O2 -fdefault-real-8"))
             (substitute* "plotlib/Makefile"
               (("^include ./config.make")
                "include ./config.make.gfortranDP"))
             (substitute* "bin/Makefile_gfortran"
               (("^BINDIR = /home/codes/bin/")
                (string-append "BINDIR = " (assoc-ref outputs "out") "/bin"))
               (("^CC = cc")
                "CC = gcc")
               (("^CFLAGS = -O -DUNDERSCORE")
                "CFLAGS = -O2 -DUNDERSCORE")
               (("^FFLAGS = -O \\$\\(CHK\\) \\$\\(DBL\\)")
                "FFLAGS = -O2 $(CHK) $(DBL)")
               (("^FFLOPT = -O \\$\\(CHK\\) \\$\\(DBL\\)")
                "FFLOPT = -O2 $(CHK) $(DBL)")
               ;; Separate the build stage from the install stage.
               (("\\$\\(INSTALLCMD\\) xfoil \\$\\(BINDIR\\)") "")
               (("\\$\\(INSTALLCMD\\) pxplot \\$\\(BINDIR\\)") "")
               (("\\$\\(INSTALLCMD\\) pplot \\$\\(BINDIR\\)") ""))))
         (replace 'build
           (lambda _
             (invoke "make" "-C" "orrs/bin" "-f" "Makefile_DP" "osgen")
             (with-directory-excursion "orrs"
               (invoke "bin/osgen" "osmaps_ns.lst"))
             (invoke "make" "-C" "plotlib")
             (substitute* "bin/Makefile_gfortran"
               (("^FFLAGS =(.*)$" _ suffix)
                (string-append "FFLAGS = -fallow-argument-mismatch "
                               suffix "\n")))
             (invoke "make" "-C" "bin" "-f" "Makefile_gfortran")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin-dir (string-append out "/bin"))
                    (data-dir (string-append out "/share/xfoil"))
                    (doc-dir (string-append out "/share/doc/xfoil")))
               (mkdir-p bin-dir)
               (invoke "make" "-C" "bin" "-f" "Makefile_gfortran" "install")
               (mkdir-p data-dir)
               (install-file "orrs/osmap.dat" data-dir)
               (mkdir-p doc-dir)
               (install-file "xfoil_doc.txt" doc-dir)))))
       #:tests? #f))
    (inputs
     (list libx11))
    (native-inputs
     (list gfortran))
    (home-page "https://web.mit.edu/drela/Public/web/xfoil/")
    (synopsis "Program for the design and analysis of subsonic airfoils")
    (description
     "XFOIL is an interactive program for the design and analysis of subsonic
isolated airfoils.  It consists of a collection of menu-driven routines which
perform various useful functions such as:
@itemize
@item Viscous (or inviscid) analysis of an existing airfoil
@item Airfoil design and redesign by interactive modification of surface speed
      distributions
@item Airfoil redesign by interactive modification of geometric parameters
@item Blending of airfoils
@item Writing and reading of airfoil coordinates and polar save files
@item Plotting of geometry, pressure distributions, and multiple polars
@end itemize")
    (license license:gpl2+)))

(define-public libigl
  (package
    (name "libigl")
    (version "2.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/libigl/libigl")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "004a22ifq2vibgkgvrlyihqimpsfizvq5l448204kwfg3lkycajj"))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       '("-DLIBIGL_USE_STATIC_LIBRARY=OFF"
         "-DLIBIGL_BUILD_TESTS=ON"
         "-DLIBIGL_BUILD_TUTORIALS=OFF"
         "-DLIBIGL_EXPORT_TARGETS=ON"
         ;; The following options disable tests for the corresponding libraries.
         ;; The options do not affect whether the libraries are linked to
         ;; libigl or not, they are used for tests.
         "-DLIBIGL_WITH_COMISO=OFF"
         "-DLIBIGL_WITH_CORK=OFF"
         "-DLIBIGL_WITH_MATLAB=OFF"
         "-DLIBIGL_WITH_MOSEK=OFF"
         "-DLIBIGL_WITH_TRIANGLE=OFF" ;; Undefined reference to "triangulate".
         "-DLIBIGL_WITH_OPENGL_GLFW_IMGUI=OFF")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'unpack-external
           (lambda _
             (setenv "HOME" (getcwd)) ;; cmake needs this to export modules
             (mkdir "external")
             (copy-recursively (assoc-ref %build-inputs "libigl-glad") "external/glad")
             (copy-recursively (assoc-ref %build-inputs "libigl-stb") "external/stb")
             (copy-recursively (assoc-ref %build-inputs "libigl-tetgen") "external/tetgen")
             (copy-recursively (assoc-ref %build-inputs "libigl-predicates") "external/predicates")))
         (add-after 'unpack-external 'patch-cmake
           (lambda _
             ;; Fix references to external libraries
             (substitute* "cmake/libigl.cmake"
               (("if\\(NOT TARGET Eigen3::Eigen\\)" all)
                (string-append "find_package(Eigen3 CONFIG REQUIRED)\n" all))
               (("if\\(NOT TARGET CGAL::CGAL\\)" all)
                (string-append "find_package(CGAL CONFIG COMPONENTS Core)\n" all))
               (("if\\(NOT TARGET tinyxml2\\)" all)
                (string-append "find_package(tinyxml2 CONFIG REQUIRED)\n"
                               "if (NOT TARGET tinyxml2::tinyxml2)"))
               (("if\\(NOT TARGET embree\\)" all)
                (string-append "find_package(embree 3 CONFIG REQUIRED)\n" all))
               (("if\\(NOT TARGET glfw\\)" all)
                (string-append "find_package(glfw3 CONFIG REQUIRED)\n" all))
               (("igl_download_glad\\(\\)" all) "")
               (("igl_download_stb\\(\\)" all) "")
               (("igl_download_tetgen\\(\\)" all) "")
               (("igl_download_triangle\\(\\)" all) "")
               (("igl_download_predicates\\(\\)" all) ""))
             (substitute* "tests/CMakeLists.txt"
               (("igl_download_test_data\\(\\)") "")
               (("set\\(IGL_TEST_DATA.*")
                (format #f "set(IGL_TEST_DATA ~a)\n"
                        (assoc-ref %build-inputs "libigl-test-data")))
               (("igl_download_catch2\\(\\)") "find_package(Catch2 CONFIG REQUIRED)")
               (("list\\(APPEND CMAKE_MODULE_PATH \\$\\{LIBIGL_EXTERNAL\\}/catch2/contrib\\)")
                "")
               (("add_subdirectory\\(\\$\\{LIBIGL_EXTERNAL\\}/catch2 catch2\\)") ""))
             ;; Install otherwise missing headers
             (substitute* "cmake/libigl.cmake"
               (("install_dir_files\\(copyleft\\)" all)
                (string-join (list all
                                   "install_dir_files(copyleft/cgal)"
                                   "install_dir_files(copyleft/opengl)"
                                   "install_dir_files(copyleft/tetgen)"
                                   "install_dir_files(embree)"
                                   "install_dir_files(opengl)"
                                   "install_dir_files(png)"
                                   "install_dir_files(predicates)"
                                   "install_dir_files(xml)")
                             "\n"))))))))
    ;; XXX: Inputs are currently only used to build tests.
    ;;      We would need to patch the CMake recipe to build a shared library
    ;;      with all of these.
    (inputs
     `(("boost" ,boost)
       ("catch2" ,catch2)
       ("cgal" ,cgal)
       ("eigen" ,eigen)
       ("embree" ,embree)
       ("glfw" ,glfw)
       ("gmp" ,gmp)
       ("mesa" ,mesa)
       ("mpfr" ,mpfr)
       ("tbb" ,tbb)
       ("tinyxml2" ,tinyxml2)
       ;; When updating this package, update commit fields below according to
       ;; the hashes listed in "cmake/LibiglDownloadExternal.cmake".
       ("libigl-test-data"
        ,(origin
           (method git-fetch)
           (uri (git-reference
                 (url "https://github.com/libigl/libigl-tests-data")
                 (commit "19cedf96d70702d8b3a83eb27934780c542356fe")))
           (file-name (git-file-name "libigl-test-data" version))
           (sha256 (base32 "1wxglrxw74xw4a4jmmjpm8719f3mnlbxbwygjb4ddfixxxyya4i2"))))
       ("libigl-glad"
        ,(origin
           (method git-fetch)
           (uri (git-reference
                 (url "https://github.com/libigl/libigl-glad")
                 (commit "09b4969c56779f7ddf8e6176ec1873184aec890f")))
           (file-name (git-file-name "libigl-glad" version))
           (sha256 (base32 "0rwrs7513ylp6gxv7crjzflapcg9p7x04nzfvywgl665vl53rawk"))))
       ("libigl-stb"
        ,(origin
           (method git-fetch)
           (uri (git-reference
                 (url "https://github.com/libigl/libigl-stb.git")
                 (commit "cd0fa3fcd90325c83be4d697b00214e029f94ca3")))
           (file-name (git-file-name "libigl-stb" version))
           (sha256 (base32 "0wwlb370z40y63ic3ny6q7lxibhixg2k1pjdkl4ymzv79zld28kj"))))
       ("libigl-predicates"
        ,(origin
           (method git-fetch)
           (uri (git-reference
                 (url "https://github.com/libigl/libigl-predicates.git")
                 (commit "488242fa2b1f98a9c5bd1441297fb4a99a6a9ae4")))
           (file-name (git-file-name "libigl-predicates" version))
           (sha256 (base32 "13bd98g8lgcq37i3crj66433z09grnb2xjrcqpwqmyn147rp5wyh"))))
       ;; TODO: Package tetgen separately from <http://www.tetgen.org>
       ("libigl-tetgen"
        ,(origin
           (method git-fetch)
           (uri (git-reference
                 (url "https://github.com/libigl/tetgen.git")
                 (commit "4f3bfba3997f20aa1f96cfaff604313a8c2c85b6")))
           (file-name (git-file-name "libigl-tetgen" version))
           (sha256 (base32 "1k724syssw37py7kwmibk3sfwkkgyjyy7qkijnhn6rjm91g8qxsg"))))))
    (home-page "https://libigl.github.io/")
    (synopsis "Simple C++ geometry processing library")
    (description "This library provides functionality for shape modelling,
visualization, matrix manipulation.")
    (license (list license:gpl3 license:mpl2.0))))

(define-public prusa-slicer
  (package
    (name "prusa-slicer")
    (version "2.5.2")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://github.com/prusa3d/PrusaSlicer")
         (commit (string-append "version_" version))))
       (file-name (git-file-name name version))
       (sha256 (base32 "02qcrw3fa0d8ldbp73hp14l1qxbp3f4608j4csc07ny00ra42151"))
       (patches (search-patches "prusa-slicer-boost-fixes.patch"
                                "prusa-slicer-fix-tests.patch"
                                "prusa-slicer-with-cereal-1.3.1.patch"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           ;; Prusa slicer bundles a lot of dependencies in src/ directory.
           ;; Most of them contain prusa-specific modifications (e.g. avrdude),
           ;; but others do not. Here we replace the latter with Guix packages.
           ;; Remove bundled libraries that were not modified by Prusa Slicer developers.
           (delete-file-recursively "src/hidapi")
           (delete-file-recursively "src/eigen")
           (delete-file-recursively "src/libigl/igl")
           (substitute* "src/CMakeLists.txt"
             (("add_subdirectory\\(libigl\\)" all)
              (string-append
               all "\ninclude_directories(libigl INTERFACE libigl::core)"))
             (("add_subdirectory\\(hidapi\\)")
              "pkg_check_modules(HIDAPI REQUIRED hidapi-hidraw)")
             (("include_directories\\(hidapi/include\\)")
              "include_directories()"))
           (substitute* "src/slic3r/CMakeLists.txt"
             (("add_library\\(libslic3r_gui.*" all)
              (string-append
               all
               "\ntarget_include_directories(libslic3r_gui PUBLIC ${HIDAPI_INCLUDE_DIRS})\n"))
             (("\\bhidapi\\b") "${HIDAPI_LIBRARIES}"))))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags
       '("-DSLIC3R_FHS=1" ;; Use The Filesystem Hierarchy Standard.
         "-DSLIC3R_GTK=3" ;; Use GTK+
         ;; Use wxWidgets 3.0.x.x to prevent GUI crashes when adding support enforcers.
         "-DSLIC3R_WX_STABLE=1")))
    (native-inputs
     (list pkg-config))
    (inputs
     (list boost
           cereal
           cgal
           curl
           dbus
           eigen
           expat
           glew
           glib
           gmp
           gtk+
           hidapi
           ilmbase
           libigl
           libjpeg-turbo
           libpng
           mesa
           mpfr
           nlopt
           opencascade-occt
           openvdb
           pango
           tbb
           eudev
           ;; prusa-slicer 2.5 segfaults on startup with wxwidgets 3.2
           ;; See https://github.com/prusa3d/PrusaSlicer/issues/8299
           wxwidgets-3.0
           zlib))
    (home-page "https://www.prusa3d.com/prusaslicer/")
    (synopsis "G-code generator for 3D printers (RepRap, Makerbot, Ultimaker etc.)")
    (description "PrusaSlicer takes 3D models (STL, OBJ, AMF) and converts them into
G-code instructions for FFF printers or PNG layers for mSLA 3D printers.")
    (license license:agpl3)

    ;; Mark as tunable to take advantage of SIMD code in Eigen and in libigl.
    (properties '((tunable? . #t)))))

(define-public wireviz
  (package
    (name "wireviz")
    (version "0.3.2")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "wireviz" version))
              (sha256
               (base32
                "1dgnlxxlna2m1fh0ybivw0psym0sa5cqsl72mjl79bwfspnif61h"))))
    (build-system python-build-system)
    (propagated-inputs (list python-graphviz python-pillow python-pyyaml))
    (home-page "https://github.com/formatc1702/WireViz")
    (synopsis "Easily document cables and wiring harnesses")
    (description
     "WireViz is a tool for easily documenting cables, wiring harnesses and
connector pinouts.  It takes plain text, YAML-formatted files as input and
produces beautiful graphical output thanks to GraphViz.  It handles automatic
BOM creation and has a lot of extra features.")
    (license license:gpl3)))

(define-public libarcus
  (package
    (name "libarcus")
    (version "4.13.0") ; Should same version as Cura package.
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Ultimaker/libArcus")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "19fi0y0lk45cyampczgh3kz2swai4zcgzkffp0xf5h55rxxrdpvk"))))
    (build-system cmake-build-system)
    (inputs
     (list protobuf
           python
           python-sip-4))
    (arguments
     `(#:tests? #f
       #:configure-flags '("-DBUILD_EXAMPLES=OFF")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-protobuf-compatibility
           (lambda _
             (substitute* "src/Socket_p.h"
               (("stream\\.SetTotalBytesLimit\\(message_size_maximum,.*\\);")
                "stream.SetTotalBytesLimit(message_size_maximum);"))))
         (add-before 'configure 'fix-python-sitearch
           (lambda* (#:key outputs #:allow-other-keys)
             (substitute* "cmake/FindSIP.cmake"
               (("\\$\\{_process_output\\} Python3_SITEARCH")
                (string-append (assoc-ref outputs "out")
                               "/lib/python"
                               ,(version-major+minor
                                 (package-version python))
                               "/site-packages"
                               " Python3_SITEARCH"))))))))
    (home-page "https://github.com/Ultimaker/libArcus")
    (synopsis "Communication library for Ultimaker software components")
    (description "This library contains C++ code and Python3 bindings for
creating a socket in a thread and using this socket to send and receive
messages based on the Protocol Buffers library.  It is designed to
facilitate the communication between Cura and its backend and similar code.")
    (license license:lgpl3+)))

(define-public cura-engine
  (package
    (name "cura-engine")
    (version "4.13.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
               (url "https://github.com/Ultimaker/CuraEngine")
               (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0xp2r0m5wwfsh9wdb3biqzvfqfz5jsmyw4bww93aksw0rgli07bp"))))
    (build-system cmake-build-system)
    (native-inputs
     (list googletest pkg-config))
    (inputs
     (list libarcus protobuf stb-image))
    (arguments
     `(#:configure-flags '("-DBUILD_TESTS=ON")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "../source/cmake/FindStb.cmake"
               (("/usr/include")
                (string-append (assoc-ref inputs "stb-image")
                               "/include"))
               (("stb/stb_image_resize.h")
                "stb_image.h"))
             (substitute*
                 "../source/src/infill/ImageBasedDensityProvider.cpp"
               (("stb/stb_image.h")
                "stb_image.h")))))))
    (home-page "https://github.com/Ultimaker/CuraEngine")
    (synopsis "Cura slicing engine")
    (description
     "CuraEngine is an engine for processing 3D models into 3D printing
instructions for Ultimaker and other GCode-based 3D printers.  It is part of a
larger project called Cura.")
    (license license:agpl3+)))

(define-public cura-binary-data
  (package
    (name "cura-binary-data")
    (version "4.13.1")
    (source
     (origin
       (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Ultimaker/cura-binary-data")
               (commit version)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "11dra399adky7jxpaqqk1swrg5y3cc1086l54c3injg3ccgrvwik"))
         (modules '((guix build utils)))
         (snippet
          '(begin
             ;; Remove Windows executables and prebuilt firmware files.
             (delete-file-recursively "cura/resources/firmware")
             (delete-file-recursively "windows")))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f ; No test suite.
       #:configure-flags '("-DENABLE_FIRMWARE_INSTALL=OFF")))
    (home-page "https://github.com/Ultimaker/cura-binary-data")
    (synopsis "Binary data for Cura, like compiled translations")
    (description "This package contains binary data for Cura releases, like
compiled translations.  Prebuilt Firmware files are removed.")
    (license license:agpl3)))

(define-public uranium
  (package
    (name "uranium")
    (version "4.13.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
               (url "https://github.com/Ultimaker/Uranium")
               (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1nyxm3fdyrsisqkxbqld66bljd852wnc1yc6i1lyvncwvzn8ai32"))))
    (build-system cmake-build-system)
    (native-inputs
     (list doxygen
           gettext-minimal
           graphviz
           pkg-config
           python-pytest
           python-mypy
           python-certifi
           python-twisted))
    (propagated-inputs
     (list cura-binary-data
           libarcus
           python
           python-cryptography
           python-numpy
           python-pyqt
           python-scipy
           python-shapely
           python-trimesh
           python-zeroconf
           qtbase
           qtdeclarative-5
           qtgraphicaleffects
           qtquickcontrols-5
           qtquickcontrols2-5
           qtsvg-5))
    (arguments
     `(;; FIXME: tests are disabled, because they cause an infinite loop.
       #:tests? #f
       #:configure-flags
       ,#~(list (string-append "-DGETTEXT_MSGINIT_EXECUTABLE="
                               #$(this-package-native-input "gettext-minimal")
                               "/bin/msginit")
                (string-append "-DCURA_BINARY_DATA_DIRECTORY="
                               #$(this-package-input "cura-binary-data")))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-uranium-plugin-path
           (lambda* (#:key outputs #:allow-other-keys)
             (substitute* "UM/Application.py"
               (("app_root =.*$")
                (string-append "app_root = \""
                               (assoc-ref outputs "out") "\"\n"))
               (("app_root, \"share\", \"uranium\", \"plugins\"")
                "app_root, \"lib\", \"uranium\", \"plugins\"")))))))
    (home-page "https://github.com/Ultimaker/Uranium")
    (synopsis "Python framework for building desktop applications")
    (description "Uranium is a Python Framework for building 3D printing
related desktop applications using PyQt5.  It belongs to the Cura project
from Ultimaker.")
    (license license:lgpl3+)))

(define-public libnest2d-for-cura
  ;; Cura uses a custom fork of the libnest2d library.
  (package
    (name "libnest2d-for-cura")
    (version "4.12.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Ultimaker/libnest2d")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wk7cv8sqnxy7srq61scrr18dz2i0l4s4slmjfh4890iy0wf9i7n"))))
    (build-system cmake-build-system)
    (inputs
     (list boost clipper nlopt))
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'fix-clipper-detection
           (lambda* (#:key inputs #:allow-other-keys)
             (setenv "CLIPPER_PATH" (assoc-ref inputs "clipper")))))))
    (home-page "https://github.com/Ultimaker/libnest2d")
    (synopsis "2D irregular bin packaging and nesting library")
    (description
     "Libnest2D is a library and framework for the 2D bin packaging
problem.  It was inspired from the SVGNest Javascript library.")
    (license license:lgpl3)))

(define-public python-pynest2d
  (package
    (name "python-pynest2d")
    (version "4.12.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Ultimaker/pynest2d")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0jhqfylg6vzlbz9rqs981bg6y8s18iklw1p8hmax72xq2c7561s1"))))
    (build-system cmake-build-system)
    (native-inputs
     (list pkg-config))
    (inputs
     (list boost
           clipper
           libnest2d-for-cura
           nlopt
           python
           python-sip-4))
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'fix-clipper-detection
           (lambda* (#:key inputs #:allow-other-keys)
             (setenv "CLIPPER_PATH" (assoc-ref inputs "clipper"))))
         (add-before 'configure 'fix-python-sitearch
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((path (string-append (assoc-ref outputs "out")
                                        "/lib/python"
                                        ,(version-major+minor
                                          (package-version python))
                                        "/site-packages")))
               (substitute* "cmake/FindSIP.cmake"
                 (("\\$\\{_process_output\\} Python3_SITEARCH")
                  (string-append path " Python3_SITEARCH"))
                 (("\\$\\{_process_output\\} Python3_SITELIB")
                  (string-append path " Python3_SITELIB")))))))))
    (home-page "https://github.com/Ultimaker/pynest2d")
    (synopsis "Python bindings for libnest2d")
    (description
     "This package contains CPython bindings for libnest2d-for-cura.")
    (license license:lgpl3+)))

(define-public libcharon
  (package
    (name "libcharon")
    (version "4.13.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
               (url "https://github.com/Ultimaker/libCharon")
               (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0ibv15y7lfxs09k6rbc3kiaz13gq3v9vqxrk20rqp6bdclk3izff"))))
    (build-system cmake-build-system)
    (native-inputs
     (list python-pytest))
    (inputs
     (list python))
    (home-page "https://github.com/Ultimaker/libCharon")
    (synopsis "File metadata and streaming library")
    (description "LibCharon is a Python file metadata and streaming library.  It
belongs to the Cura project from Ultimaker.")
    (license license:lgpl3+)))

(define-public libsavitar
  (package
    (name "libsavitar")
    (version "4.13.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Ultimaker/libSavitar")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1cq85x0xizsjwf9nl7v7x4i9vl335mgv2lda3q2c9fcwrndsc3wk"))))
    (build-system cmake-build-system)
    (inputs
     (list python python-sip-4))
    (arguments
     `(#:tests? #f ; No test suite.
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'fix-python-sitearch
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((path (string-append (assoc-ref outputs "out")
                                        "/lib/python"
                                        ,(version-major+minor
                                          (package-version python))
                                        "/site-packages")))
               (substitute* "cmake/FindSIP.cmake"
                 (("\\$\\{_process_output\\} Python3_SITEARCH")
                  (string-append path " Python3_SITEARCH"))
                 (("\\$\\{_process_output\\} Python3_SITELIB")
                  (string-append path " Python3_SITELIB")))))))))
    (home-page "https://github.com/Ultimaker/libSavitar")
    (synopsis "C++ implementation of 3mf loading with SIP python bindings")
    (description "LibSavitar is a C++ implementation of 3mf loading with SIP
python bindings.  It belongs to the Cura project from Ultimaker.")
    (license license:lgpl3+)))

(define-public cura
  (package
    (name "cura")
    (version "4.13.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Ultimaker/Cura")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0yg17pcrj5gm02aqcjfk40ynvpb9r9aaq9rj108dkpki1is15ks7"))))
    (build-system qt-build-system)
    (native-inputs
     (list python-certifi
           python-mypy
           python-pytest
           python-requests))
    (inputs
     (list bash-minimal
           cura-engine
           libcharon
           libsavitar
           python
           python-keyring
           python-pynest2d
           python-pyserial
           python-sentry-sdk
           python-sip
           uranium))
    (arguments
     `(;; TODO: Fix tests.
       #:tests? #f
       #:configure-flags '("-DURANIUM_SCRIPTS_DIR=")
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'link-to-CuraEngine
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (symlink (string-append (assoc-ref inputs "cura-engine")
                                     "/bin/CuraEngine")
                      (string-append (assoc-ref outputs "out")
                                     "/bin/CuraEngine"))))
         (add-after 'link-to-CuraEngine 'wrap-pythonpath
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (wrap-program (string-append out "/bin/cura")
                 (list "GUIX_PYTHONPATH"
                       'prefix (list (string-append out
                                                    "/lib/python"
                                                    ,(version-major+minor
                                                      (package-version python))
                                                    "/site-packages")
                                     (getenv "GUIX_PYTHONPATH"))))))))))
    (home-page "https://github.com/Ultimaker/Cura")
    (synopsis "Slicer for 3D printers")
    (description "Cura is a slicing software from Ultimaker.  A @emph{slicer}
generates G-Code for 3D printers.")
    (license license:lgpl3+)))

(define-public xschem
  (let ((commit "f574539e21b297fa3bcebd52114555e162a5fc56")
        (revision "1"))
    (package
      (name "xschem")
      (version (git-version "3.0.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/StefanSchippers/xschem")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "129kj8m3wcf62plp74kml6pqwld4lnfmxy070a82lvj0rfiy77hb"))))
      (native-inputs (list flex bison pkg-config))
      (inputs (list gawk
                    tcl
                    tk
                    libxpm
                    cairo
                    libxrender
                    libxcb)) ; Last 3 are optional, but good to have.
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f
         #:phases
         (modify-phases %standard-phases
           (delete 'configure)
           (add-before 'build 'setenv
             (lambda* (#:key outputs #:allow-other-keys)
               (setenv "CC" ,(cc-for-target))
               (invoke "./configure"
                       (string-append "--prefix="
                                      (assoc-ref outputs "out"))))))))
      (synopsis "Hierarchical schematic editor")
      (description
       "Xschem is an X11 schematic editor written in C and focused on
hierarchical and parametric design.  It can generate VHDL, Verilog or Spice
netlists from the drawn schematic, allowing the simulation of the circuit.")
      (home-page "https://xschem.sourceforge.io/stefan/index.html")
      (license license:gpl2+))))

(define-public candle
  ;; The latest tagged version 1.2b fails on the build stage due to
  ;; non-supported g++ flags so we need to use the latest commit from the
  ;; 'master' branch in the repository.
  (let ((commit   "3f763bcde1195e23ba119a5b3c70d7c889881019")
        (revision "1"))
    (package
      (name "candle")
      (version (git-version "1.2b" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/Denvi/Candle")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "08rqhl6a5a8s67a8yl16944zgcsnnb08xfv4klzyqwlvaqgfp783"))))
      (build-system gnu-build-system)
      (native-inputs (list qttools-5))
      (inputs (list qtbase-5 qtserialport-5))
      (arguments
       (list #:tests? #f                      ; no tests.
             #:phases #~(modify-phases %standard-phases
                          (add-after 'unpack 'fix-sources
                            (lambda _
                              (substitute* (find-files "." ".*\\.h")
                                (("const char\\* what\\(\\) const override")
                                 "const char* what() const noexcept override"))))
                          (add-after 'unpack 'fix-application-settings-path
                            (lambda _
                              (substitute* "src/frmmain.cpp"
                                (("\
qApp->applicationDirPath\\(\\) \\+ \"\\/settings\\.ini\"")
                                 "QDir::homePath() + \"/.config/candle.ini\""))))
                          (replace 'configure
                            (lambda _
                              (chdir "src")
                              (invoke "qmake"
                                      (string-append "QMAKE_CC="
                                                     #$(cc-for-target)))))
                          (replace 'install
                            (lambda _
                              (install-file "Candle"
                                            (string-append #$output "/bin")))))))
      (home-page "https://github.com/Denvi/Candle")
      (synopsis "GRBL controller with G-Code visualizer")
      (description
       "Candle is a GRBL controller application with a visualizer for G-Code,
the @acronym{CNC, computer numerical control} programming language.

Supported functions include:

@itemize
@item Controlling GRBL-based cnc-machine via console commands, buttons on
form, numpad.
@item Monitoring CNC-machine state.
@item Loading, editing, saving and sending of G-code files to CNC-machine.
@item Visualizing G-code files.
@end itemize")
      (license license:gpl3+))))

(define-public rizin
  (package
    (name "rizin")
    (version "0.7.2")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/rizinorg/rizin/releases/download/v"
                    version "/rizin-src-v" version ".tar.xz"))
              (sha256
               (base32
                "0ajqng66b01phs0hjygg9phyc8p3fs0a1isbc0zmxdz2bas3zzzw"))))
    (build-system meson-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "-Dpackager=guix"
              (string-append "-Dpackager_version=" #$version)
              "-Duse_sys_capstone=enabled"
              "-Duse_sys_magic=enabled"
              "-Duse_sys_libzip=enabled"
              "-Duse_sys_zlib=enabled"
              "-Duse_sys_lz4=enabled"
              "-Duse_sys_libzstd=enabled"
              "-Duse_sys_xxhash=enabled"
              "-Duse_sys_openssl=enabled"
              "-Duse_sys_tree_sitter=enabled"
              "-Duse_sys_lzma=enabled"
              "-Duse_sys_libmspack=enabled"
              "-Duse_sys_pcre2=enabled"
              "-Duse_zlib=true"
              "-Duse_lzma=true"
              "-Dinstall_sigdb=false"
              "-Duse_swift_demangler=true"
              "-Duse_gpl=true")
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'configure 'skip-integration-tests
            (lambda _
              ;; Skip integration tests, which require prebuilt binaries at:
              ;; <https://github.com/rizinorg/rizin-testbins>.
              (substitute* "test/meson.build"
                (("subdir\\('integration'\\)") ""))
              ;;; Skip failing tests.
              (substitute* "test/unit/meson.build"
                (("'bin_mach0',\n") "")))))))
    (native-inputs (list pkg-config))
    (inputs
     (list capstone
           file
           libuv
           libzip
           lz4
           openssl
           pcre2
           tree-sitter
           xxhash
           zlib
           (list zstd "lib")
           libmspack))
    (home-page "https://rizin.re")
    (synopsis "Disassemble, debug, analyze, and manipulate binary files")
    (description
     "Rizin is a reverse engineering framework and a set of small command-line
utilities, providing a complete binary analysis experience with features like
disassembler, hexadecimal editor, emulation, binary inspection, debugger, and
more.")
    ;; Most files are under LGPL-3.0-only, other are under: Apache-2.0,
    ;; BSD-2-Clause, BSD-3-Clause, CC0-1.0, CC-BY-SA-4.0, GPL-1.0-or-later,
    ;; GPL-2.0-only, GPL-2.0-or-later, GPL-3.0-or-later, LGPL-2.0-or-later,
    ;; LGPL-2.1-only, LGPL-2.1-or-later, LGPL-3.0-only, MIT, NCSA.
    (license license:gpl3+)))

(define-public python-asyncua
  (package
    (name "python-asyncua")
    (version "1.0.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/FreeOpcUa/opcua-asyncio.git")
                     (commit (string-append "v" version))
                     (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0bazk3k2dyzlrh7yxs4pc76m5ysm7riia3ncg7as3xr4y9dy29bx"))))
    (build-system pyproject-build-system)
    (native-inputs
     (list python-pytest-asyncio python-pytest-runner python-asynctest
           python-pytest-mock))
    (propagated-inputs
     (list python-aiofiles python-aiosqlite python-cryptography
           python-importlib-metadata python-dateutil python-pytz
           python-sortedcontainers))
    (synopsis "OPC UA / IEC 62541 client and server library")
    (description "This package provides an OPC UA / IEC 62541 client and
server for Python and pypy3.")
    (home-page "https://freeopcua.github.io/")
    (license license:lgpl3+)))

(define-public cadabra2
  (package
    (name "cadabra2")
    (version "2.4.5.6")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/kpeeters/cadabra2")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1c0832q156kl83dz1wpjw4wf2f68fg7421wxwzahnr2r7xxvgrvl"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list
         (string-append "-DPYTHON_SITE_PATH=" #$output
                        "/lib/python"
                        #$(version-major+minor
                           (package-version (this-package-input "python")))
                        "/site-packages")
         (string-append "-DCMAKE_INSTALL_PREFIX="
                        (assoc-ref %outputs "out")))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-dependencies
            (lambda _
              (substitute* "cmake/modules/FindGLIBMM.cmake"
                (("glibmm-2[.]4") "glibmm-2.68"))
              (substitute* "client_server/ComputeThread.cc"
                (("sigc::slot<void>[(][)]") "{}")
                (("Glib::SPAWN_") "Glib::SpawnFlags::"))))
          (add-before 'check 'prepare-checks
            (lambda _
              (setenv "HOME" "/tmp"))))))
    (native-inputs
     (list pkg-config))
    (inputs
     (list glibmm gmp python boost gtkmm-3 sqlite python-gmpy2 python-sympy
           python-mpmath python-matplotlib texlive-dvipng
           `(,util-linux "lib")))
    (synopsis "Computer algebra system geared towards field theory")
    (description "This package provides a computer algebra system geared
towards field theory.")
    (home-page "https://cadabra.science/")
    (license license:gpl3+)))
