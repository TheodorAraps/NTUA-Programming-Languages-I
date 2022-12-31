(* Again we use kruskal algorithm as the cpp version, though we are not able to produce the ElogV version
   of the algorithm as the nature of the functional languages doesn't allow as to do a purely functional 
   implementation of union-find. There are some iplementations however but are more advanced for the level 
   of our current subject,*)
fun parse file =
    let
        fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    	val inStream = TextIO.openIn file

		val N = readInt inStream
		val M = readInt inStream
		val _ = TextIO.inputLine inStream

		fun readInts 0 edges = edges 
	  	  | readInts i edges = 
                let
                    val X = readInt inStream
                    val Y = readInt inStream
		            val W = readInt inStream
		            val _ = TextIO.inputLine inStream
                in
                    readInts (i - 1) ([W, X, Y] :: edges)
                end
    in
   		(N, M, readInts M [])
    end

fun parentList 0 _ = []
  | parentList i N = 
    (N - i) :: (parentList (i - 1) N)

fun find parent old_i = 
    let 
        val i = old_i - 1
    in
        if Array.sub (parent, i) = i
        then 
            i
        else
            let
                val _ = Array.update (parent, i, (find parent ((Array.sub (parent, i)) + 1)))
            in
                Array.sub (parent, i)
            end
    end

fun union parent x y = Array.update (parent, y, x)

fun min_fill file =
    let
        val (N, M, edges) = parse file
        val sortedEdges = ListMergeSort.sort (fn (w1, w2) => List.hd w1 > List.hd w2) edges
        val parentL = parentList N N
        val parent = Array.fromList parentL
        fun kruskal [] max _ _ = max
          | kruskal (H :: T) max N length = 
            let
                val [W, X, Y] = H
                val rep_x = find parent X
                val rep_y = find parent Y
            in
                if rep_x <> rep_y
                then
                    let
                        val _ = union parent rep_x rep_y
                    in
                        if length = N - 1
                        then
                            max
                        else
                            kruskal T W N (length + 1)
                    end
                else
                    kruskal T max N length
            end
    in
        print(Int.toString (kruskal sortedEdges 0 N 0) ^ "\n")
    end