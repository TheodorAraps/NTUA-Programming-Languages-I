/*Our program follows the algorithm shown in the following site (implemetnted in python):

https://replit.com/@Apass_Jack/cs129353longestsubarray

*/

#include <fstream>

int Max(int a,int b)
{
	if (a > b) return a;
	else return b;
}

int main(int argc, char** argv)
{
	int N, M;
	std::ifstream infile;
	infile.open(argv[1]);

	if (infile.fail())
	{
		printf("Error Opening File!\n");
		exit(1);
	}
	
	infile >> M >> N;
	if (M < 1 || M > 500000 || N < 1 || N > 1000)
	{
		printf("Invalid number of Days or Hospitals! Please try again with another file.\n");
		exit(1);
	}

	int days[M], temp, prefix_sum[M];
	for (int i = 0; i < M; i++)
	{
		infile >> temp;
		days[i] = -temp - N; //We store the the number of wards that get emptied in a day as positive numbers and subtruct N. 
	}						 //We basically want to follow this rule: (K = j-i) arr[i] + ... + arr[j] >= N*K => 
							 										//S(arr[i...j])/K - N/K >= 0 => 
																	//S(arr[i...j] - N) >= 0
							 //So in order to do this we need to have positive values of emptied wards per day	
	infile.close();
	prefix_sum[0] = days[0];

	for (int i = 0; i < M-1; i++)
	{
		prefix_sum[i+1] = prefix_sum[i] + days[i+1]; //We store prefix sum of days[] in prefix_sum[]
	}
	if (prefix_sum[M-1] >= 0)
	{
		printf("%d\n", M);  //If the last element of prefix_sum is >= 0 then it's obvious that the answer is K = M
		return 0;
	}
	//Now the basic problem is to find the largest j - i such that j > i and prefix_sum[j] - prefix_sum[i] >= 0
	int right[M], left[M], index_of_left = 0, index_of_right = 0;
	right[0] = M - 1; 
	left[0] = 0;
	//In this loop we retain the indexes of the smallest elements of the prefix, starting from left, because we want prefix_sum[i] to be less than each element of {prefix_sum[0],... ,prefix_sum[i]}
	for (int i = 1; i < M; i++)
	{
		if (prefix_sum[left[index_of_left]] > prefix_sum[i])
		{
			left[++index_of_left] = i;
		}
	}
	int length_of_left = index_of_left + 1;
	//In this loop we retain the indexes of the largest elements of the prefix, starting from right, because we want prefix_sum[j] to be greater than each element of {prefix_sum[j],... ,prefix_sum[M-1]}
	for (int i = M - 2; i >= 0; i--)
	{
		if (prefix_sum[right[index_of_right]] < prefix_sum[i])
		{
			right[++index_of_right] = i; //first we increment then we set value
		}
	}
	
	//Main loop to find the longest subbarray having sum greater or equal to zero (this will be the period K)
	int K = 0, left_i = 0, right_i = index_of_right;
	while((left_i < length_of_left) & (right_i >= 0))//we loop until one reach its end
	{
		if (prefix_sum[right[right_i]] >= prefix_sum[left[left_i]]) //this is our prefix_sum[j] - prefix_sum[i] >= 0 statement (looping for)
		{
			while ((right_i - 1 >= 0) && (prefix_sum[right[right_i - 1]] >= prefix_sum[left[left_i]]))
			{
				right_i--;
			}
			K = Max(K, right[right_i] - left[left_i]);
			left_i++;
			right_i--;
		}
		else if (left[left_i] < right[right_i] - 1) left_i++;
		else right_i--;
	}

	printf("%d\n", K);
}