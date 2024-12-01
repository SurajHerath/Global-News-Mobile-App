import 'package:flutter/material.dart';
import '../Model/article_model.dart';

class ArticleDetailView extends StatelessWidget {
  final Article article;

  const ArticleDetailView({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text(
          article.title ?? 'Article Details',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.imageUrl != null && article.imageUrl!.isNotEmpty
                ? Image.network(
              article.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            )
                : const SizedBox.shrink(),

            const SizedBox(height: 16),
            Text(
              article.title ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              article.description ?? 'No description available',
              style: const TextStyle(fontSize: 16),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
