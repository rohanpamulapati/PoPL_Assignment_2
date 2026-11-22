:- consult('../code/57_q2.pl').

% check(Name, Goal): prints ok or FAIL for one test.
check(Name, Goal) :-
    (   call(Goal)
    ->  format("ok   ~w~n", [Name])
    ;   format("FAIL ~w~n", [Name])
    ).

run_tests :-
    split_tests,
    expr_tests,
    string_tests,
    equation_tests.

split_tests :-
    check(split_three,
          findall(L-R, split_list([1,2,3], L, R), [[1]-[2,3], [1,2]-[3]])),
    check(split_two,
          findall(L-R, split_list([a,b], L, R), [[a]-[b]])),
    check(split_one_fails, \+ split_list([a], _, _)),
    check(split_empty_fails, \+ split_list([], _, _)).

expr_tests :-
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

string_tests :-
    check(string_paren_left_lower,
          expr_string(e(*, e(+, n(4), n(2)), n(3)), "(4+2)*3")),
    check(string_no_paren_right_higher,
          expr_string(e(+, n(4), e(*, n(2), n(3))), "4+2*3")),
    check(string_left_same_level,
          expr_string(e(*, e(/, n(8), n(4)), n(2)), "8/4*2")),
    check(string_right_same_level,
          expr_string(e(/, n(8), e(*, n(4), n(2))), "8/(4*2)")),
    check(string_minus_left,
          expr_string(e(-, e(-, n(1), n(2)), n(3)), "1-2-3")),
    check(string_minus_right,
          expr_string(e(-, n(1), e(-, n(2), n(3))), "1-(2-3)")),
    check(string_plus_right,
          expr_string(e(+, n(1), e(+, n(2), n(3))), "1+(2+3)")),
    check(string_plus_left,
          expr_string(e(+, e(+, n(1), n(2)), n(3)), "1+2+3")),
    check(string_both_sides,
          expr_string(e(/, e(+, n(1), n(2)), e(-, n(3), n(4))), "(1+2)/(3-4)")),
    check(string_single_number, expr_string(n(7), "7")),
    check(string_is_string,
          (   expr_string(n(12), S12), string(S12) )).

equation_tests :-
    check(equation_pdf_four,
          (   findall(E, equation_string([4,2,5,3], E), L1),
              sort(L1, S1),
              S1 == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                     "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"] )),
    check(equation_none,
          \+ equation_string([2,3,4], _)),
    check(equation_one,
          findall(E, equation_string([2,4,8], E), ["2*4=8"])),
    check(equation_empty_fails, \+ equation_string([], _)),
    check(equation_single_fails, \+ equation_string([7], _)),
    check(equation_zeros,
          (   findall(E, equation_string([0,0], E), L2), L2 == ["0=0"] )),
    check(equation_is_string,
          (   equation_string([4,2,5,3], E3), string(E3) )).