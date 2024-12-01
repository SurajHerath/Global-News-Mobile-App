import 'package:flutter/material.dart';
import '../Model/article_model.dart';
import '../Controller/news_controller.dart';
import 'package:provider/provider.dart';
import '../View/article_detail_view.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox.shrink(),
                  ),

                // Show title if it exists
                if (article.title != null && article.title!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      article.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),


                if (article.description != null && article.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      article.description!,
                      style: const TextStyle(fontSize: 14),
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),


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
                        icon: Icon(
                          Icons.download,
                          color: article.isDownloaded ? Colors.lightGreen[700] : Colors.blueAccent,
                        ),
                        onPressed: () {
                          newsController.toggleDownload(article);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(article.isDownloaded
                                  ? "Downloaded '${article.title}'"
                                  : "Removed '${article.title}' from downloads"),
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

