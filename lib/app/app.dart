import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_classifier_app/data/constants.dart';
import 'package:trash_classifier_app/data/notifiers.dart';
import 'package:trash_classifier_app/views/main_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initThemeMode();
  }

  void initThemeMode() async {
    /// Gets Darkmode information for Material App
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? themeMode = prefs.getBool(KConstant.darkModeKey);
    darkModeNotifier.value =
        themeMode ?? false; //! ?? Sets default value if none is there
  }

  @override
  Widget build(BuildContext context) {
    /// Holds the Material App and controls if the app is in darkmode
    return ValueListenableBuilder(
      valueListenable: darkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 177, 255, 194),
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
          home: MainPage(),
        );
      },
    );
  }
}
