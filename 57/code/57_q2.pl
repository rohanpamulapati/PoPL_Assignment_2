% split_list(List, Left, Right): List is Left followed by Right, and both
% Left and Right are non-empty. On backtracking it gives every such split.
% Base case: Left is just the first element and Right is the rest, which
% must not be empty.
% Recursive case: Left starts with the first element and the rest of the
% list is split the same way.
split_list([First|Rest], [First], Rest) :-
    Rest = [_|_].
split_list([First|Rest], [First|Left], Right) :-
    split_list(Rest, Left, Right).

% apply_op(Op, Left, Right, Value): Value is Left combined with Right by Op.
% Division only holds when the divisor is not zero and the result is exact.
apply_op(+, Left, Right, Value) :-
    Value is Left + Right.
apply_op(-, Left, Right, Value) :-
    Value is Left - Right.
apply_op(*, Left, Right, Value) :-
    Value is Left * Right.
apply_op(/, Left, Right, Value) :-
    Right =\= 0,
    Left mod Right =:= 0,
    Value is Left // Right.

% expr(List, Tree, Value): Tree is an expression tree over all numbers of
% List, in order, and Value is its integer value.
% Base case: a list with one number is the tree n(Number) with that value.
% Recursive case: split the list into a left and a right part, build a tree
% for each, and join them with an operator whose result is valid.
expr([Number], n(Number), Number).
expr(List, e(Op, LeftTree, RightTree), Value) :-
    split_list(List, Left, Right),
    expr(Left, LeftTree, LeftValue),
    expr(Right, RightTree, RightValue),
    apply_op(Op, LeftValue, RightValue, Value).

% prec(Op, Level): * and / bind tighter than + and -.
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

% needs_parens(Side, Level, ParentLevel): an operand with top operator Level
% needs parentheses. A left operand only if its level is lower than its
% parent's; a right operand if its level is lower or the same.
needs_parens(left, Level, ParentLevel) :-
    Level < ParentLevel.
needs_parens(right, Level, ParentLevel) :-
    Level =< ParentLevel.

% operand_string(Tree, Side, ParentLevel, String): String is the text of Tree
% as the Side operand of an operator at ParentLevel, with parentheses if the
% rule above asks for them. A single number never gets parentheses.
operand_string(n(Number), _, _, String) :-
    format(string(String), "~d", [Number]).
operand_string(e(Op, Left, Right), Side, ParentLevel, String) :-
    expr_string(e(Op, Left, Right), Inner),
    prec(Op, Level),
    (   needs_parens(Side, Level, ParentLevel)
    ->  format(string(String), "(~w)", [Inner])
    ;   String = Inner
    ).

% expr_string(Tree, String): String is the canonical text of Tree, without
% spaces.
% Base case: a number is written in decimal.
% Recursive case: write both operands, with parentheses where needed, and
% put the operator between them.
expr_string(n(Number), String) :-
    format(string(String), "~d", [Number]).
expr_string(e(Op, Left, Right), String) :-
    prec(Op, Level),
    operand_string(Left, left, Level, LeftString),
    operand_string(Right, right, Level, RightString),
    format(string(String), "~w~w~w", [LeftString, Op, RightString]).