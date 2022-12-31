# Ομάδα: Θεόδωρος Αράπης & Εμμανουήλ Βλάσσης
# Μεθοδολογία: Ξεκινάμε με τις λύσεις (συμβολοσειρές) μίας κίνησης, και προχωράμε σε μεγαλύτερες
# συμβολοσειρές ακολουθώντας BFS με λεξικογραφική σειρά (το "Q" έρχεται πριν από το "S").
# Ο αλγόριθμος σταματάει όταν το queue που έχει προκύψει είναι ίσο με τη σορταρισμένη λίστα.
# Για να μην κάνουμε συνέχεια τις ίδιες αρχικές κινήσεις, για κάθε string κρατάμε την τωρινή κατάσταση
# των αντίστοιχων stack και queues, και προσθέτουμε στο δέντρο τις δύο καταστάσεις που προκύπτουν με ένα 
# extra "Q" ή "S". Επιπλέον, επειδή ψάχνουμε τη λύση με τις λιγότερες κινήσεις, κρατάμε σε ένα set όλα
# τα ζεύγη των καταστάσεων των queues και stacks που έχουμε εξερευνήσει, και πετάμε κάθε επόμενη αλληλουχία
# κινήσεων που οδηγούν στο ίδιο ζεύγος καταστάσεων καθώς οδηγεί στο ίδιο αποτέλεσμα με περισσότερες κινήσεις.
# Για τα stack, queues χρησιμοποιήσαμε λίστες που έχουν πιο αργά popleft() αλλά χρειάζονται πολύ λιγότερη 
# μνήμη από τα deques.

from collections import deque
import itertools
import sys

# Read from file with name in argv[1]
if len(sys.argv) < 2:
    print("Usage: python qssort.py <filename>")
    exit()
input = open(sys.argv[1])
N = int(input.readline())
l = [int(x) for x in input.readline().split()]
# print(N) # debug
# print(l) # debug
input.close()

# Print both queue and stack, used for debugging
def show(queue, stack):
    print("Queue: ", queue)
    print("Stack: ", stack)
# Make a Q move
def q_move(queue, stack):
    # elem = queue.popleft()
    elem = queue.pop(0)
    stack.append(elem)
# Make an S move
def s_move(queue, stack):
    elem = stack.pop()
    queue.append(elem)


queue = l[:] # deque(l) chnage
stack = []  # deque() change
l.sort()
sorted_queue = l[:]

found = False
movecount = 0
finalseq = ""
if (queue == sorted_queue):
    print("empty")
    exit()
q_move(queue, stack)
current_states = deque() # will serve as our "tree" with fast popleft() times
current_states.append((queue[:], stack[:], "Q")) # (Queue, Stack, Moves)
# show(queue,stack) # debug
visited_states = set()
visited_states.add((tuple(queue), tuple(stack)))

while(not found):
    (curr_queue, curr_stack, seq) = current_states.popleft()
    # if len(seq) > 6: break # debug
    # print("Current looking at Queue: ", curr_queue, "Stack: ", curr_stack, "String: ", seq) # debug
    
    if curr_queue:  # if queue is empty, then "Q" is not possible
        next_queueQ = curr_queue[:]
        next_stackQ = curr_stack[:]
        seqQ = seq + "Q"
        q_move(next_queueQ, next_stackQ)
        if len(seqQ) % 2 == 0: # if we have odd number of moves then it cannot be the solution, so don't search
            if seqQ.count("Q") == len(seqQ) // 2: # The number of Qs and Ss must be equal, otherwise don't search
                if next_queueQ == sorted_queue:
                    found = True
                    finalseq = seqQ
                    break
        if (tuple(next_queueQ), tuple(next_stackQ)) not in visited_states: # If we already visited this (queue, stack) state, then don't add it to the tree
            visited_states.add((tuple(next_queueQ), tuple(next_stackQ)))
            current_states.append((next_queueQ, next_stackQ, seqQ))

    if curr_stack:  # if stack is empty, then "S" is not possible
        next_queueS = curr_queue.copy()
        next_stackS = curr_stack.copy()
        seqS = seq + "S"
        s_move(next_queueS, next_stackS)
        if len(seqS) % 2 == 0: # # if we have odd number of moves then it cannot be the solution, so don't search
            if seqS.count("Q") == len(seqS) // 2: # The number of Qs and Ss must be equal, otherwise don't search
                if next_queueS == sorted_queue:
                    found = True
                    finalseq = seqS
                    break
        if (tuple(next_queueS), tuple(next_stackS)) not in visited_states: # If we already visited this (queue, stack) state, then don't add it to the tree
            visited_states.add((tuple(next_queueS), tuple(next_stackS)))
            current_states.append((next_queueS, next_stackS, seqS))
    
print(finalseq)