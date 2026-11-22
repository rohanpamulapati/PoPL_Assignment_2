---
name: prolog-dev
description: Write, test and review SWI-Prolog code for the CS F301 Assignment 2 Prolog problems (P1 department puzzle, P2 arithmetic equations). Use for any Prolog predicate in this assignment.
---

# prolog-dev

## Language and version
- SWI-Prolog. The grader uses 9.x. Behaviour notes below were checked on SWI-Prolog 9.0.4; our laptops run 11.0.0, so avoid anything that is new in 10 or 11.
- Allowed libraries: lists, apply, yall, aggregate. Nothing else (no clpfd, no dcg/basics, no strings library tricks).
- Forbidden: assert, retract, b_setval, nb_setval, `halt`, any `initialization` directive. Loading a file must print nothing and show no warnings.
- Files contain only definitions. The grader supplies the goal: `swipl -q -f FILE -g GOAL -t halt`.

## Coding conventions
- Predicates and atoms in lower_snake_case. Variables in CamelCase with real names (Solution, LeftList, Value), single letters only in tiny helpers.
- One short comment above each predicate giving its declarative reading, for example `% sum_ok(L, S): S is the sum of the numbers in L.` Add other comments only where a line is not obvious.
- Every predicate has two readings I can state out loud: the declarative one (what it means) and the recursive one (base case, recursive case).
- Prefer a slightly longer, plain version over a clever one-liner.
- Keep all clauses of one predicate together (otherwise SWI-Prolog prints a discontiguous warning). All `clue/2` clauses sit in one block, in order.
- Name unused variables `_` or `_Name`, so no singleton warnings appear.

## Assignment workflow
- Never write the complete solution to a whole problem in one response. Work on one unit at a time: one predicate, one helper, one test file, or one review.
- Before writing code, say which unit this is and which earlier predicates it depends on.
- When reviewing existing code, list problems and do not rewrite predicates that were not asked about.
- Prompts and commits follow the same units.

## How to run and test
```
swipl -q -f FILE.pl -g main -t halt
swipl -q -f FILE.pl -g "GOAL" -t halt
swipl -q -f FILE.pl -g true -t halt
```
The last one is the load check. Its output must be empty. Test every example in the PDF plus these edge cases: empty list, one element, input with no solution. Keep tests in the tests folder.

Quick scan for forbidden things (PowerShell, run from the repo folder):
```
Select-String -Path 57\code\57_q1.pl -Pattern 'assert|retract|b_setval|nb_setval|halt|initialization|clpfd'
```
Expected: no matches.

## Self-review checklist (apply before giving an answer)
1. Does each predicate have a stated declarative reading and a stated base case and recursive case?
2. Does loading the file print anything or show a warning? It must not.
3. Does the output match the PDF character for character (spaces after commas, no quotes, order, final newline)?
4. Are all atoms exactly as the PDF defines them (`'Alex'`, `'c++'`, `'AI'`)?
5. Do cases with no answer fail cleanly? No error, no infinite loop. Check the empty list and the one-element list.
6. Are there unwanted choicepoints or duplicate answers? Is every `!` and `once/1` there on purpose, and can I explain why?
7. Is `\+` used only after its variables are bound?
8. Any forbidden library, assert/retract, global variable, or (P2) a string built and then parsed back to evaluate it?
9. Was it run against every PDF example, with the output compared?

## Known failure modes of AI tools in Prolog
- **Unquoted capitalised atoms.** `Alex` and `AI` are variables. They must be written `'Alex'` and `'AI'`. `c++` also needs quotes: `'c++'`.
- **List printing format.** `write([research,python,'AI'])` prints `[research,python,AI]` with no spaces. The PDF wants `[research, python, AI]`. Print each value with `format`, for example `format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Project])`. `print/1` and `writeq/1` also put quotes around `'c++'` and `'AI'`; `write/1` and `~w` do not.
- **clpfd.** AI tools reach for it by habit. It is not allowed here.
- **assert/retract** for counting or memoising. Forbidden. Use `findall/3` or `aggregate_all/3`.
- **Division.** `4/2` gives the integer 2, but `7/2` gives the float 3.5. Do not rely on that: first check the divisor is not 0 and `X mod Y =:= 0`, then use `//`. The mod check also works for negative values.
- **`is/2` with an unbound variable** raises an error instead of failing. Make sure everything on the right is bound.
- **sort/2 and msort/2.** `sort/2` sorts by standard order and removes duplicates. `msort/2` keeps duplicates.
- **bagof/setof** fail when there are no solutions and group by free variables. Use `findall/3` when you want every result, including the empty list.
- **Strings and atoms.** Double-quoted text in SWI-Prolog is a string object, not an atom. Build output strings with `format(string(S), "~w=~w", [A, B])` or `string_concat/3`. Do not mix atoms and strings when comparing.
- **Left-recursive generators loop forever.** When building expressions from a list, split the list into non-empty left and right parts, so every recursive call is on a shorter list.
- **`length(L, N)` with both unbound** enumerates forever. Bind one side.
- **`=`, `==`, `=:=` are different**: unification, structural equality, arithmetic equality.
- **Cuts added to make a test pass.** Do not add a cut unless you can say why it is correct.
- **Adding `:- initialization(main).` or `halt.`** to the file. The grader forbids both.

## P1 specifics (department puzzle)
- Each `clue(N, Solution)` checks only clue N. Do not smuggle constraints from other clues into it.
- A solution is a list of four `p(Name, Dept, Lang, Project)` terms in the order Alex, Ben, Carla, Dana.
- `count_solutions(Active, N)` counts solutions that satisfy exactly the clues in `Active`. Clues not in `Active` must not affect the count.
- `main/0` derives the answer from the clues (no hard-coded answer) and prints exactly the four lines from the PDF.
- Clue 9: the English sentence goes in a comment on the line directly above it, starting with `% CLUE 9:`. It may not name any friend. It must be true in the one solution we keep and false in every other solution of clues 1 to 8.
- Tests to write: `main` output; each clue on its own; counts for different subsets of clues; the count for clues 1 to 8; the count for clues 1 to 9 equals 1.

## P2 specifics (arithmetic equations)
- An equation is `L=R`, where L uses the first j numbers and R the rest, for some 1 <= j < k. Every number is used once, in order. No unary minus. Digits of different numbers are never joined.
- Expression trees, not values, are what count. `1+(2+3)` and `1+2+3` have the same value but are different trees, so both are separate equations. Never remove equations by comparing values.
- Canonical printing, exactly as the PDF says: `*` and `/` bind tighter than `+` and `-`; left-associative; a left operand gets parentheses only if its top operator has lower precedence than its parent's; a right operand gets parentheses if its top operator has the same or lower precedence; a single number never does. Output is a string with no spaces.
- Every division in the tree must be exact and have a non-zero divisor, not just the last one. Sub-expression values may be negative.
- Generate trees by splitting the list into a non-empty left part and a non-empty right part, keeping the order. Evaluate from the tree, never by parsing a string.
- `generate_equation/2` fails (no error, no loop) for lists of length 0 or 1 and when no equation exists. `all_equations/2` returns the distinct equation strings sorted with `sort/2`, and `[]` if none. `count_equations/2` is the length of that list.
- Tests to write: lengths 0 and 1; a list with no equation (`[2,3,4]`); all PDF examples (`[4,2,5,3]` has seven, `[2,4,8]` has one); a zero as divisor; exact and inexact division; sorted and duplicate-free output; the parenthesis cases from the PDF.
