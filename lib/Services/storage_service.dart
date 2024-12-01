import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/article_model.dart';

class StorageService {
  static const _favoritesKey = 'favorites';
  static const _offlineKey = 'offline';
  static const _downloadsKey = 'downloads';


  Future<void> saveFavorites(List<Article> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteArticles = articles.where((a) => a.isFavorite).toList();
    final encoded = jsonEncode(favoriteArticles.map((a) => a.toJson()).toList());
    await prefs.setString(_favoritesKey, encoded);
  }

  Future<List<Article>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey) ?? '[]';
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map((json) => Article.fromJson(json)).toList();
  }

  Future<void> saveOfflineArticles(List<Article> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(articles.map((a) => a.toJson()).toList());
    await prefs.setString(_offlineKey, encoded);
  }

  Future<List<Article>> loadOfflineArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_offlineKey) ?? '[]';
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map((json) => Article.fromJson(json)).toList();
  }

  Future<void> saveDownloads(List<Article> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(articles.map((a) => a.toJson()).toList());
    await prefs.setString(_downloadsKey, encoded);
  }

  Future<List<Article>> loadDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_downloadsKey) ?? '[]';
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map((json) => Article.fromJson(json)).toList();
  }



}
