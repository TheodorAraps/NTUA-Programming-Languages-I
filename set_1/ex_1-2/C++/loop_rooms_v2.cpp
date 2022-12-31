// loop_rooms
// We use an array called "state" to keep of track of what we know about each room:
// 'S' for success, already known to lead to exit
// 'F' for failure, already known to not lead to exit
// 'V' for visited in this iteration
// 'U' for unknown
#include <stdio.h>
#include <stdlib.h>
#include <stack>

typedef struct position
{
	int x;
	int y;
} position;

void print(char **arr, int N, int M)
{
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < M; j++)
        {
            printf("%c ", arr[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}


int main(int argc, char **argv)
{
    FILE *input;
    input = fopen(argv[1], "r");

    int N; // number of rows
    int M; // number of columns

    fscanf(input, "%d %d", &N, &M);

    char **room;
    room = (char **)malloc(N * sizeof(char *));

    for (int row = 0; row < N; row++)
    {
        room[row] = (char *)malloc(M * sizeof(char));
    }

    fgetc(input); // ignore the first newline
    for (int row = 0; row < N; row++)
    {
        for (int col = 0; col < M; col++)
        {
            fscanf(input, "%c", &room[row][col]);
        }
        fgetc(input); // ignore the newline on each row
    }

    // print(room, N, M); // for debugging only

    char **state;
    state = (char **)malloc(N * sizeof(char *));
    for (int row = 0; row < N; row++)
    {
        state[row] = (char *)malloc(M * sizeof(char));
    }
    // Initialize array to avoid undefined behavior
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < M; j++)
        {
            state[i][j] = 'U';
        }
    }

    std::stack<position> visited;

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < M; j++)
        {
            int r_index = i;
            int c_index = j;
            int is_finished = 0;
            int success = 0;
            while (!is_finished)
            {
                switch (room[r_index][c_index])
                {
                case 'U':
                    --r_index;
                    break;

                case 'D':
                    ++r_index;
                    break;

                case 'L':
                    --c_index;
                    break;

                case 'R':
                    ++c_index;
                    break;
                }

                if (r_index < 0 || r_index >= N || c_index < 0 || c_index >= M) // if out of bounds then we reached the exit
                {
                    is_finished = 1;
                    success = 1;
                    break;
                }

                switch (state[r_index][c_index])
                {
                case 'S':
                    is_finished = 1;
                    success = 1;
                    break;

                case 'F':
                case 'V':
                    is_finished = 1;
                    success = 0;
                    break;

                case 'U':
                    state[r_index][c_index] = 'V';
                    visited.push({r_index, c_index});
                    break;
                }
            }
            while (!visited.empty())
            {
                state[visited.top().x][visited.top().y] = (success) ? 'S' : 'F';
                visited.pop();
            }
            state[i][j] = (success) ? 'S' : 'F';
        }
    }

    // print(state, N, M); // for debugging only

    int bad_room_counter = 0;
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < M; j++)
        {
            if (state[i][j] != 'S') bad_room_counter++;
        }
    }

    printf("%d", bad_room_counter);

    free(room);
    free(state);
    return 0;
}
