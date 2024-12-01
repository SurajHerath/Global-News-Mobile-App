import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/news_controller.dart'; // Adjust the path as per your project
import 'View/home_view.dart';


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.red,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
  ),
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsController()),
      ],
      child: Consumer<NewsController>(
        builder: (context, controller, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: controller.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: HomeView(),
          );
        },
      ),
    );
  }
}
