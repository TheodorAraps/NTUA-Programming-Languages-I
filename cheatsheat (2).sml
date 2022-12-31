(*Kanonikh 2016// listify:printarei mia lista apo listes me auksousa seira sortarismenes*)
fun listify [] = [[]]
|	listify L =
	let 
		fun traverse (el, [[]]) = [[el]]
		|	traverse (el, (lel::lg)::rest) = if el >= lel then (el::lel::lg)::rest else [el]::(lel::lg)::rest
		val result = foldl traverse [[]] L
	in
		rev (map rev result)
	end

(*kanonikh 19 megisth timh pou den yperbainei to k se diadiko dentro*)
(*datatype gia dentro*)
datatype 'a tree = Leaf
| Node of int * 'a tree * 'a tree

fun floor t k =
	let fun walk Leaf sofar = sofar
		|	walk (Node(x,l,r)) sofar =
			if k = x then SOME x
			else if k < x then walk l sofar
			else walk r (SOME x)
	in 
		walk t NONE
	end

(*Ypothetikh synarthsh sort/2*)
(*fun lenfreqsort [] = []
|	lenfreqsort L = 
	let
		fun fcmp L1 L2 = length(L1) > length(L2) 
		val sort_list_length = sort fcmp L
		fun same_length (el, [[]]) = [[el]]
		|	same_length (el, (lastel::groupel)::rest) = if length(el) = length(lastel) then (el::lastel::groupel)::rest else [el]::(lastel::groupel)::rest
		val sl = foldl same_length [[]] sort_list_length
		val res = sort fcmp sl
	in
		List.concat res
	end
*)

(*Kanonikh 2017 (foldl example), *)
fun listify17 [] x = [[]]
|	listify17 ls x = 
	let
		fun traverse (el,[[]]) = 
		if el < x then [[el]] else [[el], []]
		|	traverse (el, (ln::pn)::t) = if (el < x) = (ln < x) then (el::ln::pn)::t else [el]::(ln::pn)::t
		val res = foldl traverse [[]] ls
	in
		rev (map rev res)
	end
(*megisto athroisma sunexomenw akeraiwn se lista (kadane algorithm)*)
fun maxSubList L = 
	let
		fun traverse (el, (max_till_prev, curr_max)) =
			let	
				val max_here = Int.max(max_till_prev + el, el)
				val best_max = Int.max(max_here, curr_max)
			in
				(max_here, best_max)
			end
		val (_, res) = foldl traverse (0, 0) L
	in
		res
	end

(*Kanonikh 2020c*)
fun reconstruct L = 
	let
		fun traverse(el, [[]]) = [[el]]
		|	traverse(el, (ln::pn)::t) = if length(pn) = ln then [el]::(ln::pn)::t else (el::ln::pn)::t 
		val res = foldr traverse [[]] L
	in
		res
	end

(*elegxei an einai prwtos*)
fun check k n =
	k * k > n orelse
	n mod k <> 0 andalso
	check (k+2) n

fun prime 2 = true
|	prime n = n mod 2 <> 0 andalso check 3 n

fun enum low high ls = 
	if low <= high then enum (low+1) high (low::ls) else rev ls

(*Epanalhptikh 2017 Isozugismeno dentro, komboi ektos isorropias*)
fun sizeUnbalanced empty = (0, 0)
|	sizeUnbalanced (node (_, left, right)) =
	let
		val (sLeft, uLeft) = sizeUnbalanced left
		val (sRight, uRight) = sizeUnbalanced right
	in
		(
			sLeft + sRight + 1, (* number of nodes under this tree *)
			uLeft + uRight + (if sLeft = sRight then 0 else 1)
		)
	end;
fun countUnbalanced T = #2(sizeUnbalanced T)

(*Kanonikh 2019 Lista me oles tis upoakolouthies tis L*)
fun allsubseq xs =
	let fun nonempty [] = []
		|	nonempty (x::xs) =
			let fun walk [] acc = rev acc
				|	walk (ys::yss) acc =
					walk yss ((x::ys)::ys::acc)
			in 
				walk (nonempty xs) [[x]]
			end
	in 
		[]::nonempty xs
	end

(*Epanalhptikh 2020*)
fun bidlist kvs =
	let fun walk [] next acc = List.rev acc
		|	walk ((k, v) :: rest) next acc =
		if k = next	then walk rest (next + 1) (v :: acc)
		else if k = next - 1 then walk rest next ((v + hd acc) :: tl acc)
		else walk ((k, v) :: rest) (next + 1) (0 :: acc)
	fun keycomp ((k1, v1), (k2, v2)) = k1 > k2
in 
	walk (ListMergeSort.sort keycomp kvs) 0 []
end*)

fun sth x = 
	let fun sth_else y = x + y 
	in sth_else 2
	end

(*fun common_prefix x y =
	let fun aux (h1 :: t1) (h2 :: t2) prefix sofar =
			if h1 = h2 then aux t1 t2 h1::prefix sofar
			else if length 
		|	aux s1 s2 prefix sofar = ???
	in 
		aux x y [] []
	end*)
