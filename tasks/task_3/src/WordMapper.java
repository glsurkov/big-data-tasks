import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.lucene.analysis.*;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;

import java.io.*;
import java.util.*;

public class WordMapper extends Mapper<Object, Text, Text, Text> {

    private Analyzer analyzer;

    private List<String> sentenceToWords(String sentence) throws IOException {
        List<String> result = new ArrayList<>();

        try (TokenStream ts = analyzer.tokenStream(null, new StringReader(sentence))) {
            CharTermAttribute attr = ts.addAttribute(CharTermAttribute.class);
            ts.reset();

            while (ts.incrementToken()) {
                result.add(attr.toString());
            }

            ts.end();
        }
        return result;
    }

    @Override
    protected void setup(Context context) {
        analyzer = new StandardAnalyzer();
    }

    @Override
    protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {
        String[] sentences = value.toString().split("(\\[\\(|\\)\\]|[.!?])+");

        for (String sentence : sentences) {
            List<String> words = sentenceToWords(sentence);

            for (int i = 0; i < words.size() - 1; i++) {
                String currentWord = words.get(i);
                String nextWord = words.get(i + 1);

                context.write(new Text(currentWord), new Text(nextWord));
            }
        }
    }

    @Override
    protected void cleanup(Context context) throws IOException {
        analyzer.close();
    }
}