---
name: scheme-dev
description: Write, test and review Racket (racket/base) code for the CS F301 Assignment 2 Scheme problems (S1 tree traversals, S2 conditional nested insert). Use for any Scheme function in this assignment.
---

# scheme-dev

## Language and version
- Racket 8.x. Behaviour notes below were checked on Racket 8.10 and the assignment grader uses 8.x.
- Every file starts with `#lang racket/base`.
- Only these built-ins may be used: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (written `'`), `cons`, `car`, `cdr`, `list`, every composition of `car` and `cdr` up to four levels (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr` and so on), `null?`, `pair?`, `eq?`, `assq`, `assoc`, `+ - * < > <= >= =`, `max`, `display`, `newline`. S2 also allows `read`.
- Everything else is forbidden: `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`, `set!` and relatives, vectors, hash tables, strings, `do`, `for`. If a helper is needed, write it yourself (`my-length`, `my-map`, `my-reverse`, `my-append`).
- Important: all of the forbidden names exist in `racket/base`, so code that uses them will run fine and still break the rules. Only a scan of the file catches it.
- The file contains only definitions. Nothing is called at top level and nothing prints when the file loads. The grader adds its own calls at the end.

## Coding conventions
- Helpers that replace a forbidden built-in start with `my-`. Other names are lowercase with hyphens (`print-inorder`, `tree-height`).
- One function does one thing. Several short functions beat one deeply nested one.
- Every recursive function has a visible base case (usually `(null? x)`) and a visible recursive case. A one-line comment if that is not obvious.
- Pass all state through arguments. No mutation. Prefer tail recursion: a named `let` with an accumulator, and `my-reverse` at the end if the list was built backwards.
- Brief comments only where the code is not obvious. Slightly longer, readable code over clever one-liners.

## Assignment workflow
- Never write the complete solution to a whole problem in one response. Work on one function, helper, test file, or review at a time.
- Before writing code, say which unit this is and which earlier functions it uses.
- When reviewing existing code, list problems and do not rewrite functions that were not asked about.
- Prompts and commits follow the same units.

## How to run and test
```
racket FILE.rkt
```
Put test calls in a separate file with no `#lang` line. Join it to the code and run (PowerShell, from the repo folder):
```
Get-Content 57\code\57_q4.rkt, 57\tests\q4_calls.rkt | Set-Content $env:TEMP\run.rkt
racket $env:TEMP\run.rkt
```
For S2, feed the input on standard input:
```
"42 ((1 2) (3 4 5) (6) ()) 3" | racket $env:TEMP\run.rkt
```
Test every PDF example, the empty list, a single element, nesting depth 100, and a list of 10,000 elements.

Scan for forbidden names (PowerShell, from the repo folder; each match must be explained or removed):
```
Select-String -Path 57\code\57_q4.rkt -Pattern '(?<![\w-])(length|append|reverse|map|filter|member|memq|list-ref|list-tail|set!|vector|string|hash|for|do|equal\?|list\?|zero\?|add1|sub1|abs|printf|format|void)(?![\w-])'
```
Names like `my-length` and `my-map` do not match, because of the hyphen. Matches inside comments can be ignored.

## Self-review checklist (apply before giving an answer)
1. Run the forbidden-name scan above. No matches in code.
2. Is there any top-level expression that is not a `define`? In a module, a bare expression prints its value when the file loads.
3. Does the output match the PDF exactly (parentheses, spaces, one newline at the end)?
4. Does every `if` have two branches and every `cond` end with `else`?
5. Is the empty list written `'()` with the quote? Plain `()` is an error.
6. Is an atom tested as "not a pair and not null", never with `list?`?
7. Does it work on `'()`, one element, depth 100 and 10,000 elements?
8. (S2) Is the length measured on the original list, before any insertion?
9. Was every PDF example run and the output compared?

## Known failure modes of AI tools in Racket and Scheme
- **Habit built-ins.** `length`, `append`, `map`, `reverse`, `filter`, `list?`, `equal?`, `zero?`, `add1`, `sub1`, `abs`, `printf`, `format`, `void`. All run in `racket/base` and all are forbidden here. Write the allowed form instead, for example `(= n 0)` for `zero?` and `(+ n 1)` for `add1`.
- **Bare top-level expressions.** A test call left at the end of the file prints its result on load. `(+ 1 2)` at the end of a module prints `3`.
- **Missing quote on the empty list.** `(display ())` fails with "illegal empty application". Write `'()`.
- **Wrong printer.** The PDF says `display`. `print` writes a list with a leading quote mark (`'(1 2 3)`). `display` gives `(1 2 3)`.
- **`cond` with no `else`.** If no branch matches, it returns void, and `display` of that prints `#<void>`.
- **`car` or `cdr` of `'()`** raises an error. Test `null?` first.
- **`=` on non-numbers** raises an error. Use `eq?` for symbols and `=` for numbers, and check the type first.
- **Atom versus list confusion in nested lists.** Ask `null?` first, then `pair?` (a sublist), otherwise it is an atom.
- **Missing newline** at the end of printed output.
- **Non-tail recursion and large inputs.** The assignment prefers tail recursion where natural. Hidden tests use nesting depth 100 and lists of 10,000 elements, so use an accumulator where it fits and do not recompute the length of the same list again and again.
- **Defining `insert-if-short` twice** in the final S2 file. The PDF wants one definition, the one that uses `make-inserter`.
- **Input reading (S2).** `read` returns the next datum. Read x, then lst, then n, in that order, and print nothing else.

## S1 specifics (binary tree traversals)
- The empty tree is `'()`. A non-empty tree is `(value left right)`. A value is a number or a single-character symbol.
- Always visit the left subtree before the right one. Inorder: left, node, right. Preorder: node, left, right. Postorder: left, right, node.
- Height of `'()` is 0. Height of a node is 1 plus the larger of the two subtree heights, so a single node has height 1.
- A leaf is a node whose left and right subtrees are both `'()`. The empty tree has 0 leaves.
- Build each traversal as a list and print it once with `display`; do not print while recursing. Every function ends its output with a newline.
- `print-all-traversals` prints three lines (inorder, preorder, postorder). `print-height-and-leaves` prints one line `(height leaf-count)`.
- Tests to write: the PDF trees t1, t2, t3 and the empty tree.

## S2 specifics (conditional nested insert)
- Input order is x, then lst, then n.
- The top-level list is treated exactly like every nested list. `()` has length 0, so it becomes `(x)` whenever 0 < n, at any level, including an empty top-level list.
- Only lists change; atoms stay exactly where they are. An item is `null?` (an empty list, which can get an insert), a `pair?` (a non-empty list, so process its elements and then possibly insert), or an atom.
- The length test uses the original list, before any insertion.
- `(make-inserter x len-ok?)` returns a function of one list. The final `insert-if-short` is defined with it and is the only definition of that name.
- Tests to write: the four PDF examples, n = 0 and n > 0 with empty lists, depth 100, a list of 10,000 elements.
