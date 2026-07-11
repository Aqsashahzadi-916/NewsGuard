import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  
  static const String apiKey = "b90b70c3ff704aa5a6a787106c647140";

  static Future<List<dynamic>> searchNews(String query) async {
    print("Received Query: $query");

    // search as an exact phrase
    String finalQuery = "$query politics";

    final url =
        "https://newsapi.org/v2/everything?"
        "q=${Uri.encodeComponent(finalQuery)}"
        "&searchIn=title,description"
        "&language=en"
        "&sortBy=relevancy"
        "&pageSize=20"
        "&apiKey=$apiKey";

    print("URL: $url");

    final response = await http.get(Uri.parse(url));

    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print("Total Results: ${data["totalResults"]}");
      print("Articles: ${data["articles"]}");

      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to load news: ${response.body}");
    }
  }
}
