;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2017, 2018, 2023 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2021 Ludovic Courtès <ludo@gnu.org>
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

(define-module (guix build-system minify)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix search-paths)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:export (%minify-build-system-modules
            minify-build
            minify-build-system))

;; Commentary:
;;
;; Standard minification procedure for JavaScript files.
;;
;; Code:

(define %minify-build-system-modules
  ;; Build-side modules imported by default.
  `((guix build minify-build-system)
    ,@%default-gnu-imported-modules))

(define (default-esbuild)
  "Return the default package to minify JavaScript source files."
  ;; Lazily resolve the binding to avoid a circular dependency.
  (let ((mod (resolve-interface '(gnu packages web))))
    (module-ref mod 'esbuild)))

(define* (lower name
                #:key source inputs native-inputs outputs system
                (esbuild (default-esbuild))
                #:allow-other-keys
                #:rest arguments)
  "Return a bag for NAME."
  (define private-keywords
    '(#:target #:inputs #:native-inputs))

  (bag
    (name name)
    (system system)
    (host-inputs `(,@(if source
                         `(("source" ,source))
                         '())
                   ,@inputs
                   ,@(standard-packages)))
    (build-inputs `(("esbuild" ,esbuild)
                    ,@native-inputs))
    (outputs outputs)
    (build minify-build)
    (arguments (strip-keyword-arguments private-keywords arguments))))

(define* (minify-build name inputs
                       #:key
                       source
                       (javascript-files #f)
                       (phases '%standard-phases)
                       (outputs '("out"))
                       (system (%current-system))
                       search-paths
                       (guile #f)
                       (imported-modules %minify-build-system-modules)
                       (modules '((guix build minify-build-system)
                                  (guix build utils))))
  "Build SOURCE with INPUTS."
  (define builder
    (with-imported-modules imported-modules
      #~(begin
          (use-modules #$@(sexp->gexp modules))
          (minify-build #:name #$name
                        #:source #+source
                        #:javascript-files #$javascript-files
                        #:phases #$phases
                        #:outputs #$(outputs->gexp outputs)
                        #:search-paths '#$(sexp->gexp
                                           (map search-path-specification->sexp
                                                search-paths))
                        #:inputs #$(input-tuples->gexp inputs)))))

  (mlet %store-monad ((guile (package->derivation (or guile (default-guile))
                                                  system #:graft? #f)))
    (gexp->derivation name builder
                      #:system system
                      #:guile-for-build guile)))

(define minify-build-system
  (build-system
    (name 'minify)
    (description "The trivial JavaScript minification build system")
    (lower lower)))

;;; minify.scm ends here
