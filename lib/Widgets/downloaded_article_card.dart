import 'package:flutter/material.dart';
import '../Model/article_model.dart';
import '../Controller/news_controller.dart';
import 'package:provider/provider.dart';
import '../View/article_detail_view.dart';

class DownloadedArticleCard extends StatelessWidget {
  final Article article;

  const DownloadedArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasValidData = article.title != null && article.title!.isNotEmpty &&
        article.description != null && article.description!.isNotEmpty;

    return Consumer<NewsController>(
      builder: (context, newsController, child) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailView(article: article),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                  Image.network(
                    article.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 100),
                  )
                else
                  const Icon(Icons.image, size: 100),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    article.title ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    article.description ?? 'No Description',
                    style: const TextStyle(fontSize: 14),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasValidData)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            article.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: article.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            newsController.toggleFavorite(article);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            newsController.deleteDownloadedArticle(article);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Removed '${article.title}' from downloads"),
                              ),
                            );
                          },
                        ),

                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

