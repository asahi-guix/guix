;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2014, 2015, 2017, 2018 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2022 Maxime Devos <maximedevos@telenet.be>
;;; Copyright © 2023 Maxim Cournoyer <maxim.cournoyer@gmail.com>
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

(define-module (guix search-paths)
  #:use-module (guix records)
  #:use-module (guix build utils)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 match)
  #:export (<search-path-specification>
            search-path-specification
            search-path-specification?
            search-path-specification-variable
            search-path-specification-files
            search-path-specification-separator
            search-path-specification-file-type
            search-path-specification-file-pattern

            $CPLUS_INCLUDE_PATH
            $C_INCLUDE_PATH
            $OBJC_INCLUDE_PATH
            $OBJCPLUS_INCLUDE_PATH
            $LIBRARY_PATH
            $GUIX_EXTENSIONS_PATH
            $PATH
            $PKG_CONFIG_PATH
            $SSL_CERT_DIR
            $SSL_CERT_FILE
            $TZDIR
            $SGML_CATALOG_FILES
            $XML_CATALOG_FILES

            %gcc-search-paths
            %libxslt-search-paths

            search-path-specification->sexp
            sexp->search-path-specification
            string-tokenize*
            evaluate-search-paths
            environment-variable-definition
            search-path-definition
            set-search-paths))

;;; Commentary:
;;;
;;; This module defines "search path specifications", which allow packages to
;;; declare environment variables that they use to define search paths.  For
;;; instance, GCC has the 'CPATH' variable, Guile has the 'GUILE_LOAD_PATH'
;;; variable, etc.
;;;
;;; Code:

