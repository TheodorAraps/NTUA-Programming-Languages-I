import java.io.*;
import java.util.*;

public class QSsort {
    public static void main(String[] args) throws FileNotFoundException {
        if (args.length != 1) {
            System.out.println("Correct usage: java QSSort <filename>");
            System.exit(-1);
        }
        BufferedReader br = new BufferedReader(new FileReader(args[0]));
        int N = 0;
        int[] arr = new int[1];
        Deque<Integer> startQueue = new ArrayDeque<>();
        try {
        N = Integer.parseInt(br.readLine());
        arr = new int[N];
        String[] line = br.readLine().split(" "); // read second line
        for (int i = 0; i < N; i++)
        {
            arr[i] = Integer.parseInt(line[i]);
            startQueue.addLast(arr[i]);
        }
        br.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        Arrays.sort(arr);
        Deque<Integer> sortedQueue = new ArrayDeque<>();
        for (int i = 0; i < N; i++)
        {
            sortedQueue.addLast(arr[i]);
        }
        // System.out.println(sortedQueue.toString());
        String finalSeq = "empty";
        ArrayList<Integer> startArray = new ArrayList<>(startQueue);
        ArrayList<Integer> sortedArray = new ArrayList<>(sortedQueue);
        
        // ArrayList<Integer> stack = new ArrayList<>();
        // Pair Pair1 = new Pair(startArray, stack);
        // Pair1.printPair();
        // Pair1.QMove(); Pair1.QMove(); Pair1.SMove(); Pair1.QMove(); Pair1.SMove();
        // Pair1.SMove(); Pair1.QMove(); Pair1.QMove(); Pair1.SMove(); Pair1.SMove();
        // Pair1.printPair();
        
        // Pair Pair2 = new Pair(startArray, stack);
        // // Pair2.printPair();
        // Pair2.QMove(); Pair2.SMove(); Pair2.QMove(); Pair2.SMove(); Pair2.QMove();
        // Pair2.SMove(); Pair2.QMove(); Pair2.QMove(); Pair2.SMove(); Pair2.QMove(); 
        // Pair2.SMove(); Pair2.SMove();
        // Pair2.printPair();

        // System.out.println(Pair1.equals(Pair2));
        // Set<Pair> yes = new HashSet<>();
        // yes.add(Pair1);
        // System.out.println(yes.contains(Pair2));


        if (!startArray.equals(sortedArray)) {
            QSsolver solver = new QSsolver(startArray, sortedArray);
            while (!solver.solved) {
                solver.checkNextMove();
            }
            finalSeq = solver.finalSeq;
        }

        System.out.println(finalSeq);
    }
}