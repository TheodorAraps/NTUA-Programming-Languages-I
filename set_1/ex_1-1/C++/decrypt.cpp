#include <fstream>
#include <iostream>
#include <math.h>

//Global Declarations
char cipher_text[10001],
plain_texts[26][10001]; //Contains all possible plain texts
float f_Nc[26][26]; //Contains the frequency of every letter from the alphabet for each on of the 26 plain texts derived from ROTN, for every N
float f_c[26] = { //Contains the general frequency of the English letters 
				  0.08167, 0.01492, 0.02782, 0.04253, 0.12702,
				  0.02228, 0.02015, 0.06094, 0.06966, 0.00153,
				  0.00772, 0.04025, 0.02406, 0.06749, 0.07507,
				  0.01929, 0.00095, 0.05987, 0.06327, 0.09056,
				  0.02758, 0.00978, 0.02360, 0.00150, 0.01974,
				  0.00074
};
float H_N[26]; //Entropy Equation Results

//ROTN function that returns the plain text derived from decrypting cipher text with shift N
void ROTN(char * cipher_text, int N, int length)
{
	for (int i = 0; i < length; i++)
	{
		if (cipher_text[i] >= 'a' && cipher_text[i] <= 'z')
		{
			plain_texts[N][i] = char(int(cipher_text[i] + N - 97) % 26 + 97);
			continue;
		}
		else if (cipher_text[i] >= 'A' && cipher_text[i] <= 'Z')
		{
			plain_texts[N][i] = char(int(cipher_text[i] + N - 65) % 26 + 65);
			continue;
		}
		plain_texts[N][i] = cipher_text[i];
	}
}

int main(int argc, char** argv)
{
	//Initialiasations & other Declarations
	FILE* input_file = fopen(argv[1], "r");
	if (input_file == nullptr) {
		return EXIT_FAILURE;
	}
	float sum_of_products, min_H_N = 99999999;
	int length = 0, key = 0;
	for (int i = 0; i < 26; i++)
	{
		H_N[i] = 0;
		for (int j = 0; j < 26; j++)
		{
			f_Nc[i][j] = 0;
		}
	}

	//Read cipher text from file char by char
	while (!feof(input_file)) {
		cipher_text[length] = fgetc(input_file);
		if (feof(input_file))
		{
			cipher_text[length - 1] = '\0'; //cipher_text[length] = EOF, fgetc() adds new line at cipher_text[length - 1]
			break;
		}
		length++;
	}
	fclose(input_file);

	//Run ROTN 26 times for every shift N and create all possible plain texts
	for (int N = 0; N < 26; N++)
	{
		ROTN(cipher_text, N, length);
	}

	//Calculate f_Nc
	for (int N = 0; N < 26; N++)
	{
		for (int i = 0; i < length; i++)
		{
			if (plain_texts[N][i] >= 'a' &&  plain_texts[N][i] <= 'z')
			{
				f_Nc[N][int(plain_texts[N][i] - 97)] += 1 / float(length);
				continue;
			}
			else if (plain_texts[N][i] >= 'A' && plain_texts[N][i] <= 'Z')
			{
				f_Nc[N][int(plain_texts[N][i] - 65)] += 1 / float(length);
				continue;
			}
		}
	}
	//Calclulate entropy and find key (shift)
	//The actual decryption key is KEY = 26 - key
	for (int N = 0; N < 26; N++)
	{
		sum_of_products = 0;

		for (int i = 0; i < length; i++)
		{
			if (plain_texts[N][i] >= 'a' && plain_texts[N][i] <= 'z')
			{
				sum_of_products += f_Nc[N][int(plain_texts[N][i] - 97)] * log2(f_c[int(plain_texts[N][i] - 97)]);
				continue;
			}
			else if (plain_texts[N][i] >= 'A' && plain_texts[N][i] <= 'Z')
			{
				sum_of_products += f_Nc[N][int(plain_texts[N][i] - 65)] * log2(f_c[int(plain_texts[N][i] - 65)]);
				continue;
			}
		}

		H_N[N] = -1.0 * sum_of_products;
		if (H_N[N] < min_H_N)
		{
			min_H_N = H_N[N];
			key = N;
		}
	}

	printf("%s\n", plain_texts[key]);

	return 0;
}