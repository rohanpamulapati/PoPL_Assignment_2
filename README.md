# CS F301 (PoPL) Assignment 2: Group 57

Group members:
- Rohan Pamulapati (2024A7PS0062H)
- Anirudh R Rao (2024A7PS0022H)

All work is in the `57` folder.

## Who did what

| Problem | File | Done by |
|---|---|---|
| P1 Department puzzle (Prolog) | `57/code/57_q1.pl` | Anirudh |
| P2 Arithmetic equations (Prolog) | `57/code/57_q2.pl` | Rohan |
| S1 Binary tree traversals (Scheme) | `57/code/57_q3.rkt` | Rohan |
| S2 Conditional insert into a nested list (Scheme) | `57/code/57_q4.rkt` | Anirudh |

Rohan also wrote the two skill files. Each of us wrote the tests and prompt logs for our own problems.

## Layout

- `57/code/`: the four solution files
- `57/tests/`: tests, one file per problem (`q1_tests.pl`, `q2_tests.pl`, `q3_calls.rkt`, `q4_tests.rkt`)
- `57/skills/`: `prolog-dev/SKILL.md` and `scheme-dev/SKILL.md`
- `57/prompts/`: the prompts we gave the AI, word for word (`P1.md`, `P2.md`, `S1.md`, `S2.md`)
- `57/P1_REPORT.md`: solution counts for P1 and what they show

## Running the tests

Run these from the repository root.

```
swipl -g run_tests -t halt 57/tests/q1_tests.pl
swipl -q -s 57/tests/q2_tests.pl -g run_tests -t halt
racket 57/tests/q4_tests.rkt
```

For S1, join the code file and the calls file, then run the result (the calls file has no `#lang` line).

In PowerShell:

```
Get-Content 57\code\57_q3.rkt, 57\tests\q3_calls.rkt | Set-Content $env:TEMP\s1_check.rkt
racket $env:TEMP\s1_check.rkt
```

In bash:

```
cat 57/code/57_q3.rkt 57/tests/q3_calls.rkt > /tmp/s1_check.rkt
racket /tmp/s1_check.rkt
```

The output should be 41 lines.