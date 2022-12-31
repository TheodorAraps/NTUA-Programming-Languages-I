(* loop_rooms *)

(* Uses recursion to find the valid rooms starting from room (i, j) and following the directions.
   If we get out of the maze or visit a room we already know leads to an exit then all the 
   rooms we visited are good rooms and marked "S" for success. If we get to a room we already know
   is bad or we visited before in this iteration then it is bad and marked "F" for failure.
 *)
fun find_valid_rooms arr N M i j =
  if i < 0 orelse j < 0 orelse i >= N orelse j >= M then true else
    (case Array2.sub(arr, i, j) of
    #"S" => true |
    #"F" => false |
    #"V" => false |
    #"U" => (Array2.update(arr, i, j, #"V");
      if find_valid_rooms arr N M (i-1) j then (Array2.update(arr, i, j, #"S"); true) else (Array2.update(arr, i, j, #"F"); false)) |
    #"D" => (Array2.update(arr, i, j, #"V");
      if find_valid_rooms arr N M (i+1) j then (Array2.update(arr, i, j, #"S"); true) else (Array2.update(arr, i, j, #"F"); false)) |
    #"L" => (Array2.update(arr, i, j, #"V");
      if find_valid_rooms arr N M i (j-1) then (Array2.update(arr, i, j, #"S"); true) else (Array2.update(arr, i, j, #"F"); false)) |
    #"R" => (Array2.update(arr, i, j, #"V");
      if find_valid_rooms arr N M i (j+1) then (Array2.update(arr, i, j, #"S"); true) else (Array2.update(arr, i, j, #"F"); false)) |
      _  => true
    )

(* Apply the function f to every element of the matrix. *)
fun function_on_matrix f arr N M i j = 
  if i >= N then () else
  (f arr N M i j; if j < (M-1) then function_on_matrix f arr N M i (j+1) else function_on_matrix f arr N M (i+1) 0)

(* Uses the previous 2 functions to apply find_valid_rooms on all elements. *)
fun find_all_valid_rooms arr N M = function_on_matrix find_valid_rooms arr N M 0 0

(* Returns the number of bad rooms that don't lead to an exit; Basically counts all room with an "F" *)
fun count_bad_rooms arr N M i j counter =
  (case Array2.sub(arr, i, j) of
  #"F" => if j < (M-1) then count_bad_rooms arr N M i (j+1) (counter+1) else count_bad_rooms arr N M (i+1) 0 (counter+1) |
  #"S" => if j < (M-1) then count_bad_rooms arr N M i (j+1) counter else count_bad_rooms arr N M (i+1) 0 counter |
   _  => counter)
   handle Subscript => counter (* if we went out of bounds, then we traversed the whole matrix *)

fun count_bad_row_rooms row M j =
  if j > (M-1) then 0 else
  if Vector.sub(row, j) = #"F" then 1+count_bad_row_rooms row M (j+1) else count_bad_row_rooms row M (j+1)

fun count_bad_rooms2 arr N M i j counter =
  if i > (N-1) then counter else 
  let
    val current_row = Array2.row(arr, i);
    val row_count = count_bad_row_rooms current_row M 0;
  in
    count_bad_rooms2 arr N M (i+1) j (counter+row_count)
  end


(* From: https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml, sligthly modified to handle characters  *)   
fun parse file =
  let
    fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    fun readLine input = TextIO.inputLine input
    val input = TextIO.openIn file

    val N = readInt input
    val M = readInt input
    val _ = TextIO.inputLine input (* eat the newline *)

    (* We use String.substring to ignore the newline in each string *)
    fun readChars 0 acc = rev acc
      | readChars i acc = 
      let
        val currentLine = readLine input
      in
        if isSome currentLine then readChars (i-1) (explode (String.substring (Option.valOf currentLine, 0, M)) :: acc) else rev acc
      end
    
    val listoflists = readChars N []
    val _ = TextIO.closeIn input (* Close input stream *)
  in
    (N, M, listoflists)
  end

(* Actual function we call, we first need to convert list of lists to Array2 *)
fun loop_rooms input =
  let
    val (N, M, listoflists) = parse input
    val arr = Array2.fromList listoflists
  in
    find_all_valid_rooms arr N M;
    print(Int.toString (count_bad_rooms2 arr N M 0 0 0) ^ "\n")
  end
