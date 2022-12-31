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
        // ZPair ZPair1 = new ZPair(startArray, stack);
        // ZPair1.printZPair();
        // ZPair1.QMove(); ZPair1.QMove(); ZPair1.SMove(); ZPair1.QMove(); ZPair1.SMove();
        // ZPair1.SMove(); ZPair1.QMove(); ZPair1.QMove(); ZPair1.SMove(); ZPair1.SMove();
        // ZPair1.printZPair();
        
        // ZPair ZPair2 = new ZPair(startArray, stack);
        // // ZPair2.printZPair();
        // ZPair2.QMove(); ZPair2.SMove(); ZPair2.QMove(); ZPair2.SMove(); ZPair2.QMove();
        // ZPair2.SMove(); ZPair2.QMove(); ZPair2.QMove(); ZPair2.SMove(); ZPair2.QMove(); 
        // ZPair2.SMove(); ZPair2.SMove();
        // ZPair2.printZPair();

        // System.out.println(ZPair1.equals(ZPair2));
        // Set<ZPair> yes = new HashSet<>();
        // yes.add(ZPair1);
        // System.out.println(yes.contains(ZPair2));


        if (!startArray.equals(sortedArray)) {
            ZQSsolver solver = new ZQSsolver(startArray, sortedArray);
            while (!solver.solved) {
                solver.checkNextMove();
            }
            finalSeq = solver.finalSeq;
        }

        System.out.println(finalSeq);
    }
}