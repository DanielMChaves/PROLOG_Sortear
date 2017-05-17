:-module(_,_).

% Modo de Uso
%
% Ini ----- IN
% C ------- IN
% N ------- OUT
% P ------- OUT
% Fin ----- IN

sortear([],_,_,_,[]).
sortear(Ini,C,N,P,Fin) :-
  esLista(Ini),
  esLista(Fin),
  integer(C),
  C > 0,
  length(Ini,TIni),
  generarP(TIni,LP),
  generarN(C,LN),
  productoCartesiano(LP,LN,LCartesiano),
  length(Fin,TFin),
  obtenerSolucion(Ini,Fin,LCartesiano,TFin,P,N).

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

% obtenerSolucion/6: Genera y comprueba las soluciones
obtenerSolucion(Ini,Fin,[[P,N]|_],TFin,P,N) :-
  prepararLista(Ini,P,N,TFin,Posible),
  Fin == Posible, !.
obtenerSolucion(Ini,Fin,[_|LCs],TFin,P,N) :-
  obtenerSolucion(Ini,Fin,LCs,TFin,P,N).
obtenerSolucion(_,_,[],_,_,_) :-
  fail.

% HASTA AQUI BIEN
% prepararLista/5: Genera listas de soluciones
prepararLista(Ini,P,N,TFin,Posible) :-
  seleccionarPosicion(Ini,P,LP),
  eliminarElementos(Ini,LP,N,N,TFin,Posible).

% seleccionarPosicion/3: Genera una lista con la posicion dada
seleccionarPosicion(Ini,1,Ini).
seleccionarPosicion([_|CIs],P,LP2) :-
  Nuevo is P - 1,
  seleccionarPosicion(CIs,Nuevo,LP2).

% Posible Backtraking
% CASO: Contador a 0
eliminarElementos(LP1,[E|LP2s],N,1,TFin,PD) :-
  eliminarElegido(LP1,[E|LP2s],LP1Mitad),
  append(LP1Mitad,LP2s,LP),
  eliminarElementos(LP,LP2s,N,N,TFin,PD).
% CASO: Fin del Eliminado
eliminarElementos(CLP,LP,_,N,TFin,CLP) :-
  LP \= [],
  N =\= 1,
  length(CLP,TCLP),
  TCLP =:= TFin, !.
% CASO: Lista vacia
eliminarElementos(LP,[],N,CN,TFin,PD) :-
  eliminarElementos(LP,LP,N,CN,TFin,PD).
% CASO: Avance
eliminarElementos(LP,[_|CLPs],N,CN,TFin,PD) :-
  Nuevo is CN - 1,
  Nuevo > 0,
  eliminarElementos(LP,CLPs,N,Nuevo,TFin,PD).

eliminarElegido(LP1,[E|LP2],LF) :-
  reverse(LP1,RLP1),
  length([E|LP2],TLP2),
  eliminarNElementos(RLP1,TLP2,RLF),
  reverse(RLF,LF).

eliminarNElementos(X,0,X).
eliminarNElementos([_|Xs],N,R) :-
  Nuevo is N - 1,
  eliminarNElementos(Xs,Nuevo,R).
%remove_first_X(X,[X|Xs],Xs).
%remove_first_X(X,[Y|Xs],[Y|Ys]) :-
%  X \= Y,
%  remove_first_X(X,Xs,Ys).

% Pruebas

% ?- eliminarElementos([a,b,c,d],[c,d],3,3,2,X).

% ? - sortear([a,b,c,d,e,f],3,N,P,[a,c,d]).
%
% N = 3
% P = 3

% ?- sortear([m,m,h,m,h,h,m,h,m,h],20,N,P,[h,h,h,h,h]).
%
% N = 11
% P = 2

% ?- sortear([m,m,h,m,h,h,m,h,m,h],30,N,P,[m,m,m,m,m]).
%
% N = 29
% P = 10
