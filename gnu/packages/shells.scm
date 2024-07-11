;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013 Cyril Roelandt <tipecaml@gmail.com>
;;; Copyright © 2014, 2015 David Thompson <davet@gnu.org>
;;; Copyright © 2014 Kevin Lemonnier <lemonnierk@ulrar.net>
;;; Copyright © 2015 Jeff Mickey <j@codemac.net>
;;; Copyright © 2016–2021 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2016 Stefan Reichör <stefan@xsteve.at>
;;; Copyright © 2017, 2018 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017, 2018 Nikita <nikita@n0.is>
;;; Copyright © 2017, 2018 Leo Famulari <leo@famulari.name>
;;; Copyright © 2017, 2021 Arun Isaac <arunisaac@systemreboot.net>
;;; Copyright © 2019 Meiyo Peng <meiyo.peng@gmail.com>
;;; Copyright © 2019 Timothy Sample <samplet@ngyro.com>
;;; Copyright © 2019 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2019, 2020, 2023 Janneke Nieuwenhuizen <janneke@gnu.org>
;;; Copyright © 2020 Brice Waegeneire <brice@waegenei.re>
;;; Copyright © 2020 Ryan Prior <rprior@protonmail.com>
;;; Copyright © 2020, 2022 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2020, 2022 Marius Bakke <marius@gnu.org>
;;; Copyright © 2021, 2022 Nicolas Goaziou <mail@nicolasgoaziou.fr>
;;; Copyright © 2021, 2022 Felix Gruber <felgru@posteo.net>
;;; Copyright © 2022 Andrew Tropin <andrew@trop.in>
;;; Copyright © 2023 Zheng Junjie <873216071@qq.com>
;;; Copyright © 2023 David Pflug <david@pflug.io>
;;; Copyright © 2023 Jaeme Sifat <jaeme@runbox.com>
;;; Copyright © 2024 Tanguy Le Carrour <tanguy@bioneland.org>
;;; Copyright © 2024 Vinicius Monego <monego@posteo.net>
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

(define-module (gnu packages shells)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crates-crypto)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-web)
  #:use-module (gnu packages crates-windows)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages groff)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages libbsd)
  #:use-module (gnu packages libedit)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages scheme)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages texinfo)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public dash
  (package
    (name "dash")
    (version "0.5.12")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://gondor.apana.org.au/~herbert/dash/files/"
                           "dash-" version ".tar.gz"))
       (sha256
        (base32 "12pjm2j0q0q88nvqbcyqjwr8s1c29ilxyq2cdj8k42wbdv24liva"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           ;; The man page hails from BSD, where (d)ash is the default shell.
           ;; This isn't the case on Guix or indeed most other GNU systems.
           (substitute* "src/dash.1"
             (("the standard command interpreter for the system")
              "a command interpreter based on the original Bourne shell"))))))
    (build-system gnu-build-system)
    (inputs
     (list libedit))
    (arguments
     '(#:configure-flags '("--with-libedit")))
    (home-page "http://gondor.apana.org.au/~herbert/dash")
    (synopsis "POSIX-compliant shell optimised for size")
    (description
     "Dash is a POSIX-compliant @command{/bin/sh} implementation that aims to be
as small as possible, often without sacrificing speed.  It is faster than the
GNU Bourne-Again Shell (@command{bash}) at most scripted tasks.  Dash is a
direct descendant of NetBSD's Almquist Shell (@command{ash}).")
    (license (list license:bsd-3
                   license:gpl2+))))    ; mksignames.c

