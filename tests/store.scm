;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013 Ludovic Courtès <ludo@gnu.org>
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


(define-module (test-store)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (guix base32)
  #:use-module (guix packages)
  #:use-module (guix derivations)
  #:use-module (gnu packages)
  #:use-module (gnu packages bootstrap)
  #:use-module (ice-9 match)
  #:use-module (web uri)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-11)
  #:use-module (srfi srfi-64))

;; Test the (guix store) module.

(define %store
  (false-if-exception (open-connection)))

(when %store
  ;; Make sure we build everything by ourselves.
  (set-build-options %store #:use-substitutes? #f))

(define %seed
  (seed->random-state (logxor (getpid) (car (gettimeofday)))))

(define (random-text)
  (number->string (random (expt 2 256) %seed) 16))


(test-begin "store")

(test-equal "store-path-hash-part"
  "283gqy39v3g9dxjy26rynl0zls82fmcg"
  (store-path-hash-part
   (string-append (%store-prefix)
                  "/283gqy39v3g9dxjy26rynl0zls82fmcg-guile-2.0.7")))

(test-equal "store-path-hash-part #f"
  #f
  (store-path-hash-part
   (string-append (%store-prefix)
                  "/foo/bar/283gqy39v3g9dxjy26rynl0zls82fmcg-guile-2.0.7")))

(test-skip (if %store 0 10))

(test-assert "dead-paths"
  (let ((p (add-text-to-store %store "random-text"
                              (random-text) '())))
    (member p (dead-paths %store))))

;; FIXME: Find a test for `live-paths'.
;;
;; (test-assert "temporary root is in live-paths"
;;   (let* ((p1 (add-text-to-store %store "random-text"
;;                                 (random-text) '()))
;;          (b  (add-text-to-store %store "link-builder"
;;                                 (format #f "echo ~a > $out" p1)
;;                                 '()))
;;          (d1 (derivation %store "link" (%current-system)
;;                          "/bin/sh" `("-e" ,b) '()
;;                          `((,b) (,p1))))
;;          (p2 (derivation-path->output-path d1)))
;;     (and (add-temp-root %store p2)
;;          (build-derivations %store (list d1))
;;          (valid-path? %store p1)
;;          (member (pk p2) (live-paths %store)))))

(test-assert "dead path can be explicitly collected"
  (let ((p (add-text-to-store %store "random-text"
                              (random-text) '())))
    (let-values (((paths freed) (delete-paths %store (list p))))
      (and (equal? paths (list p))
           (> freed 0)
           (not (file-exists? p))))))

(test-assert "references"
  (let* ((t1 (add-text-to-store %store "random1"
                                (random-text) '()))
         (t2 (add-text-to-store %store "random2"
                                (random-text) (list t1))))
    (and (equal? (list t1) (references %store t2))
         (equal? (list t2) (referrers %store t1))
         (null? (references %store t1))
         (null? (referrers %store t2)))))

(test-assert "derivers"
  (let* ((b (add-text-to-store %store "build" "echo $foo > $out" '()))
         (s (add-to-store %store "bash" #t "sha256"
                          (search-bootstrap-binary "bash"
                                                   (%current-system))))
         (d (derivation %store "the-thing" (%current-system)
                        s `("-e" ,b) `(("foo" . ,(random-text)))
                        `((,b) (,s))))
         (o (derivation-path->output-path d)))
    (and (build-derivations %store (list d))
         (equal? (query-derivation-outputs %store d)
                 (list o))
         (equal? (valid-derivers %store o)
                 (list d)))))

(test-assert "no substitutes"
  (let* ((s  (open-connection))
         (d1 (package-derivation s %bootstrap-guile (%current-system)))
         (d2 (package-derivation s %bootstrap-glibc (%current-system)))
         (o  (map derivation-path->output-path (list d1 d2))))
    (set-build-options s #:use-substitutes? #f)
    (and (not (has-substitutes? s d1))
         (not (has-substitutes? s d2))
         (null? (substitutable-paths s o))
         (null? (substitutable-path-info s o)))))

(test-skip (if (getenv "GUIX_BINARY_SUBSTITUTE_URL") 0 1))

(test-assert "substitute query"
  (let* ((s   (open-connection))
         (d   (package-derivation s %bootstrap-guile (%current-system)))
         (o   (derivation-path->output-path d))
         (dir (and=> (getenv "GUIX_BINARY_SUBSTITUTE_URL")
                     (compose uri-path string->uri))))
    ;; Create fake substituter data, to be read by `substitute-binary'.
    (call-with-output-file (string-append dir "/nix-cache-info")
      (lambda (p)
        (format p "StoreDir: ~a\nWantMassQuery: 0\n"
                (getenv "NIX_STORE_DIR"))))
    (call-with-output-file (string-append dir "/" (store-path-hash-part o)
                                          ".narinfo")
      (lambda (p)
        (format p "StorePath: ~a
URL: ~a
Compression: none
NarSize: 1234
References: 
System: ~a
Deriver: ~a~%"
                o                                   ; StorePath
                (string-append dir "/example.nar")  ; URL
                (%current-system)                   ; System
                (basename d))))                     ; Deriver

    ;; Make sure `substitute-binary' correctly communicates the above data.
    (set-build-options s #:use-substitutes? #t)
    (and (has-substitutes? s o)
         (equal? (list o) (substitutable-paths s (list o)))
         (match (pk 'spi (substitutable-path-info s (list o)))
           (((? substitutable? s))
            (and (equal? (substitutable-deriver s) d)
                 (null? (substitutable-references s))
                 (equal? (substitutable-nar-size s) 1234)))))))

(test-end "store")


(exit (= (test-runner-fail-count (test-runner-current)) 0))
