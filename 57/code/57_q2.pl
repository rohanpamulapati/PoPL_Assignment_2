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