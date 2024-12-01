import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemNavigator.pop
import 'package:news/Controller/news_controller.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [


          Opacity(
            opacity: 0.9,
            child: SwitchListTile(
              secondary: const Icon(Icons.brightness_6),
              title: const Text('Dark Mode'),
              value: newsController.isDarkMode,
              onChanged: (bool value) {
                newsController.isDarkMode = value;
              },
            ),
          ),
          const Divider(),


          Opacity(
            opacity: 0.9,
            child: ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit App'),
              onTap: () {

                SystemNavigator.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
