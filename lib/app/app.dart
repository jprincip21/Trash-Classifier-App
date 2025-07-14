import 'package:flutter/material.dart';
import 'package:trash_classifier_app/views/main_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 177, 255, 194),
          brightness: Brightness.dark,
        ),
      ),
      home: MainPage(),
    );
  }
}
