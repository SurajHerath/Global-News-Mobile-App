import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/news_controller.dart';

class CategoryView extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'name': 'general', 'icon': Icons.public},
    {'name': 'business', 'icon': Icons.business},
    {'name': 'science', 'icon': Icons.science},
    {'name': 'health', 'icon': Icons.health_and_safety},
    {'name': 'technology', 'icon': Icons.computer},
    {'name': 'entertainment', 'icon': Icons.movie},
    {'name': 'sports', 'icon': Icons.sports},
  ];

  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              newsController.loadArticles(category['name']);
              Navigator.pop(context);
            },
            child: Card(
              color: Colors.white38.withOpacity(0.84),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'],
                      color: Colors.red[800],
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      category['name'].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
