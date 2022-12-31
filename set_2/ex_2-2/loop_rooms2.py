# We use an extra list of lists called state that holds what we know about each room
# "S" for success
# "F" for failure, already known to not lead to exit
# "V" for visited in this iteration
# "N" when we don't know

from collections import deque # to implement a stack with O(1) insertion/deletion
import sys

# Get input from file and put it to a list of lists
if len(sys.argv) < 2:
    print("Usage: python loop_rooms.py <filename>")
    exit()
input = open(sys.argv[1])
line = input.readline()
N, M = map(int, line.split())
rooms = []
state = [] # will hold the current state of each room
for line in input:
    rooms.append([s for s in line if s.isalpha()])
    state.append(["N" for i in range(M)])
#print (N, M) # debug
#print(rooms) # debug
#print("State:") # debug
#print(state) # debug
input.close()

stack = deque() # will hold all rooms visited in an iteration

def find_rooms(i, j):
    curr_i = i
    curr_j = j
    is_finished = False
    success = False # True if we found an exit, False if we did not
    while not is_finished:
        if (rooms[curr_i][curr_j] == "U"):
            curr_i -= 1
        elif (rooms[curr_i][curr_j] == "D"):
            curr_i += 1
        elif (rooms[curr_i][curr_j] == "L"):
            curr_j -= 1
        elif (rooms[curr_i][curr_j] == "R"):
            curr_j += 1
        if (curr_i < 0 or curr_i >= N or curr_j < 0 or curr_j >= M): # when out of bounds
            is_finished = True
            success = True
            break
        if (state[curr_i][curr_j] == "S"):
            is_finished = True
            success = True
            break
        elif (state[curr_i][curr_j] == "F" or state[curr_i][curr_j] == "V"):
            is_finished = True
            success = False
            break
        else:
            state[curr_i][curr_j] = "V"
            stack.append(curr_i)
            stack.append(curr_j)
    while stack:                    # mark all rooms in this iteration so we already know if they lead to an exit
        curr_j = stack.pop()
        curr_i = stack.pop()
        if success:
            state[curr_i][curr_j] = "S"
        else:
            state[curr_i][curr_j] = "F"
    if success:
        state[i][j] = "S"
    else:
        state[i][j] = "F"

for i in range(N):
    for j in range(M):
        # print(M) # debug
        # print("i = ", i, " j = ", j) #debug
        find_rooms(i,j)
   
# print(state) # debug

# Count and return the bad rooms
counter = 0
for i in range(N):
    for j in range(M):
        if state[i][j] ==  "F":
            counter += 1

print(counter)