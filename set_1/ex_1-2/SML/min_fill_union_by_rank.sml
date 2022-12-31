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

fun union parent rank x y = 
    if (Array.sub (rank, x) < Array.sub (rank, y))
    then
        let
            val _ = Array.update (parent, x, y)
            val _ = Array.update (rank, y, (Array.sub (rank, x) + Array.sub (rank, y)))
        in
            0
        end
    else if (Array.sub (rank, x) > Array.sub (rank, y))
    then
        let
            val _ = Array.update (parent, y, x)
            val _ = Array.update (rank, x, (Array.sub (rank, x) + Array.sub (rank, y)))
        in
            0
        end
    else
        let
            val _ = Array.update (parent, y, x)
            val _ = Array.update (rank, x, (Array.sub (rank, x) + 1))
        in
            0
        end


fun smalltank file =
    let
        val (N, M, edges) = parse file
        val sortedEdges = ListMergeSort.sort (fn (w1, w2) => List.hd w1 > List.hd w2) edges
        val parentL = parentList N N
        val parent = Array.fromList parentL
        val rank = Array.array (N, 1)
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
                        val _ = union parent rank rep_x rep_y
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