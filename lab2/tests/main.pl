verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F).

% Undersöker alla möjliga övergångar
check_all_transitions(T, L, S, U, F) :-
    member([S, N], T),
    check_all_states(T, L, U, F, N).

% Undersöker alla tillstånd
check_all_states(_, _, _, _, []).
check_all_states(T, L, U, F, [H|Tail]) :-
    check(T, L, H, U, F),
    check_all_states(T, L, U, F, Tail).

% Undersöker någon övergångar
check_some_transitions(T, L, S, U, F) :-
    member([S, N], T),
    check_some_states(T, L, U, F, N),!.

% Undersöker något tillstånd
check_some_states(T, L, U, F, [H|Tail]) :-
    check(T, L, H, U, F);
    check_some_states(T, L, U, F, Tail),!.


check(_, L, S, [], X) :-
    member([S, A], L),
    member(X, A).

check(_, L, S, [], neg(X)) :-
    member([S, A], L),
    \+ member(X, A).

check(T, L, S, [], and(F,G)) :-
    check(T, L, S, [], F),
    check(T, L, S, [], G).

check(T, L, S, [], or(F,G)) :-
    check(T, L, S, [], F);
    check(T, L, S, [], G).

% AX: Undersökert alla vägar där nästa tillstånd gäller
check(T, L, S, [], ax(F)) :-
    check_all_transitions(T, L, S, [], F).

% AG1
check(_, _, S, U, ag(_)) :-
    member(S, U).

% AG2
% Verifierar att det nuvarande tillståndent inte
% finns i de besökta tillstånden.
check(T, L, S, U, ag(F)) :-
    \+ member(S, U),
    check(T, L, S, [], F),
    check_all_transitions(T, L, S, [S|U], ag(F)).

% AF1
check(T, L, S, U, af(F)) :-
    \+ member(S, U),
    check(T, L, S, [], F).

% AF2: Undersöker alla vägar där något framtida tillstånd gäller
check(T, L, S, U, af(F)) :-
    \+ member(S, U),
    check_all_transitions(T, L, S, [S|U], af(F)).

% EX: Undersöker någon övergång där nästa tillstånd gäller
check(T, L, S, [], ex(F)) :-
    check_some_transitions(T, L, S, [], F).

% EG1
check(_, _, S, U, eg(_)) :-
    member(S, U).

% EG2: Undersökert någon övergång där alla framtida tillstånd gäller
check(T, L, S, U, eg(F)) :-
    \+ member(S, U),
    check(T, L, S, [], F),
    check_some_transitions(T, L, S, [S|U], eg(F)).

% EF1: Undersöker någon övergång där något framtida tillstånd gäller
check(T, L, S, U, ef(F)) :-
    \+ member(S,U),
    check(T, L, S, [], F).

% EF2: -||-
check(T, L, S, U, ef(F)) :-
    \+ member(S,U),
    check_some_transitions(T, L, S, [S|U], ef(F)).
