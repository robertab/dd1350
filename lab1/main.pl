% ------------------------------------------------%
% Author		:Robert Åberg, Sara Ervik %
% Logiklaboration 1	:Beviskontroll med Prolog %
% ------------------------------------------------%


verify(InputFileName) :- see(InputFileName),
			 read(Prems), read(Goal), read(Proof),
			 seen,
			 valid_proof_row(Prems, Goal, Proof, []).

% Matchar implikationseleminering.
valid_proof(_, _, [_, P2, impel(R1, R2)], ValidProof):-
    member([R1, P1, _], ValidProof),
    member([R2, imp(P1,P2), _], ValidProof).

% Matchar implikationsintroduktion.
valid_proof(_, _, [_, imp(P1, P2), impint(R1, R2)], ValidProof) :-
    member(List1, ValidProof), member([R1, P1, _], List1),
    member(List2, ValidProof), member([R2, P2, _], List2).

% Matchar "vänster-och-eleminering."
valid_proof(_,_, [_, X, andel1(R1)], ValidProof) :-
    member([R1, and(X, _), _], ValidProof).

% Matchar "höger-och-eleminering"
valid_proof(_,_, [_, X, andel2(R1)], ValidProof) :-
    member([R1, and(_, X), _], ValidProof).

% Matchar ochintroduktion.
valid_proof(_, _, [_, and(X,Y), andint(R1, R2)], ValidProof) :-
    member([R1, X, _], ValidProof),
    member([R2, Y, _], ValidProof).

% Matchar "negationseleminering"
valid_proof(_, _, [_ , cont, negel(R1,R2)], ValidProof) :-
    member([R1, X, _], ValidProof),
    member([R2, neg(X), _], ValidProof).

% Matchar "negationsintroduktion"
valid_proof(_,_, [_ , neg(X), negint(R1, R2)], ValidProof) :-
    member(List1, ValidProof), member([R1, X, assumption], List1),
    member(List2, ValidProof), member([R2, cont, _], List2).

 % Matchar motsägelseeleminering
valid_proof(_, _, [_, _, contel(R2)], ValidProof) :-
    member([R2, cont, _], ValidProof).

% Matchar dubbel-negation-eleminering
valid_proof(_, _, [_, X, negnegel(R1)], ValidProof) :-
    member([R1, neg(neg(X)), _], ValidProof).

% Matchar dubbel-negation-introduktion.				    
valid_proof(_, _, [_, neg(neg(X)), negnegint(R1)], ValidProof) :-
    member([R1, X, _], ValidProof).


% Matchar "eller-eleminering"
valid_proof(_, _, [_, X, orel(R1, R2, R3, R4, R5)], ValidProof) :-
    member([R1, or(Y, Z), _], ValidProof),
    member(List1, ValidProof), member([R2, Y, assumption], List1),
    member(List2, ValidProof), member([R3, X, _], List2),
    member(List3, ValidProof), member([R4, Z, assumption], List3),
    member(List4, ValidProof), member([R5, X, _], List4).


% Matchar "vänster-eller-introduktion"
valid_proof(_, _, [_, or(P1, _), orint1(R1)], ValidProof) :-
    member([R1, P1, _ ] ,ValidProof).

% Matchar "höger-eller-introduktion"
valid_proof(_, _, [_, or(_, P2), orint2(R1)], ValidProof) :-
    member([R1, P2, _ ] ,ValidProof).

% Matchar PBC.
valid_proof(_, _, [_, X, pbc(R1, R2)], ValidProof) :-
    member(List1, ValidProof), member([R1, neg(X), assumption], List1),
    member(List2, ValidProof), member([R2, cont, _], List2).

% Matchar MT.
valid_proof(_, _, [_, neg(X), mt(R1, R2)], ValidProof) :-
    member([R1, imp(X, Y), _], ValidProof),
    member([R2, neg(Y), _], ValidProof).

% Matchar LEM. 
valid_proof(_, _, [_ , or(X, neg(X)), lem], _).

% Kollar om raderna matchar listan med premisser.
valid_proof(Prems, _, [_, X, premise], _):-
    member(X, Prems).

% Matchar Copy.
valid_proof(_, _, [_, X, copy(R1)], ValidProof) :-
    member([R1, X, _], ValidProof).

% "Öppnar" antagningsboxar.
valid_proof(_, _, [[_, _, assumption]|_], _).

% Sista fallet. Skickar bara med den sista raden.
% Vi verifierar också att den sista raden är Goal.
valid_proof_row(Prems, Goal, [H|[]], ValidProof) :-
    valid_proof(Prems, Goal, H, ValidProof),
    member(Goal, H),
    \+ member(assumption, H).

%Delar upp Bevisen i rader.
valid_proof_row(Prems, Goal, [H|Tail], ValidProof) :-
    valid_proof(Prems, Goal, H, ValidProof),
    valid_proof_row(Prems, Goal, Tail, [H|ValidProof]).

