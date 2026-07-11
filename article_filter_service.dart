class ArticleFilterService {
  // Political entities
  static final Set<String> politicalWords = {
    "president",
    "prime",
    "minister",
    "government",
    "parliament",
    "congress",
    "senate",
    "cabinet",
    "white",
    "house",
    "democrat",
    "republican",
    "pakistan",
    "india",
    "china",
    "russia",
    "ukraine",
    "america",
    "usa",
    "washington",
    "islamabad",
    "beijing",
    "moscow",
    "nato",
    "un",
    "eu",
    "trump",
    "biden",
    "putin",
    "zelensky",
    "modi",
    "shehbaz",
  };

  // Political events
  static final Set<String> eventWords = {
    "dead",
    "death",
    "died",
    "dies",
    "kill",
    "killed",
    "attack",
    "war",
    "missile",
    "strike",
    "election",
    "vote",
    "voting",
    "campaign",
    "budget",
    "meeting",
    "summit",
    "agreement",
    "ceasefire",
    "arrest",
    "resigned",
    "sanctions",
  };

  // Entertainment / Sports
  static final Set<String> badWords = {
    "actor",
    "actress",
    "movie",
    "film",
    "music",
    "album",
    "concert",
    "celebrity",
    "tv",
    "show",
    "football",
    "soccer",
    "cricket",
    "wwe",
    "ufc",
    "boxing",
    "tribute",
    "village people",
    "ymca",
    "singer",
  };

  static List<dynamic> filterArticles(
      List<dynamic> articles,
      List<String> keywords,
      ) {

    List<dynamic> filtered = [];

    // Separate entity and event
    List<String> entities = [];
    List<String> events = [];

    for (var k in keywords) {
      if (eventWords.contains(k.toLowerCase())) {
        events.add(k.toLowerCase());
      } else {
        entities.add(k.toLowerCase());
      }
    }

    for (var article in articles) {

      String title =
      (article["title"] ?? "").toString().toLowerCase();

      String description =
      (article["description"] ?? "").toString().toLowerCase();

      String text = "$title $description";

      int score = 0;

      //------------------------
      // Exact Phrase
      //------------------------

      String phrase = keywords.join(" ").toLowerCase();

      if (phrase.length > 5 && text.contains(phrase)) {
        score += 15;
      }

      //------------------------
      // Entity Matching
      //------------------------

      int entityMatch = 0;

      for (String entity in entities) {
        if (text.contains(entity)) {
          entityMatch++;
          score += 5;
        }
      }

      //------------------------
      // Event Matching
      //------------------------

      int eventMatch = 0;

      for (String event in events) {
        if (text.contains(event)) {
          eventMatch++;
          score += 5;
        }
      }

      //------------------------
      // Political Context
      //------------------------

      for (String word in politicalWords) {
        if (text.contains(word)) {
          score++;
        }
      }

      //------------------------
      // Bad Words
      //------------------------

      for (String bad in badWords) {
        if (text.contains(bad)) {
          score -= 10;
        }
      }

      //------------------------
      // Mandatory Checks
      //------------------------

      if (entities.isNotEmpty && entityMatch == 0) {
        score = -100;
      }

      if (events.isNotEmpty && eventMatch == 0) {
        score = -100;
      }

      //------------------------
      // Debug
      //------------------------

      print("------------------------------");
      print(title);
      print("Entity Match : $entityMatch");
      print("Event Match : $eventMatch");
      print("Final Score : $score");

      //------------------------
      // Final Decision
      //------------------------

      if (score >= 10) {
        filtered.add(article);
      }
    }

    return filtered;
  }
}