;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013-2017, 2021-2022 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2013 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2013 Nikita Karetnikov <nikita@karetnikov.org>
;;; Copyright © 2021 Lars-Dominik Braun <lars@6xq.net>
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

(define-module (guix build-system python)
  #:use-module ((gnu packages) #:select (search-auxiliary-file))
  #:use-module (guix gexp)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix packages)
  #:use-module (guix derivations)
  #:use-module (guix search-paths)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (srfi srfi-1)
  #:export (%python-build-system-modules
            package-with-python2
            strip-python2-variant
            default-python
            default-python2
            python-build
            python-build-system
            pypi-uri))

;; Commentary:
;;
;; Standard build procedure for Python packages using 'setup.py'.  This is
;; implemented as an extension of 'gnu-build-system'.
;;
;; Code:

(define* (pypi-uri name version #:optional (extension ".tar.gz"))
  "Return a URI string for the Python package hosted on the Python Package
Index (PyPI) corresponding to NAME and VERSION.  EXTENSION is the file name
extension, such as '.tar.gz'."
  (string-append "https://files.pythonhosted.org/packages/source/"
                 (string-take name 1) "/" name "/"
                 name "-" version extension))

(define %python-build-system-modules
  ;; Build-side modules imported by default.
  `((guix build python-build-system)
    ,@%default-gnu-imported-modules))

(define (default-python)
  "Return the default Python package."
  ;; Lazily resolve the binding to avoid a circular dependency.
  (let ((python (resolve-interface '(gnu packages python))))
    (module-ref python 'python-wrapper)))

(define (default-python2)
  "Return the default Python 2 package."
  (let ((python (resolve-interface '(gnu packages python))))
    (module-ref python 'python-2)))

(define sanity-check.py
  ;; The script used to validate the installation of a Python package.
  (search-auxiliary-file "python/sanity-check.py"))

(define* (package-with-explicit-python python old-prefix new-prefix
                                       #:key variant-property)
  "Return a procedure of one argument, P.  The procedure creates a package with
the same fields as P, which is assumed to use PYTHON-BUILD-SYSTEM, such that
it is compiled with PYTHON instead.  The inputs are changed recursively
accordingly.  If the name of P starts with OLD-PREFIX, this is replaced by
NEW-PREFIX; otherwise, NEW-PREFIX is prepended to the name.

When VARIANT-PROPERTY is present, it is used as a key to search for
pre-defined variants of this transformation recorded in the 'properties' field
of packages.  The property value must be the promise of a package.  This is a
convenient way for package writers to force the transformation to use
pre-defined variants."
  (define package-variant
    (if variant-property
        (lambda (package)
          (assq-ref (package-properties package)
                    variant-property))
        (const #f)))

  (define (transform p)
    (cond
     ;; If VARIANT-PROPERTY is present, use that.
     ((package-variant p)
      => force)

     ;; Otherwise build the new package object graph.
     ((eq? (package-build-system p) python-build-system)
      (package/inherit p
        (location (package-location p))
        (name (let ((name (package-name p)))
                (string-append new-prefix
                               (if (string-prefix? old-prefix name)
                                   (substring name
                                              (string-length old-prefix))
                                   name))))
        (arguments
         (let ((python (if (promise? python)
                           (force python)
                           python)))
           (ensure-keyword-arguments (package-arguments p)
                                     `(#:python ,python))))))
     (else p)))

  (define (cut? p)
    (or (not (eq? (package-build-system p) python-build-system))
        (package-variant p)))

  (package-mapping transform cut?))

(define package-with-python2
  ;; Note: delay call to 'default-python2' until after the 'arguments' field
  ;; of packages is accessed to avoid a circular dependency when evaluating
  ;; the top-level of (gnu packages python).
  (package-with-explicit-python (delay (default-python2))
                                "python-" "python2-"
                                #:variant-property 'python2-variant))

(define (strip-python2-variant p)
  "Remove the 'python2-variant' property from P."
  (package/inherit p
    (properties (alist-delete 'python2-variant (package-properties p)))))

(define* (lower name
                #:key source inputs native-inputs outputs system target
                (python (default-python))
                #:allow-other-keys
                #:rest arguments)
  "Return a bag for NAME."
  (define private-keywords
    '(#:target #:python #:inputs #:native-inputs))

  (and (not target)                               ;XXX: no cross-compilation
       (bag
         (name name)
         (system system)
         (host-inputs `(,@(if source
                              `(("source" ,source))
                              '())
                        ,@inputs

                        ;; Keep the standard inputs of 'gnu-build-system'.
                        ,@(standard-packages)))
         (build-inputs `(("python" ,python)
                         ("sanity-check.py" ,(local-file sanity-check.py))
                         ,@native-inputs))
         (outputs outputs)
         (build python-build)
         (arguments (strip-keyword-arguments private-keywords arguments)))))

(define* (python-build name inputs
                       #:key source
                       (tests? #t)
                       (test-target "test")
                       (use-setuptools? #t)
                       (configure-flags ''())
                       (phases '%standard-phases)
                       (outputs '("out"))
                       (search-paths '())
                       (system (%current-system))
                       (guile #f)
                       (imported-modules %python-build-system-modules)
                       (modules '((guix build python-build-system)
                                  (guix build utils)))
                       allowed-references
                       disallowed-references)
  "Build SOURCE using PYTHON, and with INPUTS.  This assumes that SOURCE
provides a 'setup.py' file as its build system."
  (define build
    (with-imported-modules imported-modules
      #~(begin
          (use-modules #$@(sexp->gexp modules))

          #$(with-build-variables inputs outputs
              #~(python-build #:name #$name
                              #:source #+source
                              #:configure-flags #$configure-flags
                              #:use-setuptools? #$use-setuptools?
                              #:system #$system
                              #:test-target #$test-target
                              #:tests? #$tests?
                              #:phases #$(if (pair? phases)
                                             (sexp->gexp phases)
                                             phases)
                              #:outputs %outputs
                              #:search-paths '#$(sexp->gexp
                                                 (map search-path-specification->sexp
                                                      search-paths))
                              #:inputs %build-inputs)))))

  (mlet %store-monad ((guile (package->derivation (or guile (default-guile))
                                                  system #:graft? #f)))
    (gexp->derivation name build
                      #:system system
                      #:graft? #f                 ;consistent with 'gnu-build'
                      #:target #f
                      #:guile-for-build guile
                      #:allowed-references allowed-references
                      #:disallowed-references disallowed-references)))

(define python-build-system
  (build-system
    (name 'python)
    (description "The standard Python build system")
    (lower lower)))

;;; python.scm ends here
