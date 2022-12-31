qssort(File, Answer) :-
	open(File, read, Stream),
	read_line(Stream, _),
    read_line(Stream, Queue),
	close(Stream),
	msort(Queue, Sort),
	answer(Queue, Sort, Answer),
	!.

answer(Queue, Sort, Answer) :-
	are_equal(Queue, Sort) -> Answer = 'empty'
;	find_sequence(Queue, Sort, 2, Answer).

get_qs([T], _) :-
	T = 'S'.
get_qs([H|T], Qs) :- 
	member(H, Qs), 
	get_qs(T, Qs).

find_one_qs(Length, Qs_list_string) :- 
	length(['Q'|T], Length),
	get_qs(T, ['Q', 'S']),
	Qs_length is (Length - 2)//2,
	qcount(T, 0, Qs_length),
	atomics_to_string(['Q'|T], Qs_list_string).

qcount(['S'], Qc, Qs_length) :-
	Qc = Qs_length.
qcount([H|T], Qc, Qs_length) :-
	H = 'Q' -> Qc1 is Qc + 1,
	qcount(T, Qc1, Qs_length)
;	qcount(T, Qc, Qs_length).

find_sequence(Queue, Sort, I, Result1) :-
	findall(Qs_list, find_one_qs(I, Qs_list), Lqsl),
	check(Lqsl, Queue, Sort, R, Flag),
	Flag = 1 -> Result1 = R
;	I1 is I + 2,
	find_sequence(Queue, Sort, I1, Result1).

check([], _, _, _, Flag) :-
	Flag = 0.

check([H|T], Queue, Sort, R, Flag) :-
	string_chars(H, Chars),
	evaluate(Chars, Queue, Sort, []) -> R = H,
	Flag = 1
;	check(T, Queue, Sort, R, Flag).

evaluate([], Nqueue, Sort, []) :-
	are_equal(Nqueue, Sort).

evaluate([H|T], Queue, Sort, Stack) :-
	H = 'Q' ->
	q_com(Queue, Nqueue, Stack, Nstack),
	evaluate(T, Nqueue, Sort, Nstack)
;	H = 'S' ->
	s_com(Queue, Nqueue, Stack, Nstack),
	evaluate(T, Nqueue, Sort, Nstack).

q_com([], [], _, _) :- fail.
q_com([H|T], T, [], [H]).
q_com([H|T], T, [H1|T1], [H, H1|T1]).

s_com(_, _, [], []) :- fail.
s_com(Oldqueue, Newqueue, [H|T], T) :-
	append(Oldqueue, [H], Newqueue).

are_equal([], []).
are_equal([H|T], [H1|T1]) :-
	H = H1,
	are_equal(T, T1).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).