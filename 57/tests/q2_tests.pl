:- consult('../code/57_q2.pl').

% check(Name, Goal): prints ok or FAIL for one test.
check(Name, Goal) :-
    (   call(Goal)
    ->  format("ok   ~w~n", [Name])
    ;   format("FAIL ~w~n", [Name])
    ).

run_tests :-
    check(split_three,
          findall(L-R, split_list([1,2,3], L, R), [[1]-[2,3], [1,2]-[3]])),
    check(split_two,
          findall(L-R, split_list([a,b], L, R), [[a]-[b]])),
    check(split_one_fails, \+ split_list([a], _, _)),
    check(split_empty_fails, \+ split_list([], _, _)).