fun runtests f [] = ()
  | runtests f ((name, input, output) :: others) = (
    print ("Test case " ^ name ^ ": ");
    if f input = output then print "Success!\n"
    else                     print "Failure :(\n";
    runtests f others
  )
