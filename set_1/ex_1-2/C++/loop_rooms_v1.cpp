#include <fstream>

int M, N;
char **rooms;
int valid_rooms = 0; //This variable will count the number of rooms from which you can find a path to exit)

//Read file and create a 2D array (Dynamically) of chars consisting of the rooms' values
void CreateArrayOfRooms(const char* file)
{
	std::ifstream infile;
	infile.open(file);

	if (infile.fail()) 
	{
		printf("Error Opening File!\n");
		exit(1);
	}

	infile >> N >> M;
	if(N <= 0 || M <= 0 || N > 1000 || M >= 1000)
	{
		printf("Invalid Number of Rooms! Please try another file.");
		exit(1);
	}

	rooms = new char*[N];

	//Put each rooms' values in an char** array
	for (int i = 0; i < N; i++)
	{
		rooms[i] = new char[M];
		for (int j = 0; j < M; j++)
		{
			infile >> rooms[i][j];
		}
	}
 	infile.close();
}

//Delete the 2D array and free memory
void free_rooms()
{
	for(int i = 0; i < N; i++) delete [] rooms[i];
	delete [] rooms;
}

//Using recursion we find all the paths that lead to rooms[i][j] (valid room) and count 
//the valid rooms (if they have a door leading to a valid room they are also valid rooms) 
void find_valid_rooms(int i, int j)
{
	if(i+1 < N)
	{
		if(rooms[i+1][j] == 'U')
		{
			valid_rooms++;
			find_valid_rooms(i+1, j);
		}
	}
	if(j+1 < M)
	{
		if(rooms[i][j+1] == 'L')
		{
			valid_rooms++;
			find_valid_rooms(i, j+1);
		}
	}
	if(i-1 >= 0)
	{
		if(rooms[i-1][j] == 'D')
		{
			valid_rooms++;
			find_valid_rooms(i-1, j);
		}
	}
	if(j-1 >= 0)
	{
		if(rooms[i][j-1] == 'R')
		{
			valid_rooms++;
			find_valid_rooms(i, j-1);
		}
	}
	else return;
}

int main(int argc, char** argv)
{	
	CreateArrayOfRooms(argv[1]);

	//We only check the outline rooms from which we can exit the maze
	if (rooms[0][0] == 'L' || rooms[0][0] == 'U') 
	{
		valid_rooms++;
		find_valid_rooms(0, 0);
	}
	for (int i = 1; i < M-1; i++)
	{
		if(rooms[0][i] == 'U') 
		{
			valid_rooms++;
			find_valid_rooms(0, i);
		}
	}
	if (rooms[0][M-1] == 'R' || rooms[0][M-1] == 'U')
	{
		valid_rooms++;
		find_valid_rooms(0, M-1);
	}
	for (int i = 1; i < N-1; i++)
	{
		if(rooms[i][M-1] == 'R') 
		{
			valid_rooms++;
			find_valid_rooms(i, M-1);
		}
	}
	if (rooms[N-1][M-1] == 'R' || rooms[N-1][M-1] == 'D')
	{
		valid_rooms++;
		find_valid_rooms(N-1, M-1);
	}
	for (int i = 1; i < M-1; i++)
	{
		if(rooms[N-1][i] == 'D') 
		{
			valid_rooms++;
			find_valid_rooms(N-1, i);
		}
	}
	if (rooms[N-1][0] == 'L' || rooms[N-1][0] == 'D')
	{
		valid_rooms++;
		find_valid_rooms(N-1, 0);
	}
	for (int i = 1; i < N-1; i++)
	{
		if(rooms[i][0] == 'L') 
		{
			valid_rooms++;
			find_valid_rooms(i, 0);
		}
	}

	free_rooms();
	printf("%d\n", N*M - valid_rooms); //This will give us the number of non-valid rooms (rooms from which you cannot escape the maze)
}