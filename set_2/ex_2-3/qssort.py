from collections import deque
import itertools
import sys
if len(sys.argv) < 2:
    print("Usage: python qssort.py <filename>")
    exit()
input = open(sys.argv[1])
N = int(input.readline())
l = [int(x) for x in input.readline().split()]
# print(N) # debug
# print(l) # debug
input.close()

queue = deque(l)
try_queue = deque()
try_stack = deque()

# Print both queue and stack, used for debugging
def show():
    print("Queue: ", try_queue)
    print("Stack: ", try_stack)
# Make a Q move
def q_move():
    elem = try_queue.popleft()
    try_stack.append(elem)
# Make an S move
def s_move():
    elem = try_stack.pop()
    try_queue.append(elem)

l.sort()
sorted_queue = deque(l)
# print(sorted_queue) # debug
moveset = []

# Generate all movesets with a specific number of moves
def generate_movesets(movecount):
    return list(itertools.product(["Q", "S"], repeat = movecount))

# def queues_are_equal():


found = False
movecount = 0
finalseq = []
if (queue == sorted_queue):
    print("empty")
    exit()
while (not found):
# while (movecount <= 4): # debug
    movecount += 2
    # print("Movecount: ", movecount) # debug
    # moves = generate_movesets(movecount) # will hold all possible move combinations
    # print("Moves: ", moves) # debug
    # current_string = "Q"*(movecount//2) + "S"*(movecount//2)
    # print(current_string)
    # comb = list(itertools.permutations(current_string,movecount))
    # print(comb)
    for i in itertools.product(["Q", "S"], repeat = movecount-1):
    # for i in itertools.permutations(current_string):
        # print(i) # debug
        if i.count("Q") != (movecount // 2) - 1: continue
        try_queue = queue.copy()
        try_stack = deque()
        # print("New try_queue:", try_queue) # debug
        # print("New sequence is: ", i) # debug
        q_move()    # first move is always Q
        impossible_sequence = False
        for j in i:
            # print (j) # debug
            if j == "Q":
                if not try_queue: # if Queue is empty, then not possible sequence
                    break 
                else: q_move()
            else:
                if not try_stack:
                    break
                else :s_move()
        # print("Try_queue: ", try_queue) # debug
        # print("Sorted_queue: ", sorted_queue) # debug
        # print(try_queue) # debug
        if try_stack:
            continue
        elif try_queue == sorted_queue:
            found = True
            final = i
            finalseq = "".join(i)
            finalseq2 = "Q"+finalseq
            break

# print(movecount) # debug
print(finalseq2)