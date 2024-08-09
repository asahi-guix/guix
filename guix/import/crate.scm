;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016 David Craven <david@craven.ch>
;;; Copyright © 2019, 2020, 2021 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2019, 2020 Martin Becze <mjbecze@riseup.net>
;;; Copyright © 2021 Nicolas Goaziou <mail@nicolasgoaziou.fr>
;;; Copyright © 2021 Sarah Morgensen <iskarian@mgsn.dev>
;;; Copyright © 2022 Hartmut Goebel <h.goebel@crazy-compilers.com>
;;; Copyright © 2023 Simon Tournier <zimon.toutoune@gmail.com>
;;; Copyright © 2023, 2024 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2023, 2024 David Elsing <david.elsing@posteo.net>
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

(define-module (guix import crate)
  #:use-module (guix base32)
  #:use-module (guix build-system cargo)
  #:use-module (guix diagnostics)
  #:use-module (gcrypt hash)
  #:use-module (guix http-client)
  #:use-module (guix i18n)
  #:use-module (guix import json)
  #:use-module (guix import utils)
  #:use-module (guix memoization)
  #:use-module (guix packages)
  #:use-module (guix read-print)
  #:use-module (guix upstream)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (json)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-2)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-69)
  #:use-module (srfi srfi-71)
  #:export (crate->guix-package
            guix-package->crate-name
            string->license
            crate-recursive-import
            %crate-updater))


;;;
;;; Interface to https://crates.io/api/v1.
;;;

;; Crates.  A crate is essentially a "package".  It can have several
;; "versions", each of which has its own set of dependencies, license,
;; etc.--see <crate-version> below.
(define-json-mapping <crate> make-crate crate?
  json->crate
  (name          crate-name)                      ;string
  (latest-version crate-latest-version "max_version") ;string
  (home-page     crate-home-page "homepage")      ;string | #nil
  (repository    crate-repository)                ;string
  (description   crate-description)               ;string
  (keywords      crate-keywords                   ;list of strings
                 "keywords" vector->list)
  (categories    crate-categories                 ;list of strings
                 "categories" vector->list)
  (versions      crate-versions "actual_versions" ;list of <crate-version>
                 (lambda (vector)
                   (map json->crate-version
                        (vector->list vector))))
  (links         crate-links))                    ;alist

