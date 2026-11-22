
#lang racket/base

;; Test harness only: the assignment source remains unchanged.
(require racket/enter)

(enter! "57/code/57_q4.rkt")

(define (check label actual expected)
  (if (equal? actual expected)
      (display (list 'PASS label))
      (display (list 'FAIL label
                     'expected expected
                     'actual actual)))
  (newline))

;; Four examples from the assignment PDF.
(check 'pdf-1
       (eval '(insert-if-short
                42 '((1 2) (3 4 5) (6) ()) 3))
       '((42 1 2) (3 4 5) (42 6) (42)))

(check 'pdf-2
       (eval '(insert-if-short
                0 '(((1) 2) (3) ((4 5 6) ())) 3))
       '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))

(check 'pdf-3
       (eval '(insert-if-short 7 '() 3))
       '(7))

(check 'pdf-4
       (eval '(insert-if-short 7 '() 0))
       '())

;; Edge cases.
(check 'empty-n0
       (eval '(insert-if-short 5 '() 0))
       '())

(check 'empty-n1
       (eval '(insert-if-short 5 '() 1))
       '(5))

(check 'nonempty-n0
       (eval '(insert-if-short 5 '(1 2) 0))
       '(1 2))

(check 'nested-empty
       (eval '(insert-if-short 9 '(() (1)) 2))
       '((9) (9 1)))

;; Construct a depth-100 nested list.
(define (make-deep n)
  (if (= n 0)
      '()
      (list (make-deep (- n 1)))))

(define deep100 (make-deep 100))

;; n = 0 means no insertion at any depth.
(check 'depth-100
       (eval (list 'insert-if-short 7
                   (list 'quote deep100) 0))
       deep100)

;; Construct a list with 10000 elements.
(define (make-large n)
  (let loop ((k n) (acc '()))
    (if (= k 0)
        acc
        (loop (- k 1) (cons 1 acc)))))

(define large10000 (make-large 10000))

;; With n = 0, the large list should remain unchanged.
(check 'large-10000
       (eval (list 'insert-if-short 7
                   (list 'quote large10000) 0))
       large10000)
