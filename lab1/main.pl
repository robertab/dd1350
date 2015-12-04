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

% Matchar "vänster-och-eleminering."
valid_proof(_,_, [_, X, andel1(R1)], ValidProof) :-
    member([R1, and(X, _), _], ValidProof).

% Matchar "höger-och-eleminering"
valid_proof(_,_, [_, X, andel2(R1)], ValidProof) :-
    member([R1, and(_, X), _], ValidProof).

% Matchar ochintroduktion.
valid_proof(_, _, [_, and(X,Y), andint(R1, R2)], ValidProof) :-
    \+ (X = Y),
    member([_, R1, X, _], ValidProof),
    member([R2, Y, _], ValidProof).

% Matchar "negationseleminering"
valid_proof(_, _, [_ , cont, negel(R1,R2)], ValidProof) :-
    member([R1, X, _], ValidProof),
    member([R2, neg(X), _], ValidProof).

 % Matchar motsägelseeleminering
valid_proof(_, _, [_, _, contel(R2)], ValidProof) :-
    member([R2, cont, _], ValidProof).

% Matchar dubbel-negation-eleminering
valid_proof(_, _, [_, X, negnegel(R1)], ValidProof) :-
    member([R1, neg(neg(X)), _], ValidProof).

% Matchar dubbel-negation-introduktion.				    
valid_proof(_, _, [_, neg(neg(X)), negnegint(R1)], ValidProof) :-
    member([R1, X, _], ValidProof).

% Matchar LEM. 
valid_proof(_, _, [_ , or(X, neg(X)), lem], _).

% Kollar om raderna matchar listan med premisser.
valid_proof(Prems, _, [_, X, premise], _):-
    member(X, Prems).

% Sista fallet. Skickar bara med den sista raden.
valid_proof_row(Prems, Goal, [H|[]], ValidProof) :-
    valid_proof(Prems, Goal, H, ValidProof).
%    \+ member(Goal, ValidProof).


%Delar upp Bevisen i rader.
valid_proof_row(Prems, Goal, [H|Tail], ValidProof) :-
    valid_proof(Prems, Goal, H, ValidProof),
    valid_proof_row(Prems, Goal, Tail, [H|ValidProof]).

