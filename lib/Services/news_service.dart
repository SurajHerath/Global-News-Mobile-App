import 'dart:convert';
import '../Model/article_model.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '776f7bd0fd0c4fc39229fa4f8f3a1199';

  Future<List<Article>> fetchArticles(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/top-headlines?category=$category&country=us&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['articles'] as List)
          .map((json) => Article.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch articles.');
    }
  }
}
