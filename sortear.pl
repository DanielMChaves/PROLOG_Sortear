:-module(_,_).

% Ini ----- IN
% C ------- IN
% N ------- OUT
% P ------- OUT
% Fin ----- IN

sortear(Ini,C,N,P,Fin) :-
  esLista(Ini),
  esLista(Fin),
  integer(C),
  C > 0,
  length(Ini,TIni),
  generarP(TIni,LP),
  generarN(C,LN),
  productoCartesiano(LP,LN,LCartesiano).
%  length(Fin,TFin),
%  buscarSolucion(..,TFin,Posible),
%  Posible == Fin.

% esLista/1: Comprueba que el elemento pasado es una lista
esLista(X) :-
        var(X), !,
        fail.
esLista([]).
esLista([_|T]) :-
        esLista(T).

% generarP/2: Genera una lista con los valores que puede tomar P
generarP(C,LN) :-
  generarPAux(C,1,LN).

generarPAux(C,C,[C]) :- !.
generarPAux(C,Valor,[Valor|LNs]) :-
  Nuevo is Valor + 1,
  generarPAux(C,Nuevo,LNs).

% generarN/2: Genera una lista con los valores que puede tomar N
generarN(C,LN) :-
  generarNAux(C,1,LN).

generarNAux(C,C,[C]) :- !.
generarNAux(C,Valor,[Valor|LNs]) :-
  Nuevo is Valor + 1,
  generarNAux(C,Nuevo,LNs).

% productoCartesiano/3: Genera una lista de listas con los productos
% cartesianos de P y N
productoCartesiano(L1,L2,L3):-
  productoCartesianoAux(L1,L2,L3,L1).

productoCartesianoAux(_,[],[],_).
productoCartesianoAux([],[_|T2],L3,L4):-
    productoCartesianoAux(L4,T2,L3,L4).
productoCartesianoAux([H1|T1],[H2|T2],[[H1,H2]|T3],L4):-
  productoCartesianoAux(T1,[H2|T2],T3,L4).
