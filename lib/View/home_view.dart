import 'package:flutter/material.dart';
import 'package:news/View/search_view.dart';
import 'package:provider/provider.dart';
import '../Controller/news_controller.dart';
import '../Widgets/article_card.dart';
import '../View/favorites_view.dart';
import '../View/category_view.dart';
import '../View/settings_view.dart';
import '../View/download_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);

    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text(
          'Global News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              newsController.sortArticles(order: value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'date', child: Text('Sort by Date')),
              PopupMenuItem(value: 'name', child: Text('Sort by Name')),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[800],
              ),
              child: const Text(
                'Global News',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.black),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.black),
              title: const Text('Categories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.black),
              title: const Text('Downloads'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadsView()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsView()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search articles',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    final query = searchController.text.trim();
                    if (query.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchView(searchQuery: query),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: newsController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: newsController.articles.length,
              itemBuilder: (ctx, index) {
                return ArticleCard(article: newsController.articles[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh, color: Colors.white,),
        backgroundColor: Colors.red[800],
        onPressed: () {
          newsController.loadArticles(newsController.currentCategory);
        },
      ),
    );
  }
}
