round(File, M, C) :-
	open(File, read, Stream),
	read_line(Stream, [N, K]),
    read_line(Stream, L),
	close(Stream),
	/*We sort the initial list so that we can count the number of cars in each city more easily*/
	msort(L, Sort), 
	find_city_list(0, 0, 0, Sort, [H|Citylist], N),
	find_distance0(N, L, Sum),
	new_max_index([H|Citylist], 1, Maxi),
	find_solution(Citylist, 1, Maxi, Sum, N, K, Sum, 0, M, C),
	!.	

/*Maini index traverses the whole list containing the number of cars in each city (starting from second elemend, index 1)
Maxi is always bigger than Maini and its value corresponds to a non zero value of the list (if there is none, it takes the value of 0 and never changes).
From these two indexes we calculate the max distance of some car from a possible final state (Maini), in every loop.
Also in every loop we increase Maini by one (Maini indicates the next possible final city, so we check every city) until we reach the end of the list and we
also calculate the new Sum of the distances of each city from the final state. At last, we check if the new Sum and the max distance evaluate the main condition of the problem (sum - max +1 >= max).
If they do, we update the current M (Min) and C (City) (instantiated by the sum of the distances from city 0) only if the new Sum is lower than Min.
(in this way we also satisfy the condition of the smallest possible city number). */
find_solution([], N, _, _, N, _, M, C, M, C).
find_solution([H|T], Maini, Maxi, Sum, N, K, Min, City, M, C) :-
	Newsum is Sum + K - N*H,
	(Maxi > 0 -> Maxdist is N - Maxi + Maini
;	Maxdist is Maini - Maxi),
	Newmaini is Maini + 1,
	(Newmaini = Maxi -> new_max_index(T, Newmaini, Newmaxi)
;	Newmaxi is Maxi),
	(((Newsum - Maxdist + 1 >= Maxdist), (Newsum < Min)) -> Newmin is Newsum,
	Newcity is Maini
;	Newmin is Min,
	Newcity is City),
	find_solution(T, Newmaini, Newmaxi, Newsum, N, K, Newmin, Newcity, M, C).

/*Find the next Index of Maxi (Non-zero)*/
new_max_index([_, H|T], I, Maxi) :-
	find_non_zero([H|T], I, Maxi).
new_max_index(_, _, 0).

/*Find next non-zero valid for Maxi index*/
find_non_zero([], _, 0).
find_non_zero([H|T], I, Maxi) :-
	H = 0 -> I1 is I + 1,
	find_non_zero(T, I1, Maxi)
;	Maxi is I.

/*Create a list of length N (number of cities) and count the number of cars in each city (index 0 -> city 0, index 1 -> city 1 etc.)*/
find_city_list(N, _, _, [], [], N).
find_city_list(Index, _, Counter, [], [H|T], N) :-
	H is Counter,
	Index1 is Index + 1,
	find_city_list(Index1, 0, 0, [], T, N).
find_city_list(Index, Prev, Counter, [H|T], [Hc|Tc], N) :-
	H = Prev -> Counter1 is Counter + 1,
	find_city_list(Index, H, Counter1, T, [Hc|Tc], N)
;	Counter1 is 0,
	Hc is Counter,
	Index1 is Index + 1,
	find_city_list(Index1, Index1, Counter1, [H|T], Tc, N).

/*Returns the Sum of the distances from city 0*/
find_distance0(N, L, Sum) :-
	find_distances(N, L, D),
	foldl(plus, D, 0, Sum).

/*This predicate finds the distances of each car from city 0*/	
find_distances(_, [], []).
find_distances(N, [H|T], [H1|T1]) :-
	(H > 0 -> H1 is N - H
;	H1 is 0),
	find_distances(N, T, T1).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).
