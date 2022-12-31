import java.util.*;

public class ZQSsolver {
    
    public String finalSeq;
    public boolean solved; // true when it is solved
    private ArrayList<Integer> sortedQueue;
    private Deque<Triplet> moves;
    public Set<ZPair> visited; // visited states

    public ZQSsolver(ArrayList<Integer> q, ArrayList<Integer> sortedArray) {
        solved = false;
        sortedQueue = sortedArray;
        moves = new ArrayDeque<>();
        visited = new HashSet<>();
        ArrayList<Integer> s = new ArrayList<>(); // empty stack
        ZPair ZPair = new ZPair(q, s);
        ZPair.QMove();
        moves.addLast(new Triplet(ZPair.queue, ZPair.stack, "Q"));
        visited.add(ZPair);
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
                ZPair currentZPairQ = new ZPair(nextMoveQ.queue, nextMoveQ.stack);
                if (!visited.contains(currentZPairQ))
                {
                    visited.add(currentZPairQ);
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
                ZPair currentZPairS = new ZPair(nextMoveS.queue, nextMoveS.stack);
                if (!visited.contains(currentZPairS))
                {
                    visited.add(currentZPairS);
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