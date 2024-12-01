import 'package:uuid/uuid.dart';

class Article {
  final String id;
  final String? title;
  final String? description;
  final String? url;
  final DateTime? publishedAt;
  final String? imageUrl;
  bool isFavorite;
  bool isDownloaded;

  Article({
    required this.id,
    this.title,
    this.description,
    this.url,
    this.publishedAt,
    this.imageUrl,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String? ?? generateUniqueId(json),
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.tryParse(json['publishedAt']),
      imageUrl: json['urlToImage'] as String?,
      isFavorite: json['isFavorite'] ?? false,
      isDownloaded: json['isDownloaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'publishedAt': publishedAt?.toIso8601String(),
      'urlToImage': imageUrl,
      'isFavorite': isFavorite,
      'isDownloaded': isDownloaded,
    };
  }


  static String generateUniqueId(Map<String, dynamic> json) {
    final uuid = Uuid();
    return json['title'] != null
        ? '${json['title']}_${uuid.v4()}'
        : uuid.v4();
  }
}
