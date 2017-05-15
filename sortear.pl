:-module(_,_).

% Ini ----- IN
% C ------- IN
% N ------- OUT
% P ------- OUT
% Fin ----- IN

sortear(Ini,C,N,P,Fin) :-
  es_lista(Ini),
  es_lista(Fin),
  integer(C),
  C > 0,
  buscarSolucion(..,Posible),
  Posible == Fin.

es_lista(X) :-
        var(X), !,
        fail.
es_lista([]).
es_lista([_|T]) :-
        es_lista(T).
