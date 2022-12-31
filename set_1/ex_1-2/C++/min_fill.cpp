#include <fstream>
#include <vector>
#include <algorithm>

//Find with path compression function
int find(int * parent, int i)
{
	i--;
	if (parent[i] == i)
	return i;

	return parent[i] = find(parent, parent[i] + 1);
}

//Union by rank function
void union_br_pc(int * parent, int * rank, int x, int y)
{
	if (rank[x] < rank[y]) {
		parent[x] = y;
		rank[y] += rank[x];
	}
	else if (rank[x] > rank[y]) {
		parent[y] = x;
		rank[x] += rank[y];
	}
	else
	{
		parent[y] = x;
		rank[x]++;
	}
}

//We implement kruskal's algorithm, implemented with union
//by rank and data compression, thus achieving O(MlogN)
int main(int argc, char * argv[])
{
	int N, M, X, Y, W, max_gas = 0, length = 0;
	std::vector<std::vector<int>> edges;
	std::ifstream infile;

	//Parse file
	infile.open(argv[1]);
	if (infile.fail())
	{
		printf("Error Opening File!\n");
		exit(1);
	}

	infile >> N >> M;
	if (N < 1 || N > 10000 || M < 1 || M > 100000)
	{
		printf("Invalid number of cities and/or roads! Please try again with another file.\n");
		exit(1);
	}

	int * parent = new int[N];
	int * rank = new int[N];

	//Initialise parent and rank for every city
	for (int i = 0; i < N; i++)
	{
		parent[i] = i;
		rank[i] = 1;
	}

	//Store file contents in Mx3 2D vectore
	for (int i = 0; i < M; i++)
	{
		if (infile.eof())
		{
			printf("Unexpected EOF!\n");
			exit(1);
		}
		infile >> X >> Y >> W;
		edges.push_back({ W, X, Y });
	}

	infile.close();

	//Sort all edges based on weight
	sort(edges.begin(), edges.end());

	//Kruskal
	for (auto edge : edges) {
		int w = edge[0];
		int x = find(parent, edge[1]);
		int y = find(parent, edge[2]);

		//If not cycle
		
		if (x != y) {
			union_br_pc(parent, rank, x, y);
			max_gas = w;
			length++;
			if (length == N - 1) break;
		}
	}

	printf("%d\n", max_gas);

	delete[] parent;
	delete[] rank;
}