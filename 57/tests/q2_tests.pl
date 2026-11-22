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
    check(split_empty_fails, \+ split_list([], _, _)),
    check(expr_single,
          findall(T-V, expr([5], T, V), [n(5)-5])),
    check(expr_two,
          findall(V, expr([2,3], _, V), [5,-1,6])),
    check(expr_exact_division,
          findall(V, expr([6,3], _, V), [9,3,18,2])),
    check(expr_zero_divisor,
          findall(V, expr([4,0], _, V), [4,4,0])),
    check(expr_zero_dividend,
          findall(V, expr([0,4], _, V), [4,-4,0,0])),
    check(expr_negative_inside,
          (   expr([3,5,2], e(/, e(-, n(3), n(5)), n(2)), V1), V1 =:= -1 )),
    check(expr_inexact_division_rejected,
          \+ expr([3,5,2], e(/, n(3), e(+, n(5), n(2))), _)),
    check(expr_empty_fails, \+ expr([], _, _)),
    check(expr_count_four,
          (   aggregate_all(count, expr([4,2,5,3], _, _), N4), N4 =:= 176 )).