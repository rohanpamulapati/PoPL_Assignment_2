
:- begin_tests(q1).

:- consult('../code/57_q1.pl').

test(main_output) :-
    with_output_to(string(Output), main),
    sub_string(Output, _, _, _, "Alex = [design, java, embedded]"),
    sub_string(Output, _, _, _, "Ben = [development, javascript, web]"),
    sub_string(Output, _, _, _, "Carla = [testing, python, AI]"),
    sub_string(Output, _, _, _, "Dana = [research, c++, data]").

test(eight_clues_count) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    assertion(N =:= 3).

test(nine_clues_count) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    assertion(N =:= 1).

test(clue_nine_rejects_other_two) :-
    findall(S,
        (candidate_solution(S),
         satisfies_all([1,2,3,4,5,6,7,8], S),
         \+ clue(9, S)),
        Rejected),
    length(Rejected, N),
    assertion(N =:= 2).

:- end_tests(q1).
