:-module(_,_).

% Modo de Uso
%
% Ini ----- IN    Ini ----- IN    Ini ----- IN    Ini ----- IN
% C ------- IN    C ------- IN    C ------- IN    C ------- IN
% N ------- OUT   N ------- IN    N ------- OUT   N ------- IN
% P ------- OUT   P ------- OUT   P ------- IN    P ------- IN
% Fin ----- IN    Fin ----- IN    Fin ----- IN    Fin ----- IN

sortear([],_,_,_,[]).
sortear(Ini,C,N,P,Fin) :-
  esLista(Ini),
  esLista(Fin),
  integer(C),
  C > 0,
  length(Ini,TIni),
  findall([X,Y],(between(1,TIni,X),between(1,C,Y)),LCartesiano),
  length(Fin,TFin),
  obtenerSolucion(Ini,Fin,LCartesiano,TFin,P,N).

% esLista/1: Comprueba que el elemento pasado es una lista
esLista(X) :-
        var(X), !,
        fail.
esLista([]).
esLista([_|T]) :-
        esLista(T).

% obtenerSolucion/6: Genera y comprueba las soluciones
obtenerSolucion(Ini,Fin,[[P,N]|_],TFin,P,N) :-
  prepararLista(Ini,P,N,TFin,Posible),
  Fin == Posible, !.
obtenerSolucion(Ini,Fin,[_|LCs],TFin,P,N) :-
  obtenerSolucion(Ini,Fin,LCs,TFin,P,N).
obtenerSolucion(_,_,[],_,_,_) :-
  fail.

% prepararLista/5: Genera listas de soluciones
prepararLista(Ini,P,N,TFin,Posible) :-
  seleccionarPosicion(Ini,P,LP),
  eliminarElementos(Ini,LP,N,N,TFin,Posible).

% seleccionarPosicion/3: Genera una lista con la posicion dada
seleccionarPosicion(Ini,1,Ini).
seleccionarPosicion([_|CIs],P,LP2) :-
  Nuevo is P - 1,
  seleccionarPosicion(CIs,Nuevo,LP2).

% eliminarElementos/6: Metodo que gestiona el eliminado
% del elemento correspondiente
% CASO: Eliminar
eliminarElementos(LP1,[E|LP2s],N,1,TFin,PD) :-
  N =\= 1,
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
  N =\= 1,
  Nuevo is CN - 1,
  Nuevo > 0,
  eliminarElementos(LP,CLPs,N,Nuevo,TFin,PD).

% eliminarElegido/3: Elimina el elemento de la lista
eliminarElegido(LP1,[E|LP2],LF) :-
  reverse(LP1,RLP1),
  length([E|LP2],TLP2),
  eliminarNElementos(RLP1,TLP2,RLF),
  reverse(RLF,LF).

eliminarNElementos(X,0,X).
eliminarNElementos([_|Xs],N,R) :-
  Nuevo is N - 1,
  eliminarNElementos(Xs,Nuevo,R).

% Pruebas

% ? - sortear([a,b,c,d,e,f],4,N,P,[a,c,d]).
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
