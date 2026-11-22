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