;; The specification of a search path.
(define-record-type* <search-path-specification>
  search-path-specification make-search-path-specification
  search-path-specification?
  (variable     search-path-specification-variable) ;string
  (files        search-path-specification-files)    ;list of strings
  (separator    search-path-specification-separator ;string | #f
                (default ":"))
  (file-type    search-path-specification-file-type ;symbol
                (default 'directory))
  (file-pattern search-path-specification-file-pattern ;#f | string
                (default #f)))

(define $C_INCLUDE_PATH
  (search-path-specification
   (variable "CPLUS_INCLUDE_PATH")
   ;; Add 'include/c++' here so that <cstdlib>'s "#include_next
   ;; <stdlib.h>" finds GCC's <stdlib.h>, not libc's.
   (files '("include/c++" "include"))))

(define $CPLUS_INCLUDE_PATH
  (search-path-specification
   (variable "C_INCLUDE_PATH")
   (files '("include"))))

(define $OBJC_INCLUDE_PATH
  (search-path-specification
   (variable "OBJC_INCLUDE_PATH")
   (files '("include"))))

(define $OBJCPLUS_INCLUDE_PATH
  (search-path-specification
   (variable "OBJCPLUS_INCLUDE_PATH")
   ;; Add 'include/c++' here so that <cstdlib>'s "#include_next
   ;; <stdlib.h>" finds GCC's <stdlib.h>, not libc's.
   (files '("include/c++" "include"))))

(define $LIBRARY_PATH
  (search-path-specification
   (variable "LIBRARY_PATH")
   (files '("lib" "lib64"))))

(define %gcc-search-paths
  ;; Use the language-specific variables rather than 'CPATH' because they
  ;; are equivalent to '-isystem' whereas 'CPATH' is equivalent to '-I'.
  ;; The intent is to allow headers that are in the search path to be
  ;; treated as "system headers" (headers exempt from warnings) just like
  ;; the typical /usr/include headers on an FHS system.
  (list $C_INCLUDE_PATH
        $CPLUS_INCLUDE_PATH
        $OBJC_INCLUDE_PATH
        $OBJCPLUS_INCLUDE_PATH
        $LIBRARY_PATH))

(define $PATH
  ;; The 'PATH' variable.  This variable is a bit special: it is not attached
  ;; to any package in particular.
  (search-path-specification
   (variable "PATH")
   (files '("bin" "sbin"))))

(define $GUIX_EXTENSIONS_PATH
  ;; 'GUIX_EXTENSIONS_PATH' is used by Guix to locate extension commands.
  ;; Unlike 'PATH', it is attached to a package, Guix; however, it is
  ;; convenient to define it by default because the 'guix' package is not
  ;; supposed to be installed in a profile.
  (search-path-specification
   (variable "GUIX_EXTENSIONS_PATH")
   (files '("share/guix/extensions"))))

(define $PKG_CONFIG_PATH
  ;; 'PKG_CONFIG_PATH' is used by pkg-config to locate available header files
  ;; and libraries, via their .pc files.
  (search-path-specification
   (variable "PKG_CONFIG_PATH")
   (files '("lib/pkgconfig" "lib64/pkgconfig" "share/pkgconfig"))))

;; Two variables for certificates (info "(guix)X.509 Certificates"),
;; respected by OpenSSL and possibly GnuTLS in the future
;; (https://gitlab.com/gnutls/gnutls/-/merge_requests/1541)
;; and many of their dependents -- even some GnuTLS dependents
;; like Guile.  As they are not tied to a single package, define
;; them here to avoid duplication.
;;
;; Additionally, the 'native-search-paths' field is not thunked,
;; so doing (package-native-search-paths openssl)
;; could cause import cycle issues.
(define $SSL_CERT_DIR
  (search-path-specification
   (variable "SSL_CERT_DIR")
   (separator #f)                       ;single entry
   (files '("etc/ssl/certs"))))

(define $SSL_CERT_FILE
  (search-path-specification
   (variable "SSL_CERT_FILE")
   (file-type 'regular)
   (separator #f)                       ;single entry
   (files '("etc/ssl/certs/ca-certificates.crt"))))

(define $TZDIR
  (search-path-specification
   (variable "TZDIR")
   (files '("share/zoneinfo"))
   (separator #f)))                     ;single entry

;; Some packages (notably libxml2) make use of 'XML_CATALOG_FILES'
;; and 'SGML_CATALOG_FILES' for remapping URI references or public/system
;; identifiers to other URI references.
(define $SGML_CATALOG_FILES
  ;; $SGML_CATALOG_FILES lists 'catalog' or 'CATALOG' or '*.cat' files found
  ;; under the 'sgml' sub-directory of any given package.
  (search-path-specification
   (variable "SGML_CATALOG_FILES")
   (separator ":")
   (files '("sgml"))
   (file-pattern "^catalog$|^CATALOG$|^.*\\.cat$")
   (file-type 'regular)))

(define $XML_CATALOG_FILES
  ;; $XML_CATALOG_FILES lists 'catalog.xml' files found in under the 'xml'
  ;; sub-directory of any given package.
  (search-path-specification
   (variable "XML_CATALOG_FILES")
   (separator " ")
   (files '("xml"))
   (file-pattern "^catalog\\.xml$")
   (file-type 'regular)))

(define %libxslt-search-paths
  (list $SGML_CATALOG_FILES $XML_CATALOG_FILES))

(define (search-path-specification->sexp spec)
  "Return an sexp representing SPEC, a <search-path-specification>.  The sexp
corresponds to the arguments expected by `set-path-environment-variable'."
  ;; Note that this sexp format is used both by build systems and in
  ;; (guix profiles), so think twice before you change it.
  (match spec
    (($ <search-path-specification> variable files separator type pattern)
     `(,variable ,files ,separator ,type ,pattern))))

(define (sexp->search-path-specification sexp)
  "Convert SEXP, which is as returned by 'search-path-specification->sexp', to
a <search-path-specification> object."
  (match sexp
    ((variable files separator type pattern)
     (search-path-specification
      (variable variable)
      (files files)
      (separator separator)
      (file-type type)
      (file-pattern pattern)))))

(define-syntax-rule (with-null-error-port exp)
  "Evaluate EXP with the error port pointing to the bit bucket."
  (with-error-to-port (%make-void-port "w")
    (lambda () exp)))

;; XXX: This procedure used to be in (guix utils) but since we want to be able
;; to use (guix search-paths) on the build side, we want to avoid the
;; dependency on (guix utils), and so this procedure is back here for now.
(define (string-tokenize* string separator)
  "Return the list of substrings of STRING separated by SEPARATOR.  This is
like `string-tokenize', but SEPARATOR is a string."
  (define (index string what)
    (let loop ((string string)
               (offset 0))
      (cond ((string-null? string)
             #f)
            ((string-prefix? what string)
             offset)
            (else
             (loop (string-drop string 1) (+ 1 offset))))))

  (define len
    (string-length separator))

  (let loop ((string string)
             (result  '()))
    (cond ((index string separator)
           =>
           (lambda (offset)
             (loop (string-drop string (+ offset len))
                   (cons (substring string 0 offset)
                         result))))
          (else
           (reverse (cons string result))))))

(define* (evaluate-search-paths search-paths directories
                                #:optional (getenv (const #f)))
  "Evaluate SEARCH-PATHS, a list of search-path specifications, for
DIRECTORIES, a list of directory names, and return a list of
specification/value pairs.  Use GETENV to determine the current settings and
report only settings not already effective."
  (define (search-path-definition spec)
    (match spec
      (($ <search-path-specification> variable files #f type pattern)
       ;; Separator is #f so return the first match.
       (match (with-null-error-port
               (search-path-as-list files directories
                                    #:type type
                                    #:pattern pattern))
         (()
          #f)
         ((head . _)
          (let ((value (getenv variable)))
            (if (and value (string=? value head))
                #f                         ;VARIABLE already set appropriately
                (cons spec head))))))
      (($ <search-path-specification> variable files separator
                                      type pattern)
       (let* ((values (or (and=> (getenv variable)
                                 (cut string-tokenize* <> separator))
                          '()))
              ;; XXX: Silence 'find-files' when it stumbles upon non-existent
              ;; directories (see
              ;; <http://lists.gnu.org/archive/html/guix-devel/2015-01/msg00269.html>.)
              (path   (with-null-error-port
                       (search-path-as-list files directories
                                            #:type type
                                            #:pattern pattern))))
         (if (every (cut member <> values) path)
             #f                         ;VARIABLE is already set appropriately
             (cons spec (string-join path separator)))))))

  (filter-map search-path-definition search-paths))

(define* (environment-variable-definition variable value
                                          #:key
                                          (kind 'exact)
                                          (separator ":"))
  "Return a the definition of VARIABLE to VALUE in Bash syntax.

KIND can be either 'exact (return the definition of VARIABLE=VALUE),
'prefix (return the definition where VALUE is added as a prefix to VARIABLE's
current value), or 'suffix (return the definition where VALUE is added as a
suffix to VARIABLE's current value.)  In the case of 'prefix and 'suffix,
SEPARATOR is used as the separator between VARIABLE's current value and its
prefix/suffix."
  (match (if (not separator) 'exact kind)
    ('exact
     (format #f "export ~a=\"~a\"" variable value))
    ('prefix
     (format #f "export ~a=\"~a${~a:+~a}$~a\""
             variable value variable separator variable))
    ('suffix
     (format #f "export ~a=\"$~a${~a:+~a}~a\""
             variable variable variable separator value))))

(define* (search-path-definition search-path value
                                 #:key (kind 'exact))
  "Similar to 'environment-variable-definition', but applied to a
<search-path-specification>."
  (match search-path
    (($ <search-path-specification> variable _ separator)
     (environment-variable-definition variable value
                                      #:kind kind
                                      #:separator separator))))

(define* (set-search-paths search-paths directories
                           #:key (setenv setenv))
  "Set the search path environment variables specified by SEARCH-PATHS for the
given directories."
  (for-each (match-lambda
              ((spec . value)
               (setenv (search-path-specification-variable spec)
                       value)))
            (evaluate-search-paths search-paths directories)))

;;; search-paths.scm ends here
