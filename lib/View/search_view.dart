import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/news_controller.dart';
import '../Widgets/article_card.dart';

class SearchView extends StatelessWidget {
  final String searchQuery;

  const SearchView({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      newsController.searchArticles(searchQuery);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              newsController.sortArticles(order: value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'default', child: Text('Default')),
              PopupMenuItem(value: 'date', child: Text('Sort by Date')),
              PopupMenuItem(value: 'name', child: Text('Sort by Name')),
            ],
          ),
        ],
      ),
      body: newsController.searchResults.isEmpty
          ? Center(child: Text('No articles found for "$searchQuery".'))
          : ListView.builder(
        itemCount: newsController.searchResults.length,
        itemBuilder: (ctx, index) {
          return ArticleCard(article: newsController.searchResults[index]);
        },
      ),
    );
  }
}
