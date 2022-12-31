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