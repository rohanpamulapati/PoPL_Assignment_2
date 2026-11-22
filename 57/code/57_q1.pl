:- use_module(library(lists)).

% candidate_solution(Solution): assigns each attribute exactly once.
candidate_solution([
    p('Alex', AlexDept, AlexLang, AlexProject),
    p('Ben', BenDept, BenLang, BenProject),
    p('Carla', CarlaDept, CarlaLang, CarlaProject),
    p('Dana', DanaDept, DanaLang, DanaProject)
]) :-
    permutation(
        [research, development, design, testing],
        [AlexDept, BenDept, CarlaDept, DanaDept]
    ),
    permutation(
        [python, java, 'c++', javascript],
        [AlexLang, BenLang, CarlaLang, DanaLang]
    ),
    permutation(
        ['AI', web, embedded, data],
        [AlexProject, BenProject, CarlaProject, DanaProject]
    ).
% clue(1, Solution): The AI-project friend is neither in research nor Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.
% clue(2, Solution): Alex is neither in development nor a C++ user.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.
% clue(3, Solution): The friend working in testing likes Python.
clue(3, Solution) :-
    member(p(_, testing, python, _), Solution).
% clue(4, Solution): Ben prefers web and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \= testing.
% clue(5, Solution): The Java user works in design.
clue(5, Solution) :-
    member(p(_, design, java, _), Solution). 