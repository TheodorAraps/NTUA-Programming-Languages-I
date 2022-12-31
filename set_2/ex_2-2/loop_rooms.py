# We use an extra list of lists called state that holds what we know about each room
# "S" for success
# "F" for failure, already known to not lead to exit
# "V" for visited in this iteration
# "N" when we don't know

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
print (N, M)
#print(rooms)
#print("State:")
#print(state)
input.close()


def find_valid_rooms(i, j):
    if (state[i][j] == "F"): return
    if (state[i][j] == "S"): return
    if (state[i][j] == "V"):    # if we already visited this room, then we are on a loop, so there is no exit
        state[i][j] = "F"
        return
    if (rooms[i][j] == "U"):
        if (i <= 0):            # if out of bounds, then we found an exit
            state[i][j] = "S"
            return
        state[i][j] = "V"       # mark current room as visited
        find_valid_rooms(i-1,j)
        if (state[i-1][j] == "S"):
            state[i][j] = "S"
        else:
            state[i][j] = "F"
        return
    
    if (rooms[i][j] == "D"):
        if (i >= N-1):            # if out of bounds, then we found an exit
            state[i][j] = "S"
            return
        state[i][j] = "V"       # mark current room as visited
        find_valid_rooms(i+1,j)
        if (state[i+1][j] == "S"):
            state[i][j] = "S"
        else:
            state[i][j] = "F"
        return

    if (rooms[i][j] == "L"):
        if (j <= 0):             # if out of bounds, then we found an exit
            state[i][j] = "S"
            return
        state[i][j] = "V"       # mark current room as visited
        find_valid_rooms(i,j-1)
        if (state[i][j-1] == "S"):
            state[i][j] = "S"
        else:
            state[i][j] = "F"
        return

    if (rooms[i][j] == "R"):
        if (j >= M-1):            # if out of bounds, then we found an exit
            state[i][j] = "S"
            return
        state[i][j] = "V"       # mark current room as visited
        find_valid_rooms(i,j+1)
        if (state[i][j+1] == "S"):
            state[i][j] = "S"
        else:
            state[i][j] = "F"
        return
    return

for i in range(N):
    for j in range(M):
        #print(M)
        #print("yas, i = ", i, " j = ", j)
        find_valid_rooms(i,j)
   
# Count and return the bad rooms
counter = 0
for i in range(N):
    for j in range(M):
        if state[i][j] ==  "F":
            counter += 1

print(counter)