// Αλγόριθμος: Ελέγχουμε τις πόλεις από την ελάχιστη συνολική απόσταση στη μέγιστη.
// Αν το πιο μακρινό όχημα βρίσκεται πιο μακρία από όλα τα υπόλοιπα στοιχεία (+1)
// τότε δεν μπορούμε να φτάσουμε εκεί με τον κανόνα που δίνεται.
// Σημείωση: Οι οδηγίες για τη σωστή χρήση του SortedMap και του αντίστοιχου iterator
// είναι από την ακόλουθη σελίδα:
// https://www.geeksforgeeks.org/sortedmap-java-examples/

import java.io.*;
import java.util.*;

public class Round {
    public static void main(String[] args) {
        int N = 0;
        int K = 0;
        int[] car = new int[0];
        if (args.length != 1) {
            System.out.println("Corrent usage: java Round <filename>");
            System.exit(-1);
        }
        try {
            // Δημιουργία buffered reader και ανάγνωση
            BufferedReader br = new BufferedReader (new FileReader(args[0]));
            String[] line1 = br.readLine().split(" ");
            N = Integer.parseInt(line1[0]);
            K = Integer.parseInt(line1[1]);
            String[] line2 = br.readLine().split(" ");
            car = new int[K];
            for (int i = 0; i < K; i++) {
                car[i] = Integer.parseInt(line2[i]);
            }
            br.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        // System.out.println(N); // debug
        // System.out.println(K); // debug
        // System.out.println(Arrays.toString(car)); // debug
        // int[] total = new int[N];       // The total distance from all cars
        int[] sum = new int[N];         // The total distance from all cars except the farthest
        int[] farthest = new int[N];    // The distance of the car farthest from the city
        int distance = 0;
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < K; j++) {
                if (car[j] <= i) {
                    distance = i - car[j];
                }
                else {
                    distance = N - (car[j] - i);
                }
                // total[i] += distance;
                if (distance > farthest[i]) {
                    sum[i] += farthest[i];
                    farthest[i] = distance;
                }
                else {
                    sum[i] += distance;
                }
            }
        }
        // Map που κρατάει τα ζεύγη (συνολική απόσταση, πόλη) σε φθίνουσα σειρά ως προς τη συνολική απόσταση
        SortedMap<Integer, Integer> map = new TreeMap<>();
        for (int i = 0; i < N; i++) {
            map.put(sum[i] + farthest[i], i);
        }
        // System.out.println(Arrays.toString(total));
        // System.out.println(Arrays.toString(farthest));
        // System.out.println(Arrays.toString(sum));
        Set<Map.Entry<Integer, Integer>> s = map.entrySet();
        Iterator<Map.Entry<Integer, Integer>> it = s.iterator(); // Iterator που βγάζει ένα-ένα τα στοιχεία του map
        int finalCity = 0;
        int finalDistance = 0;
        boolean found = false;
        while (!found) {
            Map.Entry<Integer, Integer> m = (Map.Entry<Integer, Integer>)it.next();
            int city = (Integer)m.getValue();
            if (farthest[city] - 1 <= sum[city]) {
                found = true;
                finalCity = city;
                finalDistance = farthest[city] + sum[city];
                break;
            }
        }
        // Έλεγχος για το αν υπάρχει πόλη με ίδια συνολική απόσταση και με μικρότερη θέση
        for (int i = 0; i < finalCity; i++) {
            if (sum[i] + farthest[i] == sum[finalCity] + farthest[finalCity]) {
                finalCity = i;
                break;
            }
        }
        System.out.print(finalDistance + " " + finalCity);
    }
}
