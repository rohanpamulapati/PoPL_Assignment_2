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
% clue(6, Solution): Carla is not on embedded and not in development.
clue(6, Solution) :-
    member(p('Carla', Dept, _, Project), Solution),
    Dept \= development,
    Project \= embedded.

% clue(7, Solution): Dana is not using Java and works in research or testing.
clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \= java,
    (Dept = research ; Dept = testing).

% clue(8, Solution): Data project belongs to research and not JavaScript.
clue(8, Solution) :-
    member(p(_, research, Lang, data), Solution),
    Lang \= javascript.

