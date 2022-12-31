import java.util.*;

public class ZPair {
    public ArrayList<Integer> queue;
    public ArrayList<Integer> stack;

    public ZPair(ArrayList<Integer> q, ArrayList<Integer> s) {
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
    public void printZPair() {
        System.out.print("Queue: " + queue);
        System.out.print(" Stack: " + stack + " ");
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        ZPair other = (ZPair) o;
        return queue.equals(other.queue) && stack.equals(other.stack);
    }
    @Override
    public int hashCode() {
        return Objects.hash(queue.hashCode(), stack.hashCode());
      }
}