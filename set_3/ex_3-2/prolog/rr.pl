/*kanonikh 2016 permutation(L, P), True otan h P einai kapoia metathesh ths L*/
magic([V1, V2, V3, V4, V5, V6, V7, V8, V9]) :-
	permutation([V1, V2, V3, V4, V5, V6, V7, V8, V9], [1, 2, 3, 4, 5, 6, 7, 8, 9]),
	V1 + V2 + V3 =:= 15,
	V4 + V5 + V6 =:= 15,
	V7 + V8 + V9 =:= 15,
	V1 + V4 + V7 =:= 15,
	V2 + V5 + V8 =:= 15,
	V3 + V6 + V9 =:= 15,
	V1 + V5 + V9 =:= 15,
	V3 + V5 + V7 =:= 15.

/*Dentro*/
/*Briskei olous tous kombous pou vriskontai sto idio epipedo*/
atlevel(nil, _, []).
atlevel(node(X, _, _), 1, [X]).
atlevel(node(_, Left, Right), Level, List) :-
	Level > 1,
	Lm1 is Level - 1,
	atlevel(Left, Lm1, ListL),
	atlevel(Right, Lm1, ListR),
	append(ListL, ListR, List).

/*epistrefei to upsos tou dentrou*/
tree_height(nil, 0).
tree_height(node(_, Left, Right), Height) :-
	tree_height(Left, H1),
	tree_height(Right, H2),
	Height is 1 + max(H1, H2).

/*Epistrefei olous tous kombous tou idiou epipedou*/
bfs_level(Tr, L) :-
	tree_height(Tr, MaxHeight),
	between(0, MaxHeight, Level),
	atlevel(Tr, Level, L).

/*Dentra anaparistountai ws: node(44, leaf, node(46, leaf, leaf))*/
/*megisth timh sto diadiko dentro pou den yperbainei to K*/
floor(node(X, L, R), K, F) :-
	(K =:= X -> F = X
	; K < X -> floor(L,K,F)
	; floor(R,K,F)
	; F = X).

/*kanonikh 2020c*/
max_data(n(Data, List), Max) :-
    max_list(List, Data, Max).

max_list([], Max, Max).
max_list([n(D, L)|Nodes], Data, Max) :-
    CurrentM is max(D, Data),
    max_list(L, CurrentM, ML),
    max_list(Nodes, ML, Max).

find_depth(n(Data,_), Data, 1).
find_depth(n(_,List), Data, Depth) :-
    member(Elem, List),
    find_depth(Elem, Data, ElemDepth),
    Depth is ElemDepth + 1.

/*Kanonikh 2017 S prefixsum*/
running_sum([], _, []).
running_sum([H|T], Prev, [H1|T1]) :-
	H1 is H + Prev,
	running_sum(T, H1, T1).

running_sum2([], _, []).
running_sum2([H|T], P, [H1|T1]) :-
	H is H1 - P,
	P1 is P + H,
	running_sum2(T, P1, T1).
running_sum(L, S) :-
	var(L) -> running_sum2(L, 0, S) 
	;	running_sum(L, 0, S).

/*to subseq epalhtheuei oti to S einai ena opoiodhpote sublist ths L!!*/
subseq([], []).
subseq([H|T], [H|T1]) :-
	subseq(T, T1).
subseq([_|T], S) :- 
	subseq(T, S).
subset_sum(L, Sum, Subset) :-
	subseq(L, Subset),
	foldl(plus, Subset, 0, Sum).

/*Kanonikh 2019*/

increasing([]).
increasing([_]).
increasing([H, K]|T) :- 
	H =< K,
	increasing([K|T]).

incubseq(L, X, S) :-
	length(K, X),
	subseq(L, K),
	increasing(S).

/*Epanalhptikh 2017 True an kapoios kombos T se bathos D exei thn plhroforia X*/
find_depth2([X|_], X, 1).
find_depth2([_|Children], X, D) :-
	member(Child, Children),
	find_depth2(Child, X, DD),
	D is DD + 1.

unique([]).
unique([Item | Rest]) :-
	member(Item, Rest), fail.
unique([_ | Rest]) :-
	unique(Rest).

/*-----------------------------------------------------------*/
round(File, M, C) :-
	open(File, read, Stream),
	read_line(Stream, [N, _]),
    read_line(Stream, Queue),
	close(Stream),
	answer(N, Queue, M, C),
	!.

answer(N, L, M, C) :-
	find_distances(N, L, 0, Dists),
	find_solution(Dists, 999999, 0, M, C).

find_solution([], M, C, M, C).
find_solution([H|T], Om, Oc, M, C) :-
	nth0(0, H, Max),
	nth0(1, H, Sum),
	nth0(2, H, I),
	(Max - (Sum - Max) < 2, Sum < Om) -> 
	find_solution(T, Sum, I, M, C)
;	find_solution(T, Om, Oc, M, C).

find_distances(N, _, N, []).
find_distances(N, L, I, [H|T]) :-
	find_diff(N, L, I, D, 0, Max),
	I2 is I+1,
	foldl(plus, D, 0, Sum),
	H = [Max, Sum, I],
	find_distances(N, L, I2, T).

find_diff(_, [], _, [], Max, Max).
find_diff(N, [H|T], I, [H1|T1], Currentmax, Max) :-
	(H > I -> H1 is N - H + I
;	H =< I -> H1 is I - H),
	(H1 >= Currentmax -> Nmax is H1
;	H1 < Currentmax -> Nmax is Currentmax),
	find_diff(N, T, I, T1, Nmax, Max).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).
