class KeywordService {

  // Common words to ignore
  static final Set<String> stopWords = {
    "the","a","an","is","are","was","were","am","be","been","being",
    "to","of","for","on","in","at","by","with","and","or","but",
    "if","then","this","that","these","those","from","as","it","its",
    "into","about","after","before","during","between","against",
    "because","while","has","have","had","will","would","could",
    "should","may","might","must","do","does","did","not",
    "i","we","you","they","he","she",
    "heard","heared","hear",
    "think","believe",
    "claim","claims","claimed",
    "says","said",
    "according",
    "news","report","reported",
    "today","yesterday","tomorrow",
    "met","meet","discuss","discussed",
    "launch","launched",
    "new","latest",
  };

  // Political entities
  static final Set<String> politicalWords = {

    // Titles
    "president",
    "prime",
    "minister",
    "government",
    "parliament",
    "congress",
    "senate",
    "cabinet",
    "assembly",

    // Elections
    "election",
    "elections",
    "vote",
    "voting",
    "campaign",

    // Parties
    "democrat",
    "democrats",
    "republican",
    "republicans",

    // Organizations
    "white",
    "house",
    "nato",
    "un",
    "eu",

    // Countries
    "pakistan",
    "india",
    "china",
    "russia",
    "ukraine",
    "usa",
    "america",
    "israel",
    "iran",

    // Capitals
    "washington",
    "islamabad",
    "beijing",
    "moscow",
    "kyiv",
    "london",

    // Leaders
    "donald",
    "trump",
    "joe",
    "biden",
    "putin",
    "zelensky",
    "modi",
    "narendra",
    "imran",
    "khan",
    "shehbaz",
    "sharif",
    "kamala",
    "harris",
    "netanyahu",
    "xi",
    "jinping",
  };

  // Political events
  static final Set<String> eventWords = {

    "dead",
    "death",
    "dies",
    "died",
    "kill",
    "killed",

    "attack",
    "attacked",
    "war",
    "conflict",
    "missile",
    "airstrike",
    "bomb",
    "bombing",
    "strike",
    "invasion",

    "arrest",
    "arrested",

    "sanctions",

    "budget",

    "meeting",
    "summit",

    "agreement",
    "treaty",
    "ceasefire",

    "protest",

    "resigned",
    "resignation",

    "border",
    "terrorist",
    "hostage",
    "hostages",

    "nuclear",
  };

  // Build News API Query
  static String buildSearchQuery(String text) {

    String keywords = extractKeywords(text);

    List<String> words = keywords.split(" ");

    List<String> entity = [];
    List<String> events = [];

    for (String word in words) {

      String lower = word.toLowerCase();

      if (eventWords.contains(lower)) {
        events.add(lower);
      }

      else if (RegExp(r'^[A-Z]').hasMatch(word) ||
          politicalWords.contains(lower)) {

        entity.add(word);
      }
    }

    entity = entity.toSet().toList();
    events = events.toSet().toList();

    String entityPart = entity.join(" ");

    String eventPart = events.join(" ");

    if (entityPart.isNotEmpty && eventPart.isNotEmpty) {

      return "\"$entityPart\" AND $eventPart";
    }

    if (entityPart.isNotEmpty) {

      return "\"$entityPart\"";
    }

    return keywords;
  }

  // Extract Keywords
  static String extractKeywords(String text) {

    text = text.replaceAll(RegExp(r'[^\w\s]'), '');

    List<String> words = text.split(RegExp(r'\s+'));

    List<String> keywords = [];

    for (String word in words) {

      if (word.trim().isEmpty) continue;

      String lower = word.toLowerCase();

      if (stopWords.contains(lower)) continue;

      if (politicalWords.contains(lower)) {

        keywords.add(word);
        continue;
      }

      if (eventWords.contains(lower)) {

        keywords.add(word);
        continue;
      }

      if (RegExp(r'^[A-Z]').hasMatch(word)) {

        keywords.add(word);
        continue;
      }

      if (RegExp(r'^\d{4}$').hasMatch(word)) {

        keywords.add(word);
        continue;
      }

      if (word.length >= 6) {

        keywords.add(word);
      }
    }

    keywords = keywords.toSet().toList();

    return keywords.take(8).join(" ");
  }
}