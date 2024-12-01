import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/news_controller.dart';
import '../Widgets/downloaded_article_card.dart';

class DownloadsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text(
          'Downloaded Article',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<NewsController>(
        builder: (context, newsController, child) {
          final downloadedArticles = newsController.downloadedArticles;

          if (downloadedArticles.isEmpty) {
            return const Center(child: Text('No downloaded articles'));
          }
          return ListView.builder(
            itemCount: downloadedArticles.length,
            itemBuilder: (ctx, index) {
              final article = downloadedArticles[index];
              return DownloadedArticleCard(article: article);
            },
          );
        },
      ),
    );
  }
}
