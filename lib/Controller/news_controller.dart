import 'package:flutter/foundation.dart';
import '../Model/article_model.dart';
import '../Services/news_service.dart';
import '../Services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsController with ChangeNotifier {
  final NewsService _newsService = NewsService();
  final StorageService _storageService = StorageService();

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  List<Article> _searchResults = [];
  List<Article> get searchResults => _searchResults;

  List<Article> _downloadedArticles = [];
  List<Article> get downloadedArticles => _downloadedArticles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentCategory = 'general';
  String get currentCategory => _currentCategory;

  String _currentSortOrder = 'default';
  String get currentSortOrder => _currentSortOrder;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    _saveThemeMode(value);
    notifyListeners();
  }

  NewsController() {
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _loadThemeMode();
    await loadArticles(_currentCategory);
    await loadDownloads();
  }

  Future<void> loadArticles(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      _articles = await _newsService.fetchArticles(category);
      _currentCategory = category;

      await _loadFavorites();
      await loadDownloads();
      await _storageService.saveOfflineArticles(_articles);

      for (var article in _articles) {
        article.isDownloaded = _downloadedArticles.any((a) => a.id == article.id);
      }
    } catch (e) {
      debugPrint('Error loading articles: $e');
      _articles = await _storageService.loadOfflineArticles();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    try {
      List<Article> favorites = await _storageService.loadFavorites();

      for (var article in _articles) {
        article.isFavorite = favorites.any((fav) => fav.id == article.id);
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  void toggleFavorite(Article article) async {
    article.isFavorite = !article.isFavorite;
    await _saveFavoritesToStorage();
    notifyListeners();
  }

  Future<void> _saveFavoritesToStorage() async {
    try {
      await _storageService.saveFavorites(_articles.where((a) => a.isFavorite).toList());
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> toggleDownload(Article article) async {
    try {
      if (article.isDownloaded) {
        article.isDownloaded = false;
        _downloadedArticles.removeWhere((a) => a.id == article.id);
      } else {
        article.isDownloaded = true;
        if (!_downloadedArticles.any((a) => a.id == article.id)) {
          _downloadedArticles.add(article);
        }
      }
      await _saveDownloadsToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling download: $e');
    }
  }

  Future<void> deleteDownloadedArticle(Article article) async {
    try {
      if (article.id == null || article.id!.isEmpty) {
        debugPrint('Invalid article ID: Cannot delete');
        return;
      }
      debugPrint('Deleting article with ID: ${article.id}');
      _downloadedArticles.removeWhere((a) => a.id == article.id);

      final index = _articles.indexWhere((a) => a.id == article.id);
      if (index != -1) {
        _articles[index].isDownloaded = false;
      }
      await _saveDownloadsToStorage();
      notifyListeners();

      debugPrint('Article deleted successfully and UI refreshed.');
    } catch (e) {
      debugPrint('Error deleting article: $e');
    }
  }

  Future<void> _saveDownloadsToStorage() async {
    try {
      await _storageService.saveDownloads(_downloadedArticles);
    } catch (e) {
      debugPrint('Error saving downloads: $e');
    }
  }

  Future<void> loadDownloads() async {
    try {
      _downloadedArticles = await _storageService.loadDownloads();

      for (var article in _articles) {
        if (article.id != null && article.id!.isNotEmpty) {
          article.isDownloaded = _downloadedArticles.any((a) => a.id == article.id);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading downloads: $e');
      _downloadedArticles = [];
    }
  }

  void searchArticles(String query) {
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = _articles.where((article) =>
      (article.title ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (article.description ?? '').toLowerCase().contains(query.toLowerCase())
      ).toList();
    }

    sortArticles();
    notifyListeners();
  }

  void sortArticles({String order = 'default'}) {
    _currentSortOrder = order;

    if (order == 'name') {
      _articles.sort((a, b) => (a.title ?? '').toLowerCase().compareTo((b.title ?? '').toLowerCase()));
      _searchResults.sort((a, b) => (a.title ?? '').toLowerCase().compareTo((b.title ?? '').toLowerCase()));
    } else if (order == 'date') {
      _articles.sort((a, b) => (b.publishedAt ?? DateTime.now()).compareTo(a.publishedAt ?? DateTime.now()));
      _searchResults.sort((a, b) => (b.publishedAt ?? DateTime.now()).compareTo(a.publishedAt ?? DateTime.now()));
    }

    notifyListeners();
  }

  bool isFavorite(Article article) {
    return _articles.any((a) => a.id == article.id && a.isFavorite);
  }

  bool isDownloaded(Article article) {
    return _downloadedArticles.any((a) => a.id == article.id);
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      _isDarkMode = false;
    }
  }

  Future<void> _saveThemeMode(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', value);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }
}

