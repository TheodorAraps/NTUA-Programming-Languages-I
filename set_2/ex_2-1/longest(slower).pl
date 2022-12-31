longest(File, Answer) :-
	read_file(File, Answer).

read_file(File, Answer) :-
	open(File, read, Stream),
	read_line(Stream, [M, N]),
    read_line(Stream, L),
	close(Stream),
    add_n(L, Lp, N),
	prefix_sums(Lp, Prefixsum, Last),
	left(Prefixsum, Left, Lmax),
	reverse(Prefixsum, Revpfxs),
	right(Revpfxs, Right, M, Rmax1),
	reverse(Right, Revright1),
	reverse(Rmax1, Revrmax),
	pop_first(Revrmax, Rmax),
	pop_first(Revright1, Revright),
	find_K(Revright, Left, Lmax, Rmax, A1, 0),	
	answer(Last, A1, Answer, M),
	!.

answer(Last, Maxk, Answer, M) :-
	Last =< 0 -> Answer is M
;	Answer is Maxk.

pop_first([_|T], T).

find_K([], _, _, _, A1, A) :-
	A1 = A.

find_K(_, [-1], _, _, A1, A) :-
	A1 = A.

find_K([H|T], [H1|T1], [L|Lt], [R|Rt], A1, A) :- 
	R =< L -> search_right([H|T], [H1|T1], [L|Lt], [R|Rt], A1, A)
;	H1 < H - 1 -> find_K([H|T], T1, Lt, [R|Rt], A1, A) 
;	find_K(T, [H1|T1], [L|Lt], Rt, A1, A).

search_right([], _, _, A1, A) :-
	A1 = A.

search_right(_, [-1], _, A1, A) :-
	A1 = A.

search_right([H|T], [H1|T1], [L|Lt], [R|Rt], A1, A) :-
	T = [] -> A2 is max(A, H - H1),
	find_K(T, T1, Lt, Rt, A1, A2)
;	nextto(R, Nextr, [R|Rt]),
	Nextr =< L -> search_right(T, [H1|T1], [L|Lt], Rt, A1, A)
;	A2 is max(A, H - H1),
	find_K(T, T1, Lt, Rt, A1, A2).

right([H|T], [H2|T2], M, [H3|T3]) :-
	H2 is M-1,
	H3 is H,
	right(T, H, T2, M-2, T3).

right([], _, [H|T], _, [H3|T3]) :-
	H = -1,
	T = [],
	H3 = 'F',
	T3 = [].

right([H|T], Min, [H2|T2], I, [H3|T3]) :-
	H < Min -> H2 is I, 
	I1 is I - 1,
	H3 is H,
	right(T, H, T2, I1, T3)
;	I1 is I - 1,	
	right(T, Min, [H2|T2], I1, [H3|T3]).

left([H|T], [H2|T2], [H3|T3]) :-
	H2 is 0,
	H3 is H,
	left(T, H, T2, 1, T3).

left([], _, [H|T],_ , [H3|T3]) :-
	H = -1,
	T = [],
	H3 = 'F',
	T3 = [].

left([H|T], Max, [H2|T2], I, [H3|T3]) :-
	H > Max -> H2 is I, 
	H3 is H,
	I1 is I + 1,
	left(T, H, T2, I1, T3)
;	I1 is I + 1,	
	left(T, Max, [H2|T2], I1, [H3|T3]).

add_n([],[], _).
add_n([H|T], [H1|T1], N) :-
	H1 is H + N,
	add_n(T, T1, N).	

prefix_sums(Lp, Pf, Last) :-
    prefix_sums(Lp, 0, Pf, Last).

prefix_sums([H], S, [S1], Last) :-
	S1 is H + S,
	Last is S1.

prefix_sums([H|T], S, [S1|T2], Last) :-
    S1 is H + S,
    prefix_sums(T, S1, T2, Last).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).