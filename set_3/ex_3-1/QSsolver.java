import java.util.*;

public class QSsolver {
    
    public String finalSeq;
    public boolean solved; // true when it is solved
    private ArrayList<Integer> sortedQueue;
    private Deque<Triplet> moves;
    public Set<Pair> visited; // visited states

    public QSsolver(ArrayList<Integer> q, ArrayList<Integer> sortedArray) {
        solved = false;
        sortedQueue = sortedArray;
        moves = new ArrayDeque<>();
        visited = new HashSet<>();
        ArrayList<Integer> s = new ArrayList<>(); // empty stack
        Pair Pair = new Pair(q, s);
        Pair.QMove();
        moves.addLast(new Triplet(Pair.queue, Pair.stack, "Q"));
        visited.add(Pair);
    }

    public void checkNextMove() {
        Triplet currentMove = moves.removeFirst();
        // System.out.println(sortedQueue.toString());
        // // if (currentMove.sequence.length() > 10) solved = true;
        // currentMove.printTriplet();
        Triplet nextMoveQ = new Triplet(currentMove);
        if (!nextMoveQ.queue.isEmpty()) {
            nextMoveQ.addMove('Q');
            nextMoveQ.QMove();
            if ((nextMoveQ.queue.equals(sortedQueue))) {
                solved = true;
                finalSeq = nextMoveQ.sequence;
            }
            else {
                Pair currentPairQ = new Pair(nextMoveQ.queue, nextMoveQ.stack);
                if (!visited.contains(currentPairQ))
                {
                    visited.add(currentPairQ);
                    moves.addLast(nextMoveQ);
                }
            }
        }

        Triplet nextMoveS = new Triplet(currentMove);
        if (!nextMoveS.stack.isEmpty()) {
            nextMoveS.addMove('S');
            nextMoveS.SMove();
            if (nextMoveS.queue.equals(sortedQueue)) {
                solved = true;
                finalSeq = nextMoveS.sequence;
            }
            else {
                Pair currentPairS = new Pair(nextMoveS.queue, nextMoveS.stack);
                if (!visited.contains(currentPairS))
                {
                    visited.add(currentPairS);
                    moves.addLast(nextMoveS);
                }
            }
        }
    }

    public static boolean areQueuesEqual(Deque<Integer> q1, Deque<Integer> q2) {
        ArrayList<Integer> arr1 = new ArrayList<>(q1);
        ArrayList<Integer> arr2 = new ArrayList<>(q2);
        return arr1.equals(arr2);
    }
}