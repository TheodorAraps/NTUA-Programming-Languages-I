import java.util.*;

public class Pair {
    public ArrayList<Integer> queue;
    public ArrayList<Integer> stack;

    public Pair(ArrayList<Integer> q, ArrayList<Integer> s) {
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
    }
    public void QMove() {
        int elem = queue.remove(0);
        stack.add(0, elem);
    }
    public void SMove() {
        int elem = stack.remove(0);
        queue.add(elem);
    }
    public void printPair() {
        System.out.print("Queue: " + queue);
        System.out.print(" Stack: " + stack + " ");
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        Pair other = (Pair) o;
        return queue.equals(other.queue) && stack.equals(other.stack);
    }
    @Override
    public int hashCode() {
        return Objects.hash(queue.hashCode(), stack.hashCode());
      }
}