(define-public fish
  (package
    (name "fish")
    (version "3.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/fish-shell/fish-shell/"
                           "releases/download/" version "/"
                           "fish-" version ".tar.xz"))
       (sha256
        (base32 "1c9slg6azhc9jn1sb75wip4hl9zyibjy9nay505nkw0lnxw766yz"))))
    (build-system cmake-build-system)
    (inputs
     (list fish-foreign-env ncurses pcre2
           python))  ; for fish_config and manpage completions
    (native-inputs
     (list doxygen groff ; for 'fish --help'
           procps))             ; for the test suite
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'set-env
           (lambda _
             ;; some tests write to $HOME
             (setenv "HOME" (getcwd))
             #t))
         (add-after 'unpack 'patch-tests
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((coreutils (assoc-ref inputs "coreutils"))
                   (bash (assoc-ref inputs "bash")))
               ;; This test sporadically fails in the build container
               ;; because of leftover zombie processes, which are not
               ;; reaped automatically:
;; "Found existing zombie processes. Clean up zombies before running this test."
               ;; Disabling parallel tests does not reliably prevent it.
               (delete-file "tests/checks/jobs.fish")
               ;; This test fails.
               (delete-file "tests/checks/pipeline-pgroup.fish")
               ;; This one tries to open a terminal & can't simply be deleted.
               (substitute* "cmake/Tests.cmake"
                 ((".* interactive\\.fish.*") ""))
               ;; This one needs to chdir successfully.
               (substitute* "tests/checks/vars_as_commands.fish"
                 (("/usr/bin") "/tmp"))
               ;; These contain absolute path references.
               (substitute* "src/fish_tests.cpp"
                 (("/bin/echo" echo) (string-append coreutils echo))
                 (("/bin/ca" ca) (string-append coreutils ca))
                 (("\"(/bin/c)\"" _ c) (string-append "\"" coreutils c "\""))
                 (("/bin/ls_not_a_path" ls-not-a-path)
                  (string-append coreutils ls-not-a-path))
                 (("/bin/ls" ls) (string-append coreutils ls))
                 (("(/bin/)\"" _ bin) (string-append coreutils bin "\""))
                 (("/bin -" bin) (string-append coreutils bin))
                 (((string-append
                    "do_test\\(is_potential_path\\("
                    "L\"/usr\", wds, vars, PATH_REQUIRE_DIR\\)\\);"))
                  "")
                 ;; Not all mentions of /usr... need to exist, but these do.
                 (("\"/usr(|/lib)\"" _ subdirectory)
                  (string-append "\"/tmp" subdirectory "\"")))
               (substitute*
                 (append (find-files "tests" ".*\\.(in|out|err)$")
                         (find-files "tests/checks" ".*\\.fish"))
                 (("/bin/pwd" pwd) (string-append coreutils pwd))
                 (("/bin/echo" echo) (string-append coreutils echo))
                 (("/bin/sh" sh) (string-append bash sh))
                 (("/bin/ls" ls) (string-append coreutils ls)))
               (substitute* (find-files "tests" ".*\\.(in|out|err)$")
                 (("/usr/bin") (string-append coreutils "/bin")))
               #t)))
         ;; Source /etc/fish/config.fish from $__fish_sysconf_dir/config.fish.
         (add-after 'patch-tests 'patch-fish-config
           (lambda _
             (let ((port (open-file "etc/config.fish" "a")))
               (display (string-append
                         "\n\n"
                         "# Patched by Guix.\n"
                         "# Source /etc/fish/config.fish.\n"
                         "if test -f /etc/fish/config.fish\n"
                         "    source /etc/fish/config.fish\n"
                         "end\n")
                        port)
               (close-port port))
             #t))
         ;; Embed absolute paths.
         (add-before 'install 'embed-absolute-paths
           (lambda _
             (substitute* "share/functions/__fish_print_help.fish"
               (("nroff") (which "nroff")))
             #t))
         ;; Enable completions, functions and configurations in user's and
         ;; system's guix profiles by adding them to __extra_* variables.
         (add-before 'install 'patch-fish-extra-paths
           (lambda _
             (let ((port (open-file "share/__fish_build_paths.fish" "a")))
               (display
                (string-append
                 "\n\n"
                 "# Patched by Guix.\n"
                 "# Enable completions, functions and configurations in user's"
                 " and system's guix profiles by adding them to __extra_*"
                 " variables.\n"
                 "set -l __guix_profile_paths ~/.guix-profile"
                 " /run/current-system/profile\n"
                 "set __extra_completionsdir"
                 " $__guix_profile_paths\"/etc/fish/completions\""
                 " $__guix_profile_paths\"/share/fish/vendor_completions.d\""
                 " $__extra_completionsdir\n"
                 "set __extra_functionsdir"
                 " $__guix_profile_paths\"/etc/fish/functions\""
                 " $__guix_profile_paths\"/share/fish/vendor_functions.d\""
                 " $__extra_functionsdir\n"
                 "set __extra_confdir"
                 " $__guix_profile_paths\"/etc/fish/conf.d\""
                 " $__guix_profile_paths\"/share/fish/vendor_conf.d\""
                 " $__extra_confdir\n")
                port)
               (close-port port))
             #t))
         ;; Use fish-foreign-env to source /etc/profile.
         (add-before 'install 'source-etc-profile
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((port (open-file "share/__fish_build_paths.fish" "a")))
               (display
                (string-append
                 "\n\n"
                 "# Patched by Guix.\n"
                 "# Use fish-foreign-env to source /etc/profile.\n"
                 "if status is-login\n"
                 "    set fish_function_path "
                 (assoc-ref inputs "fish-foreign-env") "/share/fish/functions"
                 " $__fish_datadir/functions\n"
                 "    fenv source /etc/profile\n"
                 "    set -e fish_function_path\n"
                 "end\n")
                port)
               (close-port port))
             #t)))))
    (synopsis "The friendly interactive shell")
    (description
     "Fish (friendly interactive shell) is a shell focused on interactive use,
discoverability, and friendliness.  Fish has very user-friendly and powerful
tab-completion, including descriptions of every completion, completion of
strings with wildcards, and many completions for specific commands.  It also
has extensive and discoverable help.  A special @command{help} command gives
access to all the fish documentation in your web browser.  Other features
include smart terminal handling based on terminfo, an easy to search history,
and syntax highlighting.")
    (home-page "https://fishshell.com/")
    (license license:gpl2)))

(define-public fish-foreign-env
  (package
    (name "fish-foreign-env")
    (version "0.20230823")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/oh-my-fish/plugin-foreign-env")
             (commit "7f0cf099ae1e1e4ab38f46350ed6757d54471de7")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0d16mdgjdwln41zk44qa5vcilmlia4w15r8z2rc3p49i5ankksg3"))))
    (build-system trivial-build-system)
    (arguments
     '(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let* ((source (assoc-ref %build-inputs "source"))
                (out (assoc-ref %outputs "out"))
                (func-path (string-append out "/share/fish/functions")))
           (mkdir-p func-path)
           (copy-recursively (string-append source "/functions")
                             func-path)

           ;; Embed absolute paths.
           (substitute* `(,(string-append func-path "/fenv.fish")
                          ,(string-append func-path "/fenv.main.fish"))
             (("bash")
              (search-input-file %build-inputs "/bin/bash"))
             (("sed")
              (search-input-file %build-inputs "/bin/sed"))
             ((" tr ")
              (string-append " "
                             (search-input-file %build-inputs "/bin/tr")
                             " ")))))))
    (inputs
     (list bash coreutils sed))
    (home-page "https://github.com/oh-my-fish/plugin-foreign-env")
    (synopsis "Foreign environment interface for fish shell")
    (description "@code{fish-foreign-env} wraps bash script execution in a way
that environment variables that are exported or modified get imported back
into fish.")
    (license license:expat)))

(define-public rc
  (package
    (name "rc")
    (version "1.7.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rakitzis/rc")
                    (commit (string-append "v" version))))
              (sha256
               (base32
                "0vj1h4pcg13vxsiydmmk87dr2sra9h4gwx0c4q6fjsiw4in78rrd"))
              (file-name (git-file-name name version))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       '("--with-edit=gnu")
       #:phases
       (modify-phases %standard-phases
         (add-before 'bootstrap 'patch-trip.rc
          (lambda _
            (substitute* "trip.rc"
              (("/bin/pwd") (which "pwd"))
              (("/bin/sh")  (which "sh"))
              (("/bin/rm")  (which "rm"))
              (("/bin\\)")  (string-append (dirname (which "rm")) ")")))
            #t)))))
    (inputs (list readline perl))
    (native-inputs (list autoconf automake libtool pkg-config))
    (synopsis "Alternative implementation of the rc shell by Byron Rakitzis")
    (description
     "This is a reimplementation by Byron Rakitzis of the Plan 9 shell.  It
has a small feature set similar to a traditional Bourne shell.")
    (home-page "https://github.com/rakitzis/rc")
    (license license:zlib)))

(define-public es
  (package
    (name "es")
    (version "0.9.2")
    (source
     (origin
       (method url-fetch/tarbomb)
       (uri (string-append "https://github.com/wryun/es-shell/releases/"
                           "download/v" version "/es-" version ".tar.gz"))
       (sha256
        (base32 "1pgmqhsk14wyvl489sxdy7kdl2gwrsq1xvkip0z90kh888mlh9n9"))
       (file-name (string-append name "-" version ".tar.gz"))))
    (build-system gnu-build-system)
    (arguments
     (list #:test-target "test"))
    (inputs
     (list readline))
    (native-inputs
     (list bison))
    (synopsis "Extensible shell with higher-order functions")
    (description
     "Es is an extensible shell.  The language was derived from the Plan 9
shell, rc, and was influenced by functional programming languages, such as
Scheme, and the Tcl embeddable programming language.  This implementation is
derived from Byron Rakitzis's public domain implementation of rc, and was
written by Paul Haahr and Byron Rakitzis.")
    (home-page "https://wryun.github.io/es-shell/")
    (license license:public-domain)))

(define-public tcsh
  (package
    (name "tcsh")
    (version "6.24.01")
    (source (origin
              (method url-fetch)
              ;; Old tarballs are moved to old/.
              (uri (list (string-append "https://astron.com/pub/tcsh/"
                                        "tcsh-" version ".tar.gz")
                         (string-append "https://astron.com/pub/tcsh/"
                                        "old/tcsh-" version ".tar.gz")))
              (sha256
               (base32
                "0zhxp4m1fxyd3a2qyvs97gzlrb0h0ah1gjrqcbilgydiffws2nan"))
              (patches (search-patches "tcsh-fix-autotest.patch"))
              (patch-flags '("-p0"))))
    (build-system gnu-build-system)
    (native-inputs
     (append (if (target-riscv64?)
                 (list config)
                 '())
             (list autoconf perl)))
    (inputs
     (list libxcrypt ncurses))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          #$@(if (%current-target-system)
                 #~((add-before 'configure 'set-cross-cc
                      (lambda _
                        (substitute* "configure"
                          (("CC_FOR_GETHOST=\"cc\"")
                           "CC_FOR_GETHOST=\"gcc\"")))))
                 #~())
          #$@(if (system-hurd?)
                 #~((add-after 'unpack 'skip-tests
                      (lambda _
                        (substitute* "tests/testsuite.at"
                          (("m4_include\\(\\[subst.at\\]\\)" all)
                           (string-append "# " all))))))
                 #~())
          (add-before 'check 'patch-test-scripts
            (lambda _
              ;; Take care of pwd
              (substitute* '("tests/commands.at" "tests/variables.at")
                (("/bin/pwd") (which "pwd")))
              (substitute* "Makefile"
                ;; Likewise for /usr/bin/env.
                (("/usr/bin/env") "env")
                ;; Don't reset the environment (PATH, etc).
                (("\\$\\(ENVCMD\\) -") "$(ENVCMD)"))
              ;; This test does not expect the home directory from
              ;; /etc/passwd to be '/'.
              (substitute* "tests/subst.at"
                (("\\$\\(id -un\\)/foo")
                 "$(id -un)//foo"))
              ;; The .at files create shell scripts without shebangs. Erk.
              (substitute* "tests/commands.at"
                (("./output.sh") "/bin/sh output.sh"))
              (substitute* "tests/syntax.at"
                (("; other_script.csh") "; /bin/sh other_script.csh"))
              ;; Now, let's generate the test suite and patch it
              (invoke "make" "tests/testsuite")

              ;; This file is ISO-8859-1 encoded.
              (with-fluids ((%default-port-encoding #f))
                (substitute* "tests/testsuite"
                  (("/bin/sh") (which "sh"))))))
          (add-after 'install 'post-install
            (lambda _
              (with-directory-excursion (string-append #$output "/bin")
                (symlink "tcsh" "csh")))))))
    (home-page "https://www.tcsh.org/")
    (synopsis "Unix shell based on csh")
    (description
     "Tcsh is an enhanced, but completely compatible version of the Berkeley
UNIX C shell (csh).  It is a command language interpreter usable both as an
interactive login shell and a shell script command processor.  It includes a
command-line editor, programmable word completion, spelling correction, a
history mechanism, job control and a C-like syntax.")
    (license license:bsd-4)))

(define-public zsh
  (package
    (name "zsh")
    (version "5.9")
    (source (origin
              (method url-fetch)
              (uri (list (string-append
                           "https://www.zsh.org/pub/zsh-" version
                           ".tar.xz")
                         (string-append
                           "https://www.zsh.org/pub/old/zsh-" version
                           ".tar.xz")))
              (sha256
               (base32
                "1mdc8lnq8qxq1ahxp8610n799pd7a9kqg3liy7xq2pjvvp71x3cv"))
              (patches (search-patches "zsh-egrep-failing-test.patch"))))
    (build-system gnu-build-system)
    (arguments `(#:configure-flags
                 `("--with-tcsetpgrp"
                  "--enable-pcre"
                  "--enable-maildir-support"
                  ;; share/zsh/site-functions isn't populated
                  "--disable-site-fndir"
                  ,(string-append
                    "--enable-additional-fpath="
                    "/usr/local/share/zsh/site-functions," ; for foreign OS
                    "/run/current-system/profile/share/zsh/site-functions"))
                 #:phases
                 (modify-phases %standard-phases
                   (add-before 'configure 'fix-sh
                     (lambda _
                       ;; Some of the files are ISO-8859-1 encoded.
                       (with-fluids ((%default-port-encoding #f))
                                    (substitute*
                                        '("configure"
                                          "configure.ac"
                                          "Src/exec.c"
                                          "Src/mkmakemod.sh"
                                          "Config/installfns.sh"
                                          "Config/defs.mk.in"
                                          "Test/E01options.ztst"
                                          "Test/A05execution.ztst"
                                          "Test/A01grammar.ztst"
                                          "Test/A06assign.ztst"
                                          "Test/B02typeset.ztst"
                                          "Completion/Unix/Command/_init_d"
                                          "Util/preconfig")
                                      (("/bin/sh") (which "sh"))))))
                   (add-before 'check 'patch-test
                     (lambda _
                       ;; In Zsh, `command -p` searches a predefined set of
                       ;; paths that don't exist in the build environment. See
                       ;; the assignment of 'path' in Src/init.c'
                       (substitute* "Test/A01grammar.ztst"
                         (("command -pv") "command -v")
                         (("command -p") "command ")
                         (("'command' -p") "'command' "))))
                   (add-after 'build 'make-info
                     (lambda _ (invoke "make" "info")))
                   (add-after 'build 'install-info
                     (lambda _ (invoke "make" "install.info"))))))
    (native-inputs (list autoconf texinfo))
    (inputs (list ncurses pcre perl))
    (synopsis "Powerful shell for interactive use and scripting")
    (description "The Z shell (zsh) is a Unix shell that can be used
as an interactive login shell and as a powerful command interpreter
for shell scripting.  Zsh can be thought of as an extended Bourne shell
with a large number of improvements, including some features of bash,
ksh, and tcsh.")
    (home-page "https://www.zsh.org/")

    ;; The whole thing is under an MIT/X11-style license, but there's one
    ;; command, 'Completion/Unix/Command/_darcs', which is under GPLv2+.
    (license license:gpl2+)))

(define-public xonsh
  (package
    (name "xonsh")
    (version "0.17.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "xonsh" version))
        (sha256
          (base32
           "17jhhxwm1nbh7yq72y7d4n880x46817iami7lvcj3ywdbzrfg6r9"))
        (modules '((guix build utils)))
        (snippet
         #~(begin
             (substitute* "pyproject.toml"
               (("\"xonsh\\.ply\\.ply\",") ""))
             ;; Use our properly packaged PLY instead.
             (substitute* (list "setup.py"
                                "tests/test_lexer.py"
                                "xonsh/lexer.py"
                                "xonsh/parsers/base.py"
                                "xonsh/parsers/completion_context.py"
                                "xonsh/parsers/v310.py"
                                "xonsh/xonfig.py")
               (("from xonsh\\.ply\\.(.*) import" _ module)
                (format #f "from ~a import" module))
               (("from xonsh\\.ply import") "import"))))))
    (build-system pyproject-build-system)
    (arguments
     ;; Some tests are failing for reasons like not accessing parent directory
     ;; with os.getcwd(), not activating virtual environments, not finding
     ;; some commands (man, echo), and not running subprocesses.
     (list #:test-flags
           #~(list "-k"
                   (string-append
                    "not "
                    (string-join
                     (list "test_aliases_print"
                           "test_argv0"
                           "test_bash_and_is_alias_is_only_functional_alias"
                           "test_bash_completer"
                           "test_bash_completer_empty_prefix"
                           "test_complete_command"
                           "test_complete_dots"
                           "test_dirty_working_directory"
                           "test_equal_sign_arg"
                           "test_man_completion"
                           "test_parser_show"
                           "test_printfile"
                           "test_printname"
                           "test_quote_handling"
                           "test_script"
                           "test_skipper_command"
                           "test_sourcefile"
                           "test_spec_modifier_alias_output_format"
                           "test_vc_get_branch"
                           "test_xonsh_activator"
                           "test_xonsh_lexer")
                     " and not ")))
           #:phases
           #~(modify-phases %standard-phases
               (replace 'install
                 (lambda _
                   (invoke "python" "-m" "compileall"
                           "--invalidation-mode=unchecked-hash" #$output)
                   (invoke "python" "setup.py" "install" "--root=/"
                           (string-append "--prefix=" #$output))))
               ;; Some tests run os.mkdir().
               (add-before 'check 'writable-home
                 (lambda _
                   (setenv "HOME" "/tmp"))))))
    (native-inputs
     (list git-minimal
           python-pyte
           python-pytest
           python-pytest-mock
           python-pytest-rerunfailures
           python-pytest-subprocess
           python-pytest-timeout
           python-requests
           python-setuptools                      ;needed at build time
           python-wheel))
    (inputs
     (list python-distro
           python-ply
           python-prompt-toolkit
           python-pygments
           python-pyperclip
           python-setproctitle))
    (home-page "https://xon.sh/")
    (synopsis "Python-ish shell")
    (description
     "Xonsh is a Python-ish, BASHwards-looking shell language and command
prompt.  The language is a superset of Python 3.4+ with additional shell
primitives that you are used to from Bash and IPython.  It works on all major
systems including Linux, Mac OSX, and Windows.  Xonsh is meant for the daily
use of experts and novices alike.")
    (license license:bsd-2)))

(define-public scsh
  (let ((commit "4acf6e4ed7b65b46186ef0c9c2a1e10bef8dc052")
        (revision "0"))
    (package
      (name "scsh")
      (version (git-version "0.7" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/scheme/scsh")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1czrp808v5gs0ci5lmkp3wr3gfkrb3vd5b2iw2hz1bpqgaf6bxpv"))
         (patches (search-patches "scsh-nonstring-search-path.patch"))))
      (build-system gnu-build-system)
      (arguments
       (list
        #:test-target "test"
        #:phases
        #~(modify-phases %standard-phases
            (add-before 'configure 'replace-rx
              (lambda _
                (let ((rxpath (string-append #$scheme48-rx
                                             "/share/scheme48-"
                                             #$(package-version scheme48)
                                             "/rx")))
                  (delete-file-recursively "rx")
                  (symlink rxpath "rx")))))))
      (inputs
       (list scheme48 scheme48-rx))
      (native-inputs
       (list autoconf automake))
      (native-search-paths
       (list (search-path-specification
               (variable "SCSH_LIB_DIRS")
               (separator " ")
               (files '("share/scsh-0.7")))))
      (home-page "https://github.com/scheme/scsh")
      (synopsis "Unix shell embedded in Scheme")
      (description
       "Scsh is a Unix shell embedded in Scheme.  Scsh has two main
components: a process notation for running programs and setting up pipelines
and redirections, and a complete syscall library for low-level access to the
operating system.")
      (license license:bsd-3))))

(define-public linenoise
  (let ((commit "93b2db9bd4968f76148dd62cdadf050ed50b84b3")
        (revision "2"))
    (package
      (name "linenoise")
      (version (string-append "1.0-" revision "." (string-take commit 7)))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/antirez/linenoise")
               (commit commit)))
         (file-name (string-append name "-" version "-checkout"))
         (sha256
          (base32
           "102gwq6bzjq2b1lf55wrpgym58yfhry56hkajbj339m0bs1xijhs"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f                    ; no tests are included
         #:make-flags
         (list ,(string-append "CC=" (cc-for-target)))
         #:phases
         (modify-phases %standard-phases
           (delete 'configure)
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               ;; At the moment there is no 'make install' in upstream.
               (let* ((out (assoc-ref outputs "out")))
                 (install-file "linenoise.h"
                               (string-append out "/include/linenoise"))
                 (install-file "linenoise.c"
                               (string-append out "/include/linenoise"))
                 #t))))))
      (home-page "https://github.com/antirez/linenoise")
      (synopsis "Minimal zero-config readline replacement")
      (description
       "Linenoise is a minimal, zero-config, readline replacement.
Its features include:

@enumerate
@item Single and multi line editing mode with the usual key bindings
@item History handling
@item Completion
@item Hints (suggestions at the right of the prompt as you type)
@item A subset of VT100 escapes, ANSI.SYS compatible
@end enumerate\n")
      (license license:bsd-2))))

(define-public s-shell
  (let ((commit "da2e5c20c0c5f477ec3426dc2584889a789b1659")
        (revision "2"))
    (package
      (name "s-shell")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/rain-1/s")
               (commit commit)))
         (file-name (string-append name "-" version "-checkout"))
         (sha256
          (base32
           "0qiny71ww5nhzy4mnc8652hn0mlxyb67h333gbdxp4j4qxsi13q4"))))
      (build-system gnu-build-system)
      (inputs
       (list linenoise))
      (arguments
       `(#:tests? #f
         #:make-flags (list "CC=gcc"
                            (string-append "PREFIX="
                                           (assoc-ref %outputs "out")))
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'install-directory-fix
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (bin (string-append out "/bin")))
                 (substitute* "Makefile"
                   (("out") bin))
                 #t)))
           (add-after 'install 'manpage
             (lambda* (#:key outputs #:allow-other-keys)
               (install-file "s.1" (string-append (assoc-ref outputs "out")
                                                  "/share/man/man1"))))
           (replace 'configure
             (lambda* (#:key inputs outputs #:allow-other-keys)
               ;; At this point linenoise is meant to be included,
               ;; so we have to really copy it into the working directory
               ;; of s.
               (let* ((linenoise (assoc-ref inputs "linenoise"))
                      (noisepath (string-append linenoise "/include/linenoise"))
                      (out (assoc-ref outputs "out")))
                 (copy-recursively noisepath "linenoise")
                 (substitute* "s.c"
                   (("/bin/s") (string-append out "/bin/s")))
                 #t))))))
      (home-page "https://github.com/rain-1/s")
      (synopsis "Extremely minimal shell with the simplest syntax possible")
      (description
       "S is a new shell that aims to be extremely simple.  It does not
implement the POSIX shell standard.

There are no globs or \"splatting\" where a variable $FOO turns into multiple
command line arguments.  One token stays one token forever.
This is a \"no surprises\" straightforward approach.

There are no redirection operators > in the shell language, they are added as
extra programs.  > is just another unix command, < is essentially cat(1).
A @code{andglob} program is also provided along with s.")
      (license license:bsd-3))))

(define-public oksh
  (package
    (name "oksh")
    (version "0.5.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://connochaetos.org/oksh/oksh-"
                           version ".tar.gz"))
       (sha256
        (base32
         "0ln9yf6pxngsviqszv8klnnvn8vcpplvj1njdn8xr2y8frkbw8r3"))))
    (build-system gnu-build-system)
    (arguments
     `(; The test files are not part of the distributed tarball.
       #:tests? #f))
    (home-page "https://connochaetos.org/oksh")
    (synopsis "Port of OpenBSD Korn Shell")
    (description
     "Oksh is a port of the OpenBSD Korn Shell.
The OpenBSD Korn Shell is a cleaned up and enhanced ksh.")
    (license license:gpl3+)))

(define-public loksh
  (package
    (name "loksh")
    (version "7.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/dimkr/loksh")
                    (commit version)
                    ;; Include the ‘lolibc’ submodule, a static compatibility library
                    ;; created for and currently used only by loksh.
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0arbncmgs3wzkwlqzp5za8rwh9px2r5mn3i979rabc4cms1bs0l1"))))
    (build-system meson-build-system)
    (inputs (list ncurses))
    (native-inputs (list pkg-config))
    (arguments
     `(#:tests? #f)) ;no tests included
    (home-page "https://github.com/dimkr/loksh")
    (synopsis "Korn Shell from OpenBSD")
    (description
     "loksh is a Linux port of OpenBSD's @command{ksh}.  It is a small,
interactive POSIX shell targeted at resource-constrained systems.")
    ;; The file 'LEGAL' says it is the public domain, and the 2
    ;; exceptions which are listed are not included in this port.
    (license license:public-domain)))

(define-public mksh
  (package
    (name "mksh")
    (version "59c")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R"
                           version ".tgz"))
       (sha256
        (base32 "01n5ggw33bw4jv4d3148wlw9n4aj7vdn3ffnc66c9w9pldjidbkp"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; tests require access to /dev/tty
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'build
           (lambda _
             (setenv "CC" "gcc")
             (invoke (which "sh") "Build.sh")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (man (string-append out "/share/man/man1")))
               (install-file "mksh" bin)
               (with-directory-excursion bin
                 (symlink "mksh" "ksh"))
               (install-file "mksh.1" man)))))))
    (home-page "https://www.mirbsd.org/mksh.htm")
    (synopsis "Korn Shell from MirBSD")
    (description "mksh is an actively developed free implementation of the
Korn Shell programming language and a successor to the Public Domain Korn
Shell (pdksh).")
    (license (list license:miros
                   license:isc))))              ; strlcpy.c

(define-public oil
  (package
    (name "oil")
    (version "0.20.0")
    (source
     ;; oil's sources contain a modified version of CPython 2.7.13.
     ;; According to https://www.oilshell.org/blog/2017/05/05.html
     ;; this bundles version of CPython had certain unused parts removed
     ;; and its build system has been replaced by a custom one.
     ;; This would probably make it quite complicated to replace the
     ;; bundled CPython with the one from the python2 package.
     (origin
       (method url-fetch)
       (uri (string-append "https://www.oilshell.org/download/oil-"
                           version ".tar.gz"))
       (sha256
        (base32 "1jpxhixwq29ik01jx372g9acib59wmww8lrdlcypq7jpg5b0b7pi"))))
    (build-system gnu-build-system)
    (arguments
     (list #:strip-binaries? #f         ; strip breaks the binary
           #:phases
           #~(modify-phases %standard-phases
               (replace 'configure
                 (lambda _
                   (setenv "CC" #$(cc-for-target))
                   (substitute* "configure"
                     ((" cc ") " $CC "))
                   (invoke "./configure" (string-append "--prefix=" #$output)
                           "--with-readline")))
               (replace 'check
                 ;; The tests are not distributed in the tarballs but upstream
                 ;; recommends running this smoke test.
                 ;; https://github.com/oilshell/oil/blob/release/0.8.0/INSTALL.txt#L38-L48
                 (lambda* (#:key tests? #:allow-other-keys)
                   (when tests?
                     (let* ((oil "_bin/oil.ovm"))
                       (invoke/quiet oil "osh" "-c" "echo hi")
                       (invoke/quiet oil "osh" "-n" "configure"))))))))
    (inputs
     (list readline))
    (home-page "https://www.oilshell.org")
    (synopsis "Programming language and Bash-compatible Unix shell")
    (description "Oil is a programming language with automatic translation for
Bash.  It includes osh, a Unix/POSIX shell that runs unmodified Bash
scripts.")
    (license (list license:psfl                 ; tarball includes python2.7
                   license:asl2.0))))

(define-public gash
  (package
    (name "gash")
    (version "0.3.0")
    (source
     (origin (method url-fetch)
             (uri (string-append "mirror://savannah/gash/gash-"
                                 version ".tar.gz"))
             (sha256
              (base32
               "1af2jz4a6rzsshi379wzw4b8d04zvfamdhfzip2pgmk821lyqsjl"))))
    (build-system gnu-build-system)
    (native-inputs
     (list pkg-config))
    (inputs
     (list guile-3.0))
    (home-page "https://savannah.nongnu.org/projects/gash/")
    (synopsis "POSIX-compatible shell written in Guile Scheme")
    (description "Gash is a POSIX-compatible shell written in Guile
Scheme.  It provides both the shell interface, as well as a Guile
library for parsing shell scripts.  Gash is designed to bootstrap Bash
as part of the Guix bootstrap process.")
    (license license:gpl3+)))

(define-public gash-utils
  (package
    (name "gash-utils")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://savannah/gash/gash-utils-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "18ylb54l9lmaynapbncc1zhbsirhihznrxihhxgqrpqgyjkfbap6"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases #~(modify-phases %standard-phases
                  (add-after 'unpack 'skip-failing-tests
                    (lambda _
                      (substitute* "Makefile.am"
                        (("tests/sort\\.org") ""))
                      (for-each delete-file '("configure" "Makefile.in")))))))
    (native-inputs
     (list autoconf automake pkg-config))
    (inputs
     (list guile-3.0 gash))
    (home-page "https://savannah.nongnu.org/projects/gash/")
    (synopsis "Core POSIX utilities written in Guile Scheme")
    (description "Gash-Utils provides Scheme implementations of many
common POSIX utilities (there are about 40 of them, ranging in
complexity from @command{false} to @command{awk}).  The utilities are
designed to be capable of bootstrapping their standard GNU counterparts.
Underpinning these utilities are many Scheme interfaces for manipulating
files and text.")
    (license license:gpl3+)))

(define-public nushell
  (package
    (name "nushell")
    (version "0.44.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nushell/nushell")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "122jlc766v7rpfrz1jwi89sw6jmz7lfnhnr059fhy763fzcvph9c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:tests? #false                  ;missing files
       #:features '("extra")
       #:cargo-inputs
       (("rust-ctrlc" ,rust-ctrlc-3)
        ("rust-futures" ,rust-futures-0.3)
        ("rust-itertools" ,rust-itertools-0.10)
        ("rust-mp4" ,rust-mp4-0.9)
        ("rust-nu-cli" ,rust-nu-cli-0.44)
        ("rust-nu-command" ,rust-nu-command-0.44)
        ("rust-nu-completion" ,rust-nu-completion-0.44)
        ("rust-nu-data" ,rust-nu-data-0.44)
        ("rust-nu-engine" ,rust-nu-engine-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-parser" ,rust-nu-parser-0.44)
        ("rust-nu-path" ,rust-nu-path-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-value-ext" ,rust-nu-value-ext-0.44)
        ("rust-nu-plugin-binaryview" ,rust-nu-plugin-binaryview-0.44)
        ("rust-nu-plugin-chart" ,rust-nu-plugin-chart-0.44)
        ("rust-nu-plugin-from-bson" ,rust-nu-plugin-from-bson-0.44)
        ("rust-nu-plugin-from-sqlite" ,rust-nu-plugin-from-sqlite-0.44)
        ("rust-nu-plugin-inc" ,rust-nu-plugin-inc-0.44)
        ("rust-nu-plugin-match" ,rust-nu-plugin-match-0.44)
        ("rust-nu-plugin-query-json" ,rust-nu-plugin-query-json-0.44)
        ("rust-nu-plugin-s3" ,rust-nu-plugin-s3-0.44)
        ("rust-nu-plugin-selector" ,rust-nu-plugin-selector-0.44)
        ("rust-nu-plugin-start" ,rust-nu-plugin-start-0.44)
        ("rust-nu-plugin-textview" ,rust-nu-plugin-textview-0.44)
        ("rust-nu-plugin-to-bson" ,rust-nu-plugin-to-bson-0.44)
        ("rust-nu-plugin-to-sqlite" ,rust-nu-plugin-to-sqlite-0.44)
        ("rust-nu-plugin-tree" ,rust-nu-plugin-tree-0.44)
        ("rust-nu-plugin-xpath" ,rust-nu-plugin-xpath-0.44))
       #:cargo-development-inputs
       (("rust-hamcrest2" ,rust-hamcrest2-0.3)
        ("rust-nu-test-support" ,rust-nu-test-support-0.44)
        ("rust-rstest" ,rust-rstest-0.10)
        ("rust-serial-test" ,rust-serial-test-0.5))))
    (native-inputs
     (list pkg-config python))
    (inputs
     (list curl
           libgit2
           libx11
           libxcb
           openssl
           zlib))
    (home-page "https://www.nushell.sh")
    (synopsis "Shell with a structured approach to the command line")
    (description
     "Nu draws inspiration from projects like PowerShell, functional
programming languages, and modern CLI tools.  Rather than thinking of files
and services as raw streams of text, Nu looks at each input as something with
structure.  For example, when you list the contents of a directory, what you
get back is a table of rows, where each row represents an item in that
directory.  These values can be piped through a series of steps, in a series
of commands called a ``pipeline''.")
    (license license:expat)))

(define-public rust-nu-ansi-term-0.49
  (package
    (name "rust-nu-ansi-term")
    (version "0.49.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-ansi-term" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0s2svfnircd9jp06wk55qcbb9v5cadkfcjfg99vm21qdjg0x6wy0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-serde" ,rust-serde-1)
        ("rust-windows-sys" ,rust-windows-sys-0.48))
       #:cargo-development-inputs
       (("rust-doc-comment" ,rust-doc-comment-0.3)
        ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Library for ANSI terminal colors and styles (bold, underline)")
    (description
     "This package is a library for ANSI terminal colors and styles (bold,
underline).")
    (license license:expat)))

(define-public rust-nu-ansi-term-0.46
  (package
    (inherit rust-nu-ansi-term-0.49)
    (name "rust-nu-ansi-term")
    (version "0.46.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "nu-ansi-term" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32 "115sywxh53p190lyw97alm14nc004qj5jm5lvdj608z84rbida3p"))))
    (arguments
     `(#:cargo-inputs
       (("rust-overload" ,rust-overload-0.1)
        ("rust-serde" ,rust-serde-1)
        ("rust-winapi" ,rust-winapi-0.3))
       #:cargo-development-inputs
       (("rust-doc-comment" ,rust-doc-comment-0.3)
        ("rust-regex" ,rust-regex-1)
        ("rust-serde-json" ,rust-serde-json-1))))))

(define-public rust-nu-ansi-term-0.44
  (package
    (inherit rust-nu-ansi-term-0.49)
    (name "rust-nu-ansi-term")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-ansi-term" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1lmc9rdqnw586gv4a0c2gbg3x4a04fy65xk3fczby8lq84rz41i3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-doc-comment" ,rust-doc-comment-0.3)
        ("rust-overload" ,rust-overload-0.1)
        ("rust-serde" ,rust-serde-1)
        ("rust-winapi" ,rust-winapi-0.3))))))

(define-public rust-nu-cli-0.44
  (package
    (name "rust-nu-cli")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-cli" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0p085vgkzrczdz6ana9bb4r9hrcjm1hgr8f3885ik6kjlwiy5ixa"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-ctrlc" ,rust-ctrlc-3)
        ("rust-indexmap" ,rust-indexmap-1)
        ("rust-lazy-static" ,rust-lazy-static-1)
        ("rust-log" ,rust-log-0.4)
        ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.44)
        ("rust-nu-command" ,rust-nu-command-0.44)
        ("rust-nu-completion" ,rust-nu-completion-0.44)
        ("rust-nu-data" ,rust-nu-data-0.44)
        ("rust-nu-engine" ,rust-nu-engine-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-parser" ,rust-nu-parser-0.44)
        ("rust-nu-path" ,rust-nu-path-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-stream" ,rust-nu-stream-0.44)
        ("rust-pretty-env-logger" ,rust-pretty-env-logger-0.4)
        ("rust-rustyline" ,rust-rustyline-9)
        ("rust-serde" ,rust-serde-1)
        ("rust-serde-yaml" ,rust-serde-yaml-0.8)
        ("rust-shadow-rs" ,rust-shadow-rs-0.8)
        ("rust-shadow-rs" ,rust-shadow-rs-0.8)
        ("rust-strip-ansi-escapes" ,rust-strip-ansi-escapes-0.1))))
    (home-page "https://www.nushell.sh")
    (synopsis "CLI for nushell")
    (description "CLI for nushell")
    (license license:expat)))

(define-public rust-nu-command-0.44
  (package
    (name "rust-nu-command")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-command" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1h62df48z8vji10jsmpcfrgbr404kvsl1i3p5gns5gg9wscbpp8f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-base64" ,rust-base64-0.13)
        ("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-calamine" ,rust-calamine-0.18)
        ("rust-chrono" ,rust-chrono-0.4)
        ("rust-chrono-tz" ,rust-chrono-tz-0.5)
        ("rust-crossterm" ,rust-crossterm-0.19)
        ("rust-csv" ,rust-csv-1)
        ("rust-ctrlc" ,rust-ctrlc-3)
        ("rust-derive-new" ,rust-derive-new-0.5)
        ("rust-digest" ,rust-digest-0.9)
        ("rust-dirs-next" ,rust-dirs-next-2)
        ("rust-dtparse" ,rust-dtparse-1)
        ("rust-eml-parser" ,rust-eml-parser-0.1)
        ("rust-encoding-rs" ,rust-encoding-rs-0.8)
        ("rust-filesize" ,rust-filesize-0.2)
        ("rust-futures" ,rust-futures-0.3)
        ("rust-glob" ,rust-glob-0.3)
        ("rust-heck" ,rust-heck-0.4)
        ("rust-htmlescape" ,rust-htmlescape-0.3)
        ("rust-ical" ,rust-ical-0.7)
        ("rust-indexmap" ,rust-indexmap-1)
        ("rust-itertools" ,rust-itertools-0.10)
        ("rust-lazy-static" ,rust-lazy-static-1)
        ("rust-log" ,rust-log-0.4)
        ("rust-md-5" ,rust-md-5-0.9)
        ("rust-meval" ,rust-meval-0.2)
        ("rust-mime" ,rust-mime-0.3)
        ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.44)
        ("rust-nu-data" ,rust-nu-data-0.44)
        ("rust-nu-engine" ,rust-nu-engine-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-json" ,rust-nu-json-0.44)
        ("rust-nu-parser" ,rust-nu-parser-0.44)
        ("rust-nu-path" ,rust-nu-path-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-pretty-hex" ,rust-nu-pretty-hex-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-serde" ,rust-nu-serde-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-stream" ,rust-nu-stream-0.44)
        ("rust-nu-table" ,rust-nu-table-0.44)
        ("rust-nu-test-support" ,rust-nu-test-support-0.44)
        ("rust-nu-value-ext" ,rust-nu-value-ext-0.44)
        ("rust-num-bigint" ,rust-num-bigint-0.4)
        ("rust-num-format" ,rust-num-format-0.4)
        ("rust-num-traits" ,rust-num-traits-0.2)
        ("rust-parking-lot" ,rust-parking-lot-0.11)
        ("rust-polars" ,rust-polars-0.17)
        ("rust-quick-xml" ,rust-quick-xml-0.22)
        ("rust-quickcheck-macros" ,rust-quickcheck-macros-1)
        ("rust-rand" ,rust-rand-0.8)
        ("rust-regex" ,rust-regex-1)
        ("rust-reqwest" ,rust-reqwest-0.11)
        ("rust-roxmltree" ,rust-roxmltree-0.14)
        ("rust-rust-embed" ,rust-rust-embed-5)
        ("rust-rustyline" ,rust-rustyline-9)
        ("rust-serde" ,rust-serde-1)
        ("rust-serde-ini" ,rust-serde-ini-0.2)
        ("rust-serde-json" ,rust-serde-json-1)
        ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7)
        ("rust-serde-yaml" ,rust-serde-yaml-0.8)
        ("rust-sha2" ,rust-sha2-0.9)
        ("rust-shadow-rs" ,rust-shadow-rs-0.8)
        ("rust-strip-ansi-escapes" ,rust-strip-ansi-escapes-0.1)
        ("rust-sysinfo" ,rust-sysinfo-0.23)
        ("rust-term" ,rust-term-0.7)
        ("rust-term-size" ,rust-term-size-0.3)
        ("rust-thiserror" ,rust-thiserror-1)
        ("rust-titlecase" ,rust-titlecase-1)
        ("rust-tokio" ,rust-tokio-1)
        ("rust-toml" ,rust-toml-0.5)
        ("rust-trash" ,rust-trash-2)
        ("rust-umask" ,rust-umask-1)
        ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
        ("rust-url" ,rust-url-2)
        ("rust-users" ,rust-users-0.11)
        ("rust-uuid" ,rust-uuid-0.8)
        ("rust-which" ,rust-which-4)
        ("rust-zip" ,rust-zip-0.5))))
    (home-page "https://www.nushell.sh")
    (synopsis "CLI for nushell")
    (description "CLI for nushell")
    (license license:expat)))

(define-public rust-nu-completion-0.44
  (package
    (name "rust-nu-completion")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-completion" version))
       (file-name
        (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0pp3949cckivl57cqmcm5cc4pd6z8syyrbankk32vwlm0v4yly0q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-indexmap" ,rust-indexmap-1)
        ("rust-is-executable" ,rust-is-executable-1)
        ("rust-nu-data" ,rust-nu-data-0.44)
        ("rust-nu-engine" ,rust-nu-engine-0.44)
        ("rust-nu-parser" ,rust-nu-parser-0.44)
        ("rust-nu-path" ,rust-nu-path-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-test-support" ,rust-nu-test-support-0.44))))
    (home-page "https://www.nushell.sh")
    (synopsis "Completions for nushell")
    (description "Completions for nushell")
    (license license:expat)))

(define-public rust-nu-data-0.44
  (package
    (name "rust-nu-data")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-data" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kjyp63fr18rym2xvfqpyw4z0z1j8ckf2aszfk1a4z0pj64w6bi6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-byte-unit" ,rust-byte-unit-4)
        ("rust-chrono" ,rust-chrono-0.4)
        ("rust-common-path" ,rust-common-path-1)
        ("rust-derive-new" ,rust-derive-new-0.5)
        ("rust-directories-next" ,rust-directories-next-2)
        ("rust-getset" ,rust-getset-0.1)
        ("rust-indexmap" ,rust-indexmap-1)
        ("rust-log" ,rust-log-0.4)
        ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-path" ,rust-nu-path-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-table" ,rust-nu-table-0.44)
        ("rust-nu-test-support" ,rust-nu-test-support-0.44)
        ("rust-nu-value-ext" ,rust-nu-value-ext-0.44)
        ("rust-num-bigint" ,rust-num-bigint-0.4)
        ("rust-num-format" ,rust-num-format-0.4)
        ("rust-num-traits" ,rust-num-traits-0.2)
        ("rust-serde" ,rust-serde-1)
        ("rust-sha2" ,rust-sha2-0.9)
        ("rust-sys-locale" ,rust-sys-locale-0.1)
        ("rust-toml" ,rust-toml-0.5))))
    (home-page "https://www.nushell.sh")
    (synopsis "CLI for nushell")
    (description "CLI for nushell")
    (license license:expat)))

(define-public rust-nu-engine-0.44
  (package
    (name "rust-nu-engine")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-engine" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ry9x0ji4dikvd7vq4x9l1iqjwdhm80gcsvhfi7d0c26nvw8kpiz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-bytes" ,rust-bytes-1)
        ("rust-chrono" ,rust-chrono-0.4)
        ("rust-codespan-reporting" ,rust-codespan-reporting-0.11)
        ("rust-derive-new" ,rust-derive-new-0.5)
        ("rust-dirs-next" ,rust-dirs-next-2)
        ("rust-encoding-rs" ,rust-encoding-rs-0.8)
        ("rust-filesize" ,rust-filesize-0.2)
        ("rust-fs-extra" ,rust-fs-extra-1)
        ("rust-getset" ,rust-getset-0.1)
        ("rust-glob" ,rust-glob-0.3)
        ("rust-indexmap" ,rust-indexmap-1)
        ("rust-itertools" ,rust-itertools-0.10)
        ("rust-lazy-static" ,rust-lazy-static-1)
        ("rust-log" ,rust-log-0.4)
        ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.44)
        ("rust-nu-data" ,rust-nu-data-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-parser" ,rust-nu-parser-0.44)
        ("rust-nu-path" ,rust-nu-path-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-stream" ,rust-nu-stream-0.44)
        ("rust-nu-test-support" ,rust-nu-test-support-0.44)
        ("rust-nu-value-ext" ,rust-nu-value-ext-0.44)
        ("rust-num-bigint" ,rust-num-bigint-0.4)
        ("rust-parking-lot" ,rust-parking-lot-0.11)
        ("rust-rayon" ,rust-rayon-1)
        ("rust-serde" ,rust-serde-1)
        ("rust-serde-json" ,rust-serde-json-1)
        ("rust-tempfile" ,rust-tempfile-3)
        ("rust-term-size" ,rust-term-size-0.3)
        ("rust-termcolor" ,rust-termcolor-1)
        ("rust-trash" ,rust-trash-2)
        ("rust-umask" ,rust-umask-1)
        ("rust-users" ,rust-users-0.11)
        ("rust-which" ,rust-which-4))))
    (home-page "https://www.nushell.sh")
    (synopsis "Core commands for nushell")
    (description "Core commands for nushell")
    (license license:expat)))

(define-public rust-nu-errors-0.44
  (package
    (name "rust-nu-errors")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-errors" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cd5rkqlhgab6hb1q31xqbrb0j9wbmwzp9z20rrsc59s5zajiivq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-codespan-reporting" ,rust-codespan-reporting-0.11)
        ("rust-derive-new" ,rust-derive-new-0.5)
        ("rust-getset" ,rust-getset-0.1)
        ("rust-glob" ,rust-glob-0.3)
        ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-num-bigint" ,rust-num-bigint-0.4)
        ("rust-num-traits" ,rust-num-traits-0.2)
        ("rust-serde" ,rust-serde-1)
        ("rust-serde-json" ,rust-serde-json-1)
        ("rust-serde-yaml" ,rust-serde-yaml-0.8)
        ("rust-toml" ,rust-toml-0.5))))
    (home-page "https://www.nushell.sh")
    (synopsis "Core error subsystem for Nushell")
    (description "Core error subsystem for Nushell")
    (license license:expat)))

(define-public rust-nu-json-0.44
  (package
    (name "rust-nu-json")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-json" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vdp2brhiyvrkqd1127cixwdcqqmbhf7qha4jyx1ki4hh7w86l0b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-lazy-static" ,rust-lazy-static-1)
        ("rust-linked-hash-map" ,rust-linked-hash-map-0.5)
        ("rust-num-traits" ,rust-num-traits-0.2)
        ("rust-regex" ,rust-regex-1)
        ("rust-serde" ,rust-serde-1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Fork of @code{serde-hjson}")
    (description "This package is a fork of @code{serde-hjson}.")
    (license license:expat)))

(define-public rust-nu-parser-0.44
  (package
    (name "rust-nu-parser")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1n4223kb9gnwmfhn4als68y1b2niw2zkl8wkra8622gm7p116xq6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-derive-new" ,rust-derive-new-0.5)
        ("rust-indexmap" ,rust-indexmap-1)
        ("rust-itertools" ,rust-itertools-0.10)
        ("rust-log" ,rust-log-0.4)
        ("rust-nu-data" ,rust-nu-data-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-path" ,rust-nu-path-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-test-support" ,rust-nu-test-support-0.44)
        ("rust-num-bigint" ,rust-num-bigint-0.4)
        ("rust-smart-default" ,rust-smart-default-0.6))))
    (home-page "https://www.nushell.sh")
    (synopsis "Nushell parser")
    (description "Nushell parser")
    (license license:expat)))

(define-public rust-nu-path-0.44
  (package
    (name "rust-nu-path")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-path" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "069df6ikkaimcr1pjiycfr3ma6sjmb4ajmyxqdckckaqx4nj5wqk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-dirs-next" ,rust-dirs-next-2) ("rust-dunce" ,rust-dunce-1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Nushell parser")
    (description "Nushell parser")
    (license license:expat)))

(define-public rust-nu-plugin-0.44
  (package
    (name "rust-nu-plugin")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-plugin" version))
       (file-name
        (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vs4f84krf859j9f9rqzggzq3i49gb84928l22ddshdsspynckmj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-indexmap" ,rust-indexmap-1)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-test-support" ,rust-nu-test-support-0.44)
        ("rust-nu-value-ext" ,rust-nu-value-ext-0.44)
        ("rust-serde" ,rust-serde-1)
        ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Nushell Plugin")
    (description "Nushell Plugin")
    (license license:expat)))

(define-public rust-nu-plugin-binaryview-0.44
  (package
    (name "rust-nu-plugin-binaryview")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_binaryview" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zk49hfp21akf6x7ml4b3h61y7jrj5i03zdmikci981idqm2fivm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-crossterm" ,rust-crossterm-0.19)
        ("rust-image" ,rust-image-0.23)
        ("rust-neso" ,rust-neso-0.5)
        ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-pretty-hex" ,rust-nu-pretty-hex-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-rawkey" ,rust-rawkey-0.1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Binary viewer plugin for Nushell")
    (description
     "This package provides a binary viewer plugin for Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-chart-0.44
  (package
    (name "rust-nu-plugin-chart")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_chart" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "05nv8c1650w8bh71s7yl35ybbjky6b4vdwkw0ywanhm1nqziva7s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-crossterm" ,rust-crossterm-0.19)
        ("rust-nu-data" ,rust-nu-data-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-value-ext" ,rust-nu-value-ext-0.44)
        ("rust-tui" ,rust-tui-0.15))))
    (home-page "https://www.nushell.sh")
    (synopsis "Plugin to display charts")
    (description
     "This package provides a plugin to display charts in Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-from-bson-0.44
  (package
    (name "rust-nu-plugin-from-bson")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_from_bson" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hmkqiqyqiin80fmlb31r6dgpif8r9nlda4w8ihzjflsbxnmp6wd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-bson" ,rust-bson-2)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44))))
    (home-page "https://www.nushell.sh")
    (synopsis "Converter plugin to the bson format for Nushell")
    (description
     "This package provides a converter plugin to the bson format for
Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-from-sqlite-0.44
  (package
    (name "rust-nu-plugin-from-sqlite")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_from_sqlite" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11dirmm78n6jwsq8qihx3sbjfa0j7s9ffl1j03v8f4zzfvsypxxb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-rusqlite" ,rust-rusqlite-0.26)
        ("rust-tempfile" ,rust-tempfile-3))))
    (home-page "https://www.nushell.sh")
    (synopsis "Converter plugin to the bson format for Nushell")
    (description
     "This package provides a converter plugin to the bson format for
Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-inc-0.44
  (package
    (name "rust-nu-plugin-inc")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_inc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gyj54ip1nl68rav3h78sjljh826cp71khmjsbsvyphhgdm1kbhw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-test-support" ,rust-nu-test-support-0.44)
        ("rust-nu-value-ext" ,rust-nu-value-ext-0.44)
        ("rust-semver" ,rust-semver-0.11))))
    (home-page "https://www.nushell.sh")
    (synopsis "Version incrementer plugin for Nushell")
    (description
     "This package provides a version incrementer plugin for
Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-match-0.44
  (package
    (name "rust-nu-plugin-match")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_match" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hbs9h28qwwd8i3rb2klx2xmgcxs6l92x9dbmjx3bl85wmjk2skm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-regex" ,rust-regex-1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Regex match plugin for Nushell")
    (description
     "This package provides a regex match plugin for Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-query-json-0.44
  (package
    (name "rust-nu-plugin-query-json")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_query_json" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1yzcgm8sqzgr55hdcpzqrdfjc0yhz95qqpxyscm8cm6xw59ib0z2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-gjson" ,rust-gjson-0.8)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44))))
    (home-page "https://www.nushell.sh")
    (synopsis "Query JSON files with Gjson")
    (description "query json files with gjson")
    (license license:expat)))

(define-public rust-nu-plugin-s3-0.44
  (package
    (name "rust-nu-plugin-s3")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_s3" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ims4p3z48ja8ygkhcbq1a506hp8ry3ipdpgv9j7iqi833g0vgjl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-futures" ,rust-futures-0.3)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-s3handler" ,rust-s3handler-0.7))))
    (home-page "https://www.nushell.sh")
    (synopsis "S3 plugin for Nushell")
    (description "This package is an S3 plugin for Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-selector-0.44
  (package
    (name "rust-nu-plugin-selector")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_selector" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ni51yr1vndjf7c9qmvrc23nn3csv5jy14bwd8kxd5b7648aidsy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-scraper" ,rust-scraper-0.12))))
    (home-page "https://www.nushell.sh")
    (synopsis "Web scraping using CSS selector")
    (description
     "This package provides web scraping using CSS selector.")
    (license license:expat)))

(define-public rust-nu-plugin-start-0.44
  (package
    (name "rust-nu-plugin-start")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_start" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "028pb15y5dyywc84h79kdf0hz9l1m37djly8jhrcbj6v55x3k9h6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-glob" ,rust-glob-0.3)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-open" ,rust-open-1)
        ("rust-url" ,rust-url-2)
        ("rust-webbrowser" ,rust-webbrowser-0.5))))
    (home-page "https://www.nushell.sh")
    (synopsis "Plugin to open files/URLs directly from Nushell")
    (description
     "This package provides a plugin to open files/URLs directly from
Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-textview-0.44
  (package
    (name "rust-nu-plugin-textview")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_textview" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17amhjvx1jfdz98jiavhnn18263f3hg3is7x0rkdzddng0abzpc7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bat" ,rust-bat-0.18)
        ("rust-nu-data" ,rust-nu-data-0.44)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-term-size" ,rust-term-size-0.3)
        ("rust-url" ,rust-url-2))))
    (home-page "https://www.nushell.sh")
    (synopsis "Text viewer plugin for Nushell")
    (description "This package provides a text viewer plugin for
Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-to-bson-0.44
  (package
    (name "rust-nu-plugin-to-bson")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_to_bson" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "003x90qshcn7yv86zaw449akqvi4vz78s05g0qcgrfxgvpn7vdch"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bson" ,rust-bson-2)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://www.nushell.sh")
    (synopsis "Converter plugin to the bson format for Nushell")
    (description
     "This package provides a converter plugin to the bson format for
Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-to-sqlite-0.44
  (package
    (name "rust-nu-plugin-to-sqlite")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_to_sqlite" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "06d93a5xgssvxrbvcv12b9jwh9xwl6sz6admbpxnk9r78lpgfdaj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-hex" ,rust-hex-0.4)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-rusqlite" ,rust-rusqlite-0.26)
        ("rust-tempfile" ,rust-tempfile-3))))
    (home-page "https://www.nushell.sh")
    (synopsis "Converter plugin to the bson format for Nushell")
    (description
     "This package provides a converter plugin to the bson format for
Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-tree-0.44
  (package
    (name "rust-nu-plugin-tree")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_tree" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "089mp7spa0fcxm45njmjcab685cv30jb0b3kkgvjp8ywwakyy8lb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-derive-new" ,rust-derive-new-0.5)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-ptree" ,rust-ptree-0.4))))
    (home-page "https://www.nushell.sh")
    (synopsis "Tree viewer plugin for Nushell")
    (description "This package provides a tree viewer plugin for
Nushell.")
    (license license:expat)))

(define-public rust-nu-plugin-xpath-0.44
  (package
    (name "rust-nu-plugin-xpath")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu_plugin_xpath" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18qbhibn9pz9hnilqzv2g1s51fmlwpm60ma2r6qjsa5pcy9x12dh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-indexmap" ,rust-indexmap-1)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-plugin" ,rust-nu-plugin-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-sxd-document" ,rust-sxd-document-0.3)
        ("rust-sxd-xpath" ,rust-sxd-xpath-0.4))))
    (home-page "https://www.nushell.sh")
    (synopsis "Traverses XML")
    (description "Traverses XML")
    (license license:expat)))

(define-public rust-nu-pretty-hex-0.44
  (package
    (name "rust-nu-pretty-hex")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-pretty-hex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dizakbxm2c6vpjy5brqbjhk8m7lr7wammibb1vr8nq85aazrj5r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-heapless" ,rust-heapless-0.7)
        ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.44)
        ("rust-rand" ,rust-rand-0.8))))
    (home-page "https://www.nushell.sh")
    (synopsis "Pretty hex dump of bytes slice in the common style")
    (description
     "This crate provides pretty hex dump of bytes slice in the common
style.")
    (license license:expat)))

(define-public rust-nu-protocol-0.44
  (package
    (name "rust-nu-protocol")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-protocol" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1r6cnrqsq3qx3132w0p78262vql1bk446ynnfjsiffd07rmba2f7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-byte-unit" ,rust-byte-unit-4)
        ("rust-chrono" ,rust-chrono-0.4)
        ("rust-chrono-humanize" ,rust-chrono-humanize-0.2)
        ("rust-derive-new" ,rust-derive-new-0.5)
        ("rust-getset" ,rust-getset-0.1)
        ("rust-indexmap" ,rust-indexmap-1)
        ("rust-log" ,rust-log-0.4)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-num-bigint" ,rust-num-bigint-0.4)
        ("rust-num-integer" ,rust-num-integer-0.1)
        ("rust-num-traits" ,rust-num-traits-0.2)
        ("rust-polars" ,rust-polars-0.17)
        ("rust-serde" ,rust-serde-1)
        ("rust-serde-bytes" ,rust-serde-bytes-0.11))))
    (home-page "https://www.nushell.sh")
    (synopsis "Core values and protocols for Nushell")
    (description "Core values and protocols for Nushell")
    (license license:expat)))

(define-public rust-nu-serde-0.44
  (package
    (name "rust-nu-serde")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-serde" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "190lid6jqgrb50qzqk849hg44rcn392qbppdm8zhgy732fsjb2j4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-insta" ,rust-insta-1)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-serde" ,rust-serde-1)
        ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Turn any value into a @code{nu-protocol::Value} with Serde")
    (description
     "This crate turns any value into a @code{nu-protocol::Value} with
Serde.")
    (license license:expat)))

(define-public rust-nu-source-0.44
  (package
    (name "rust-nu-source")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-source" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04w4s4yk5byy5mmrhvcbcvf179vjmb9pa2jch5vgl6rckipzd31l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-derive-new" ,rust-derive-new-0.5)
        ("rust-getset" ,rust-getset-0.1)
        ("rust-pretty" ,rust-pretty-0.5)
        ("rust-serde" ,rust-serde-1)
        ("rust-termcolor" ,rust-termcolor-1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Source string characterizer for Nushell")
    (description
     "This package provides a source string characterizer for
Nushell.")
    (license license:expat)))

(define-public rust-nu-stream-0.44
  (package
    (name "rust-nu-stream")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-stream" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14fs2dqa4papd48zil35901z4sc0p15dga96jbrsbhimk85g0gba"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44))))
    (home-page "https://www.nushell.sh")
    (synopsis "Nushell stream")
    (description "This package provides Nushell stream.")
    (license license:expat)))

(define-public rust-nu-table-0.44
  (package
    (name "rust-nu-table")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-table" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lk2cr8k0wbh5ya42ldz129yzfpqibzvjqy1bkpccfh2lf9n01g2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-atty" ,rust-atty-0.2)
        ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.44)
        ("rust-regex" ,rust-regex-1)
        ("rust-strip-ansi-escapes" ,rust-strip-ansi-escapes-0.1)
        ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://www.nushell.sh")
    (synopsis "Nushell table printing")
    (description "Nushell table printing")
    (license license:expat)))

(define-public rust-nu-test-support-0.44
  (package
    (name "rust-nu-test-support")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-test-support" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fjaczf05lzs77f1chif11085xy2yklw2lzl0vz0sdzzkll1r374"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-bigdecimal" ,rust-bigdecimal-0.3)
        ("rust-chrono" ,rust-chrono-0.4)
        ("rust-getset" ,rust-getset-0.1)
        ("rust-glob" ,rust-glob-0.3)
        ("rust-hamcrest2" ,rust-hamcrest2-0.3)
        ("rust-indexmap" ,rust-indexmap-1)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-path" ,rust-nu-path-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-num-bigint" ,rust-num-bigint-0.4)
        ("rust-tempfile" ,rust-tempfile-3))))
    (home-page "https://www.nushell.sh")
    (synopsis "Support for writing Nushell tests")
    (description "This package provides support for writing Nushell
tests.")
    (license license:expat)))

(define-public rust-nu-value-ext-0.44
  (package
    (name "rust-nu-value-ext")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-value-ext" version))
       (file-name
        (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ag5y6qfj53w6skyb0vhwhxiykvpmz5izpgxnbz5r0i0bdscrmdy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs
       (("rust-indexmap" ,rust-indexmap-1)
        ("rust-itertools" ,rust-itertools-0.10)
        ("rust-nu-errors" ,rust-nu-errors-0.44)
        ("rust-nu-protocol" ,rust-nu-protocol-0.44)
        ("rust-nu-source" ,rust-nu-source-0.44)
        ("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://www.nushell.sh")
    (synopsis "@code{Extension} traits for values in Nushell")
    (description
     "This package provides @code{Extension} traits for values in
Nushell.")
    (license license:expat)))
