class KeywordService {

  static final Set<String> stopWords = {
    "the","a","an","is","are","was","were","am","be","been",
    "to","of","for","on","in","at","by","with","and","or",
    "but","if","then","this","that","these","those","from",
    "as","it","its","into","about","after","before","during",
    "between","against","because","while","has","have","had",
    "will","would","could","should","may","might","must",
    "do","does","did","not","i","we","you","they","he","she",
    "heard","hear","think","believe","claim","claims","claimed",
    "says","said","according","news","report","reported",
    "today","yesterday","tomorrow","met","meet","discuss",
    "discussed","launch","launched","new","latest"
  };

  static String buildSearchQuery(String text) {

    text = text.replaceAll(RegExp(r'[^\w\s-]'), '');

    List<String> words = text.split(RegExp(r'\s+'));

    List<String> keywords = [];

    for (String word in words) {

      String lower = word.toLowerCase().trim();

      if (lower.isEmpty) continue;
      if (stopWords.contains(lower)) continue;

      if (word.length >= 4) {
        keywords.add(word);
      }
    }

    // Remove duplicates
    keywords = keywords.toSet().toList();

    // Maximum 5 keywords
    keywords = keywords.take(5).toList();

    return keywords.join(" ");
  }

  static String extractKeywords(String text) {
    return buildSearchQuery(text);
  }
}
