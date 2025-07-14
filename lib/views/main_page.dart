import 'package:flutter/material.dart';
import 'package:trash_classifier_app/data/notifiers.dart';
import 'package:trash_classifier_app/views/pages/camera_page.dart';
import 'package:trash_classifier_app/views/pages/home_page.dart';
import 'package:trash_classifier_app/views/pages/saved_data_page.dart';
import 'package:trash_classifier_app/views/pages/settings_page.dart';
import 'package:trash_classifier_app/views/widgets/navbar_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = const [HomePage(), CameraPage(), SavedDataPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trash Classifier"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return IndexedStack(index: selectedPage, children: _pages);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
