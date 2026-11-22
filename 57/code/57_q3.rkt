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

; postorder: values of tree in postorder (left, right, node), followed by acc.
; Base case: the empty tree adds nothing, so the answer is acc.
; Recursive case: put the node's value onto acc first (it comes last),
; then the right subtree in front of that, then the left subtree in front.
(define (postorder tree acc)
  (if (null? tree)
      acc
      (postorder (cadr tree)
                 (postorder (caddr tree)
                            (cons (car tree) acc)))))

; print-inorder: prints the inorder list of tree on one line.
(define (print-inorder tree)
  (display (inorder tree '()))
  (newline))

; print-all-traversals: prints inorder, preorder and postorder, one per line.
(define (print-all-traversals tree)
  (display (inorder tree '()))
  (newline)
  (display (preorder tree '()))
  (newline)
  (display (postorder tree '()))
  (newline))

; tree-height: height of tree. The empty tree has height 0, a single node 1.
; Base case: the empty tree has height 0.
; Recursive case: 1 to count this node, plus the larger subtree height.
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (cadr tree))
                (tree-height (caddr tree))))))

; leaf-count: number of leaves in tree. The empty tree has 0 leaves.
; Base cases: the empty tree has 0 leaves; a node whose two subtrees are
; both empty is a leaf, so it counts as 1.
; Recursive case: any other node has the leaves of its left subtree plus
; the leaves of its right subtree.
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((and (null? (cadr tree)) (null? (caddr tree))) 1)
        (else (+ (leaf-count (cadr tree))
                 (leaf-count (caddr tree))))))