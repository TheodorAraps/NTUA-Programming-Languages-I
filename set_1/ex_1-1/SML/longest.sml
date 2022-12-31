(* Sums all elements in a list and return the real equivalent *)
fun sumList l = Real.fromInt(foldr op + 0 l)

(* Returns largest element in a list *)
fun findMax currMax [] = currMax
  | findMax currMax (h::t) = if h > currMax then findMax h t else findMax currMax t 

(* Return true if a certain period of D days with N hospitals is considered good *)
fun isPeriodGood N l =
  let
    val D = length l
  in
   if sumList l / Real.fromInt (D*N) <= ~1.0 then true else false
  end

fun longest1 len N [] = 0
  | longest1 len N (h::t) = if isPeriodGood N (h::t) then len else longest1 (len-1) N t

fun longest2 i currSum currMax N [] = currMax
  | longest2 i currSum currMax N (h::t) =
      if Real.fromInt(currSum+h) / Real.fromInt (i*N) <= ~1.0 then longest2 (i+1) (currSum+h) i         N t
                                                              else longest2 (i+1) (currSum+h) currMax   N t

(* Time complexity: O (n^2) *)
fun longest3 currMax N [] = currMax
  | longest3 currMax N (h::t) =
      let
        val thisIteration = longest2 1 0 0 N (h::t)
      in
        if  thisIteration > currMax then longest3 thisIteration N t else longest3 currMax N t
      end

fun parse file =
  let
    fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    val input = TextIO.openIn file

    val M = readInt input
    val N = readInt input
    val _ = TextIO.inputLine input (* eat the newline *)

    fun readInts 0 acc = rev acc
      | readInts i acc = readInts (i-1) (readInt input :: acc)
  in
    (M, N, readInts M [])
  end

fun longest filename = 
  let
    val (M,N,l) = parse filename
  in
    print(Int.toString (longest3 0 N l) ^ "\n")
  end


val testsuite = [
   ("11 days, 3 hospitals", [42, ~10, 8, 1, 11, ~6, ~12, 16, ~15, ~11, 13], 5),
   ("6 days, 3 hospitals", [~6, ~12, 16, ~15, ~11, 13], 5),
   ("5 days, 3 hospitals", [~6, ~12, 16, ~15, ~11], 5),
   ("4 days, 3 hospitals", [~6, ~12, 16, ~15], 4)
]