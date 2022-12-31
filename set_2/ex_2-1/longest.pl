longest(File, Answer) :-
	read_file(File, Answer).

read_file(File, Answer) :-
	open(File, read, Stream),
	read_line(Stream, [M, N]),
    read_line(Stream, L),
	close(Stream),
    change_sign_sub_n(L, Ln, N),
	prefix_sums(Ln, Prefixsum, Last),
	left(Prefixsum, Left),
	reverse(Prefixsum, Revpfxs),
	right(Revpfxs, Right),
	reverse(Right, Revright),
	find_K(Revright, Left, 0, 0, 0, K, M),	
	answer(Last, K, Answer, M),
	!.

answer(Last, Maxk, Answer, M) :-
	M = 0 -> Answer is 0
;	Last >= 0 -> Answer is M
;	Answer is Maxk.

find_K(_, _, M, _, Temp, Maxdiff, M) :-
	Maxdiff = Temp.
find_K(_, _, _, M, Temp, Maxdiff, M) :-
	Maxdiff = Temp.
find_K([H|T], [H1|T1], I, J, Temp, Maxdiff, M) :- 
	H1 < H -> Temp1 is max(Temp, J - I),
	J1 is J + 1,
	find_K(T, [H1|T1], I, J1, Temp1, Maxdiff, M)
;	I1 is I + 1,
	find_K([H|T], T1, I1, J, Temp, Maxdiff, M).

right([H|T], [H1|T1]) :-
	H1 is H,
	right_max(T, T1, H1).

right_max([], [], _).
right_max([H|T], [H1|T1], Max) :-
	H1 is max(H, Max),
	right_max(T, T1, H1).

left([H|T], [H1|T1]) :-
	H1 is H,
	left_min(T, T1, H1).

left_min([], [], _).
left_min([H|T], [H1|T1], Min) :-
	H1 is min(H, Min),
	left_min(T, T1, H1).

change_sign_sub_n([],[], _).
change_sign_sub_n([H|T], [H1|T1], N) :-
	H1 is -H - N,
	change_sign_sub_n(T, T1, N).	

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