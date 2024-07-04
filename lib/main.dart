import 'package:flutter/material.dart';
import 'package:flutter_dismissible_example_app/dismissible_example.dart';
import 'package:flutter_dismissible_example_app/theme_provider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: ThemeData.light(
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          home: DismissibleTodo(),
        );
      },
    );
  }
}