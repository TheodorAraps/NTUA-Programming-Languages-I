import java.util.*;

public class Triplet {
    public ArrayList<Integer> queue;
    public ArrayList<Integer> stack;
    public String sequence;

    public Triplet(ArrayList<Integer> q, ArrayList<Integer> s, String seq) {
        if (!q.isEmpty()) {
            queue = new ArrayList<>(q);
        }
        else {
            queue = new ArrayList<>();
        }
        if (!s.isEmpty()) {
            stack = new ArrayList<>(s);
        }
        else {
            stack = new ArrayList<>();
        }
        sequence = seq;
    }
    public Triplet(Triplet other) {
        if (!other.queue.isEmpty()) {
            queue = new ArrayList<>(other.queue);
        }
        else {
            queue = new ArrayList<>();
        }
        if (!other.stack.isEmpty()) {
            stack = new ArrayList<>(other.stack);
        }
        else {
            stack = new ArrayList<>();
        }
        sequence = other.sequence;
    }
    public void QMove() {
        int elem = queue.remove(0);
        stack.add(0, elem);
    }
    public void SMove() {
        int elem = stack.remove(0);
        queue.add(elem);
    }
    public void addMove(char c) {
        sequence += c;
    }
    public void printTriplet() {
        System.out.print("Queue: " + queue);
        System.out.print(" Stack: " + stack);
        System.out.print(" Sequence: " + sequence + " ");
    }
}