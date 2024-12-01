import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/article_model.dart';
import '../Controller/news_controller.dart';
import '../Widgets/article_card.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<NewsController>(
        builder: (context, controller, child) {
          final favorites = controller.articles.where((a) => a.isFavorite).toList();

          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites added yet.'));
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (ctx, index) {
              return ArticleCard(article: favorites[index]);
            },
          );
        },
      ),
    );
  }
}
