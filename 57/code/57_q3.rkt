#lang racket/base

; inorder: values of tree in inorder (left, node, right), followed by acc.
; Base case: the empty tree adds nothing, so the answer is acc.
; Recursive case: walk the right subtree first, put the node in front of
; that result, then walk the left subtree in front of both.
(define (inorder tree acc)
  (if (null? tree)
      acc
      (inorder (cadr tree)
               (cons (car tree)
                     (inorder (caddr tree) acc)))))

; preorder: values of tree in preorder (node, left, right), followed by acc.
; Base case: the empty tree adds nothing, so the answer is acc.
; Recursive case: collect the right subtree onto acc, then the left subtree
; in front of that, then put the node's own value at the very front.
(define (preorder tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder (cadr tree)
                      (preorder (caddr tree) acc)))))