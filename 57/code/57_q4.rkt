
#lang racket/base

;; Count top-level elements of a list.
(define (my-length lst)
  (if (null? lst)
      0
      (+ 1 (my-length (cdr lst)))))
