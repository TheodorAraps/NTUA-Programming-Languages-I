(* function to parse file and create a list of chars from the text inside it *)
fun parse file =
	let
		fun next_String input = (TextIO.inputAll input) 
		val stream = TextIO.openIn file
		val cipher_text_string = next_String stream
		val cipher_text_list = String.explode(cipher_text_string)
	in
		cipher_text_list
	end  

(* Produce plain text given a certain N shift and the cipher text (ROTN algorithm)*)
fun Produce_plain_text [] N = []
  | Produce_plain_text (char::T) N = 
	if Char.ord(char) >= Char.ord(#"a") andalso Char.ord(char) <= Char.ord(#"z")
	then 
		(Char.chr((Char.ord(char) + N - 97) mod 26 + 97))::(Produce_plain_text T N)
	else if Char.ord(char) >= Char.ord(#"A") andalso Char.ord(char) <= Char.ord(#"Z")
	then
		(Char.chr((Char.ord(char) + N - 65) mod 26 + 65))::(Produce_plain_text T N)
	else
		char::(Produce_plain_text T N)

(* Produce all plain texts for all possible shifts *)
fun Produce_all_plain_texts _ 26 = []
  | Produce_all_plain_texts cipher_text N =
	(Produce_plain_text cipher_text N)::(Produce_all_plain_texts cipher_text (N + 1))

(* Returns the number of times the letter "letter" appears in the plain text *)
fun calc_freq_of_letter [] _ c = c 
  | calc_freq_of_letter (char::T) letter c =
	if Char.ord(char) >= Char.ord(#"a") andalso Char.ord(char) <= Char.ord(#"z")
	then 
		if letter = Char.ord(char) - 97
		then 
			calc_freq_of_letter T letter (c + 1.0)
		else
			calc_freq_of_letter T letter c
	else if Char.ord(char) >= Char.ord(#"A") andalso Char.ord(char) <= Char.ord(#"Z")
	then
		if letter = Char.ord(char) - 65
		then 
			calc_freq_of_letter T letter (c + 1.0)
		else
			calc_freq_of_letter T letter c
	else
		calc_freq_of_letter T letter c

(* Returns the frequency for each letter of the alphabet for one plain text *)
fun calc_freq_of_alphabet _ 26 = []
  | calc_freq_of_alphabet plain_text letter = 
	(calc_freq_of_letter plain_text letter 0.0)::(calc_freq_of_alphabet plain_text (letter + 1))

(* Calculates f_Nc[26][26], the frequency of the letters of the alphabet for every shift N *)
fun calc_f_Nc [] _ _ = []
  | calc_f_Nc _ 26 _ = []
  | calc_f_Nc (plain_text::rest) N length =
	(map (fn x => (x / length)) (calc_freq_of_alphabet plain_text 0))::(calc_f_Nc rest (N + 1) length)

fun calculate_entropy _ _ [] sum_of_products = sum_of_products * (~1.0)
  | calculate_entropy f_Nc f_c (char::rest) sum_of_products =
	if Char.ord(char) >= Char.ord(#"a") andalso Char.ord(char) <= Char.ord(#"z")
	then 
		calculate_entropy f_Nc f_c rest (sum_of_products + List.nth(f_Nc, (Char.ord(char) - 97)) * (Math.log10 (List.nth(f_c, (Char.ord(char) - 97)))))
	else if Char.ord(char) >= Char.ord(#"A") andalso Char.ord(char) <= Char.ord(#"Z")
	then
		calculate_entropy f_Nc f_c rest (sum_of_products + List.nth(f_Nc, (Char.ord(char) - 65)) * (Math.log10 (List.nth(f_c, (Char.ord(char) - 65)))))
	else
		calculate_entropy f_Nc f_c rest sum_of_products

(* Calculate entropy and find key (shift) *)
fun find_correct_plain_text _ _ _ result 26 _ = result
  | find_correct_plain_text (f_Nc::t) f_c (plain_text::rest) result N min = 
	let
		val entropy = calculate_entropy f_Nc f_c plain_text 0.0 
		val min2 = if min > entropy
				   then
					   entropy
				   else
		        	   min
		val result2 = if min > entropy
					  then
					  	  plain_text
					  else
					   	  result
	in
		find_correct_plain_text t f_c rest result2 (N + 1) min2
	end
	
	

(* Main function to decrypt a cipher text encrypted with Ceasar's encryption schema *)
(* Follows the same algorithm as described in cpp version *)
fun decrypt file =
	let
		val cipher_text_list = parse file
		val f_c = [
                  0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 
                  0.02228, 0.02015, 0.06094, 0.06966, 0.00153,
                  0.00772, 0.04025, 0.02406, 0.06749, 0.07507, 
                  0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 
                  0.02758, 0.00978, 0.02360, 0.00150, 0.01974, 
                  0.00074
                ]
		val plain_texts = Produce_all_plain_texts cipher_text_list 0
		val out =  String.implode (List.concat plain_texts)
		val f_Nc = calc_f_Nc plain_texts 0 (Real.fromInt (List.length cipher_text_list))
		val correct_plain_text = find_correct_plain_text f_Nc f_c plain_texts (List.hd plain_texts) 0 999999.99
	in
		print(String.implode correct_plain_text)
	end