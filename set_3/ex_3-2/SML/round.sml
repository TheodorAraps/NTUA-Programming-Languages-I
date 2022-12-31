(* Αλγόριθμος: Ελέγχουμε τις πόλεις από την ελάχιστη συνολική απόσταση στη μέγιστη.
Αν το πιο μακρινό όχημα βρίσκεται πιο μακρία από όλα τα υπόλοιπα στοιχεία (+1)
τότε δεν μπορούμε να φτάσουμε εκεί με τον κανόνα που δίνεται. *)

(* Διάβασμα αρχείου από αρχείο με όνομα <file>, o κώδικας προέρχεται από τη σελίδα του μαθήματος: *)
(* https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml *)
fun parse file =
    let
        fun readInt input = Option.valOf(TextIO.scanStream (Int.scan StringCvt.DEC) input)
        val input = TextIO.openIn file

        val N = readInt input
        val K = readInt input
        val _ = TextIO.inputLine input (* skip the new line *)

        fun readArr 0 acc = rev acc
        |   readArr i acc = readArr (i-1) (readInt input :: acc)
    in
        (N, K, readArr K [])
    end

(* Απλή υλοποίηση του merge sort, ο κώδικας προέρχεται από τις διαφάνειες του μαθήματος *)
(* "Εισαγωγή στη Γλώσσα ML" *)
fun mergeSort nil = nil
|   mergeSort [e] = [e]
|   mergeSort theList =
    let
        fun halve nil = (nil, nil)
        |   halve [a] = ([a], nil)
        |   halve (a::b::cs) =
            let
                val (x, y) = halve cs
            in
                (a::x, b::y)
            end
        fun merge (nil, ys) = ys
        |   merge (xs, nil) = xs
        |   merge (x::xs, y::ys) =
            if x < y then x::merge(xs, y::ys)
            else y::merge(x::xs, ys)
        val (x, y) = halve theList
    in
        merge (mergeSort x, mergeSort y)
    end

(* Για κάθε πολή το farthest δείχνει την απόσταση του πιο μακρινού αυτοκινήτου, *)
(* το sum δείχνει το άθροισμα των αποστάσεων όλων των υπόλοιπων αυτοκινήτων , *)
(* και το total δείχνει τη συνολική απόσταση όλων των αυτοκινήτων (farthest+sum) *)
fun find_sum_farthest N K lis  =
    let
        val car = Array.fromList lis (* Μετατροπή λίστας σε array *)
        val (sum, farthest, total) = (Array.array(N, 0), Array.array(N, 0), Array.array(N, 0))

        fun calc_distances i j =
            if j = K then 
                if i = N-1 then () else calc_distances (i+1) 0
            else
                let
                    val sum_prev = Array.sub(sum, i)
                    val total_prev = Array.sub(total, i)
                    val distance = case Array.sub(car,j) <= i of
                        true => i - Array.sub(car, j)
                    |   false => (N - Array.sub(car, j) + i)
                in
                    if distance > Array.sub(farthest, i) then
                        (Array.update(sum, i, sum_prev + Array.sub(farthest, i));
                        Array.update(farthest, i, distance))
                    else
                        Array.update(sum, i, sum_prev + distance);
                        Array.update(total, i, total_prev + distance);
                        calc_distances i (j+1)
                end
    in
        calc_distances 0 0; (sum, farthest, total)
    end

(* Η τελική συνάρτηση *)
fun round file =
    let
        val (N, K, lis) = parse file
        val (sum, farthest, total) = find_sum_farthest N K lis
        val total_list = mergeSort (Array.foldr (op ::) [] total) (* Μετατροπή σε λίστα για το merge sort *)

        (* Αν το μακρινότερο αυτκίνητο (-1) είναι πιο κοντά από το άθροισμα των υπόλοιπων αυτοκινήτων, *)
        (* τότε βρήκαμε τη συντομότερη πόλη, αλλιώς συνεχίζουμε το ψάξιμο *)
        fun find_best_city [] = (0, 0) (* Δίνεται ότι πάντα υπάρχει λύση, άρα εδώ δεν θα φτάσουμε ποτέ *)
        |   find_best_city (h::t) = 
            let
                val (index, _) = Option.valOf (Array.findi (fn (ind, x) => x = h) total) (* Βρίσκουμε την πρώτη πόλη με αυτή την απόσταση *)
            in
                (* print("checking sum: " ^ Int.toString h ^ " in city: " ^ Int.toString index ^ "\n"); *)
                if Array.sub(farthest, index) - 1 <= Array.sub(sum, index) then
                    (h, index)
                else 
                (
                    Array.update(total, index, 0); (* Μηδενίζουμε τη συγκεκριμένη πόλη για να μην την ξαναψάξουμε *)
                    find_best_city t
                )
            end
        val (best_distance, best_city) = find_best_city total_list
    in
        (* print(String.concatWith ", " (map Int.toString total_list) ^ "\n"); *)
        print(Int.toString best_distance ^ " " ^ Int.toString best_city)
    end