;; Crate version.
(define-json-mapping <crate-version> make-crate-version crate-version?
  json->crate-version
  (id            crate-version-id)                ;integer
  (number        crate-version-number "num")      ;string
  (download-path crate-version-download-path "dl_path") ;string
  (readme-path   crate-version-readme-path "readme_path") ;string
  (license       crate-version-license "license"  ;string | #f
                 (match-lambda
                   ('null #f)
                   ((? string? str) str)))
  (yanked?       crate-version-yanked? "yanked")  ;boolean
  (links         crate-version-links))            ;alist

;; Crate dependency.  Each dependency (each edge in the graph) is annotated as
;; being a "normal" dependency or a development dependency.  There also
;; information about the minimum required version, such as "^0.0.41".
(define-json-mapping <crate-dependency> make-crate-dependency
  crate-dependency?
  json->crate-dependency
  (id            crate-dependency-id "crate_id")  ;string
  (kind          crate-dependency-kind "kind"     ;'normal | 'dev | 'build
                 string->symbol)
  (requirement   crate-dependency-requirement "req")) ;string

;; Autoload Guile-Semver so we only have a soft dependency.
(module-autoload! (current-module)
		  '(semver) '(string->semver semver->string semver<? semver=? semver>?))
(module-autoload! (current-module)
		  '(semver ranges) '(string->semver-range semver-range-contains?))

(define (lookup-crate name)
  "Look up NAME on https://crates.io and return the corresopnding <crate>
record or #f if it was not found."
  (let ((json (json-fetch (string-append (%crate-base-url) "/api/v1/crates/"
                                         name))))
    (and=> (and json (assoc-ref json "crate"))
           (lambda (alist)
             ;; The "versions" field of ALIST is simply a list of version IDs
             ;; (integers).  Here, we squeeze in the actual version
             ;; dictionaries that are not part of ALIST but are just more
             ;; convenient handled this way.
             (let ((versions (or (assoc-ref json "versions") '#())))
               (json->crate `(,@alist
                              ("actual_versions" . ,versions))))))))

(define lookup-crate* (memoize lookup-crate))

(define (crate-version-dependencies version)
  "Return the list of <crate-dependency> records of VERSION, a
<crate-version>."
  (let* ((path (assoc-ref (crate-version-links version) "dependencies"))
         (url  (string-append (%crate-base-url) path)))
    (match (assoc-ref (or (json-fetch url) '()) "dependencies")
      ((? vector? vector)
       (delete-duplicates (map json->crate-dependency (vector->list vector))))
      (_
       '()))))


;;;
;;; Converting crates to Guix packages.
;;;

(define* (package-names->package-inputs names #:optional (output #f))
  "Given a list of PACKAGE-NAMES or (PACKAGE-NAME VERSION) pairs, and an
optional OUTPUT, tries to generate a quoted list of inputs, as suitable to
use in an 'inputs' field of a package definition."
  (define (make-input input version)
    (cons* input (list 'unquote (string->symbol
                                 (if version
                                     (string-append input "-" version)
                                     input)))
           (or (and output (list output))
               '())))

  (map (match-lambda
         ((input version) (make-input input version))
         (input (make-input input #f)))
       names))

(define (maybe-cargo-inputs package-names)
  (match (package-names->package-inputs package-names)
    (()
     '())
    ((package-inputs ...)
     `(#:cargo-inputs (,'unquote (list ,@package-inputs))))))

(define (maybe-cargo-development-inputs package-names)
  (match (package-names->package-inputs package-names)
    (()
     '())
    ((package-inputs ...)
     `(#:cargo-development-inputs (,'unquote (list ,@package-inputs))))))

(define (maybe-arguments arguments)
  (match arguments
    (()
     '())
    ((args ...)
     `((arguments (,'quasiquote ,args))))))

(define (version->semver-prefix version)
  "Return the version up to and including the first non-zero part"
  (first
   (map match:substring
        (list-matches "^(0+\\.){,2}[0-9]+" version))))

(define* (make-crate-sexp #:key name version cargo-inputs cargo-development-inputs
                          home-page synopsis description license build? yanked?)
  "Return the `package' s-expression for a rust package with the given NAME,
VERSION, CARGO-INPUTS, CARGO-DEVELOPMENT-INPUTS, HOME-PAGE, SYNOPSIS, DESCRIPTION,
and LICENSE."
  (define (format-inputs inputs)
    (map
     (match-lambda
      ((name version yanked)
       (list (crate-name->package-name name)
             (if yanked
                 (string-append version "-yanked")
                 (version->semver-prefix version)))))
     inputs))

  (let* ((port (http-fetch (crate-uri name version)))
         (guix-name (crate-name->package-name name))
         (cargo-inputs (format-inputs cargo-inputs))
         (cargo-development-inputs (format-inputs cargo-development-inputs))
         (description (beautify-description description))
         (pkg `(package
                   (name ,guix-name)
                   (version ,version)
                   ,@(if yanked?
                         `(,(comment "; This version was yanked!\n" #t))
                         '())
                   (source (origin
                             (method url-fetch)
                             (uri (crate-uri ,name version))
                             (file-name (string-append name "-" version ".tar.gz"))
                             (sha256
                              (base32
                               ,(bytevector->nix-base32-string (port-sha256 port))))))
                   ,@(if yanked?
                         `((properties '((crate-version-yanked? . #t))))
                         '())
                   (build-system cargo-build-system)
                   ,@(maybe-arguments (append (if build?
                                                 '()
                                                 '(#:skip-build? #t))
                                              (maybe-cargo-inputs cargo-inputs)
                                              (maybe-cargo-development-inputs
                                                cargo-development-inputs)))
                   (home-page ,home-page)
                   (synopsis ,(beautify-synopsis synopsis))
                   (description ,(if (string-prefix? "This" description)
                                     description
                                     (string-append "This package provides "
                                                    description)))
                   (license ,(match license
                               (() #f)
                               (#f #f)
                               ((license) license)
                               (_ `(list ,@license)))))))
         (close-port port)
         (package->definition pkg
                              (if yanked?
                                  (string-append version "-yanked")
                                  (version->semver-prefix version)))))

(define (string->license string)
  (filter-map (lambda (license)
                (and (not (string-null? license))
                     (not (any (lambda (elem) (string=? elem license))
                               '("AND" "OR" "WITH")))
                     (or (spdx-string->license license)
                         'unknown-license!)))
              (string-split string (string->char-set " /"))))

(define (min-element l less)
  "Returns the smallest element of l according to less or #f if l is empty."

  (let loop ((curr #f)
             (remaining l))
    (if (null-list? remaining)
        curr
        (let ((next (car remaining))
              (remaining (cdr remaining)))
          (if (and curr
                   (not (less next curr)))
              (loop curr remaining)
              (loop next remaining))))))

(define (max-crate-version-of-semver semver-range range)
  "Returns a <crate-version> of the highest version within the semver range."

  (define (crate->semver crate)
    (string->semver (crate-version-number crate)))

  (min-element
   (filter (lambda (crate)
             (semver-range-contains? semver-range (crate->semver crate)))
           range)
   (lambda args
     (apply semver>? (map crate->semver args)))))

(define (nonyanked-crate-versions crate)
  "Returns a list of <crate-version>s which are not yanked by upstream."
  (filter (lambda (entry)
            (not (crate-version-yanked? entry)))
          (crate-versions crate)))

(define* (crate->guix-package
          crate-name
          #:key version include-dev-deps? allow-yanked? #:allow-other-keys)
  "Fetch the metadata for CRATE-NAME from crates.io, and return the
`package' s-expression corresponding to that package, or #f on failure.
When VERSION is specified, convert it into a semver range and attempt to fetch
the latest version matching this semver range; otherwise fetch the latest
version of CRATE-NAME.  If INCLUDE-DEV-DEPS is true then this will also
look up the development dependencs for the given crate."

  (define (semver-range-contains-string? range version)
    (semver-range-contains? (string->semver-range range)
                            (string->semver version)))

  (define (normal-dependency? dependency)
    (or (eq? (crate-dependency-kind dependency) 'build)
        (eq? (crate-dependency-kind dependency) 'normal)))

  (define crate
    (lookup-crate* crate-name))

  (define version-number
    (and crate
         (or version
             (crate-latest-version crate))))

  ;; Find the highest existing package that fulfills the semver <range>.
  ;; Packages previously marked as yanked take lower priority.
  (define (find-package-version name range)
    (let* ((semver-range (string->semver-range range))
           (version
            (min-element
             (filter (match-lambda ((semver yanked)
                                    (and
                                     (or allow-yanked? (not yanked))
                                     (semver-range-contains? semver-range semver))))
                     (map (lambda (pkg)
                            (let ((version (package-version pkg)))
                              (list
                                (string->semver version)
                                (assoc-ref (package-properties pkg)
                                           'crate-version-yanked?))))
                          (find-packages-by-name
                           (crate-name->package-name name))))
             (match-lambda* (((semver1 yanked1) (semver2 yanked2))
                             (or (and yanked1 (not yanked2))
                                 (and (eq? yanked1 yanked2)
                                      (semver<? semver1 semver2))))))))
      (and (not (eq? #f version))
           (match-let (((semver yanked) version))
             (list (semver->string semver) yanked)))))

  ;; Find the highest version of a crate that fulfills the semver <range>.
  ;; If no matching non-yanked version has been found and allow-yanked? is #t,
  ;; also consider yanked packages.
  (define (find-crate-version crate range)
    (let ((semver-range (string->semver-range range))
          (versions     (nonyanked-crate-versions crate)))
      (or (and (not (null-list? versions))
               (max-crate-version-of-semver semver-range versions))
          (and allow-yanked?
               (not (null-list? (crate-versions crate)))
               (max-crate-version-of-semver semver-range
                                            (crate-versions crate))))))

  ;; If no non-yanked existing package version was found, check the upstream
  ;; versions.  If a non-yanked upsteam version exists, use it instead,
  ;; otherwise use the existing package version, provided it exists.
  (define (dependency-name+version+yanked dep)
    (let* ((name (crate-dependency-id dep))
                 (req (crate-dependency-requirement dep))
                 (existing-version (find-package-version name req)))
      (if (and existing-version (not (second existing-version)))
          (cons name existing-version)
          (let* ((crate (lookup-crate* name))
                 (ver (find-crate-version crate req)))
            (if existing-version
                (if (and ver (not (crate-version-yanked? ver)))
                    (if (semver=? (string->semver (first existing-version))
                                  (string->semver (crate-version-number ver)))
                        (begin
                          (warning (G_ "~A: version ~a is no longer yanked~%")
                                   name (first existing-version))
                          (cons name existing-version))
                        (list name
                              (crate-version-number ver)
                              (crate-version-yanked? ver)))
                    (begin
                      (warning (G_ "~A: using existing version ~a, which was yanked~%")
                               name (first existing-version))
                      (cons name existing-version)))
                (begin
                  (unless ver
                    (leave (G_ "~A: no version found for requirement ~a~%") name req))
                  (if (crate-version-yanked? ver)
                      (warning (G_ "~A: imported version ~a was yanked~%")
                               name (crate-version-number ver)))
                  (list name
                        (crate-version-number ver)
                        (crate-version-yanked? ver))))))))

  (define version*
    (and crate
         (or (find-crate-version crate version-number)
             (leave (G_ "~A: version ~a not found~%") crate-name version-number))))

  ;; sort and map the dependencies to a list containing
  ;; pairs of (name version)
  (define (sort-map-dependencies deps)
    (sort (map dependency-name+version+yanked
               deps)
          (match-lambda* (((name _ _) ...)
                          (apply string-ci<? name)))))

  (define (remove-yanked-info deps)
    (map
     (match-lambda ((name version yanked)
                    (list name version)))
     deps))

  (if (and crate version*)
      (let* ((dependencies (crate-version-dependencies version*))
             (dep-crates dev-dep-crates (partition normal-dependency? dependencies))
             (cargo-inputs (sort-map-dependencies dep-crates))
             (cargo-development-inputs (if include-dev-deps?
                                           (sort-map-dependencies dev-dep-crates)
                                           '())))
        (values
         (make-crate-sexp #:build? include-dev-deps?
                          #:yanked? (crate-version-yanked? version*)
                          #:name crate-name
                          #:version (crate-version-number version*)
                          #:cargo-inputs cargo-inputs
                          #:cargo-development-inputs cargo-development-inputs
                          #:home-page
                          (let ((home-page (crate-home-page crate)))
                            (if (string? home-page)
                                home-page
                                (let ((repository (crate-repository crate)))
                                  (if (string? repository)
                                      repository
                                      ""))))
                          #:synopsis (crate-description crate)
                          #:description (crate-description crate)
                          #:license (and=> (crate-version-license version*)
                                           string->license))
         (append
          (remove-yanked-info cargo-inputs)
          (remove-yanked-info cargo-development-inputs))))
      (values #f '())))

(define* (crate-recursive-import
          crate-name #:key version recursive-dev-dependencies? allow-yanked?)
  (recursive-import
   crate-name
   #:repo->guix-package
   (let ((crate->guix-package* (memoize crate->guix-package)))
     (lambda* params
       ;; download development dependencies only for the top level package
       (let ((include-dev-deps?
              (or (equal? (car params) crate-name)
                  recursive-dev-dependencies?)))
         (apply crate->guix-package*
                (append params `(#:include-dev-deps? ,include-dev-deps?
                                 #:allow-yanked? ,allow-yanked?))))))
   #:version version
   #:guix-name crate-name->package-name))

(define (guix-package->crate-name package)
  "Return the crate name of PACKAGE."
  (and-let* ((origin (package-source package))
             (uri (origin-uri origin))
             (crate-url? uri)
             (len (string-length crate-url))
             (path (xsubstring uri len))
             (parts (string-split path #\/)))
    (match parts
      ((name _ ...) name))))

(define (crate-name->package-name name)
  (guix-name "rust-" name))



;;;
;;; Updater
;;;

(define crate-package?
  (url-predicate crate-url?))

(define* (import-release package #:key (version #f))
  "Return an <upstream-source> for the latest release of PACKAGE. Optionally
include a VERSION string to fetch a specific version."
  (let* ((crate-name (guix-package->crate-name package))
         (crate      (lookup-crate crate-name))
         (version    (or version
                         (let ((max-crate-version
                                 (max-crate-version-of-semver
                                   (string->semver-range
                                     (string-append "^" (package-version package)))
                                   (nonyanked-crate-versions crate))))
                           (and=> max-crate-version
                                  crate-version-number)))))
    (if version
        (upstream-source
         (package (package-name package))
         (version version)
         (urls (list (crate-uri crate-name version))))
        #f)))

(define %crate-updater
  (upstream-updater
   (name 'crate)
   (description "Updater for crates.io packages")
   (pred crate-package?)
   (import import-release)))

