import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class Summer extends Reducer<Text, Text, Text, Text> {
    protected void reduce(Text word, Iterable<Text> nextWords, Context context) throws IOException, InterruptedException {
        Map<String, Integer> frequencyMap = new HashMap<>();

        for (Text next : nextWords) {
            String nextWord = next.toString();
            frequencyMap.put(nextWord, frequencyMap.getOrDefault(nextWord, 0) + 1);
        }

        String mostFrequentNext = null;
        int highestFrequency = 0;

        for (Map.Entry<String, Integer> entry : frequencyMap.entrySet()) {
            if (entry.getValue() > highestFrequency) {
                highestFrequency = entry.getValue();
                mostFrequentNext = entry.getKey();
            }
        }

        if (mostFrequentNext != null) {
            context.write(word, new Text(mostFrequentNext));
        }
    }
}
