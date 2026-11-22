
#lang racket/base

;; Count top-level elements of a list.
(define (my-length lst)
  (if (null? lst)
      0
      (+ 1 (my-length (cdr lst)))))

;; Apply a function to every top-level element of a list.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))


;; Return a function that inserts x into qualifying nested lists.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (if (len-ok? (my-length lst))
                  (cons x (my-map
                           (lambda (item)
                             (if (pair? item)
                                 (insert item)
                                 (if (null? item)
                                     (insert item)
                                     item)))
                           lst))
                  (my-map
                   (lambda (item)
                     (if (pair? item)
                         (insert item)
                         (if (null? item)
                             (insert item)
                             item)))
                   lst)))))
    insert))
