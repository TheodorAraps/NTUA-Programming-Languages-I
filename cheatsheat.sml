(*datatype 'a tree = Leaf
| Node of int * 'a tree * 'a tree

fun trim t =
	let fun walk Leaf newtree = newtree
		|	walk (Node(x, Node(xl, ll, rl), Node(xr, lr, rr))) newtree =
			if((xl%2 = 0) andalso (xr%2 = 0)) then walk (Node(xl, ll, rl)) (newtree(x, Node(xl, ll, rl), Node(xr, lr, rr)))))
			else if xl%2 = 0 andalso xr%2 <> 0 then walk Node(xl, ll, rl) newtree(x, Node(xl, ll, rl), Leaf)))
			else if xr%2 = 0 then walk Node(xr, ll, rl) newtree(x, Leaf, Node(xr, lr, rr))))
			else walk Leaf newtree
	in 
		walk t Leaf
	end*)
fun common_prefix x y =
	let fun aux (h1 :: t1) (h2 :: t2) prefix =
            if h1 = h2 then aux t1 t2 (h1::prefix)
              else (rev prefix,(h1::t1),(h2::t2))
        |	aux s1 s2 prefix = (prefix, [], [])
  	in  aux x y []
  	end
