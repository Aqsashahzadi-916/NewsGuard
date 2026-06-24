import 'dart:convert';
import 'package:http/http.dart' as http;

class GNewsService {
  static const String apiKey = "0a3f88694ed2a5f2d05eccb102ca2ca1";

  static Future<List<dynamic>> searchNews(String query) async {
    final url =
        "https://gnews.io/api/v4/search?q=${Uri.encodeComponent(query)}&lang=en&max=10&apikey=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["articles"] ?? [];
    } else {
      throw Exception("Failed to load news");
    }
  }
}