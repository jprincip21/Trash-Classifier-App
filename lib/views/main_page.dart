import 'package:flutter/material.dart';
import 'package:trash_classifier_app/data/notifiers.dart';
import 'package:trash_classifier_app/views/pages/home_page.dart';
import 'package:trash_classifier_app/views/pages/saved_data_page.dart';
import 'package:trash_classifier_app/views/pages/settings_page.dart';
import 'package:trash_classifier_app/views/widgets/camera_button_widget.dart';
import 'package:trash_classifier_app/views/widgets/navbar_widget.dart';
import 'package:trash_classifier_app/views/widgets/search_bar_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = const [HomePage(), SavedDataPage()];

  @override
  Widget build(BuildContext context) {
    /// Builds the current displayed page using selected page notifier + Index stack
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Trash Classifier"),
            actions: [
              selectedPage == 0
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.settings),
                    )
                  : SearchBarWidget(),
            ],
          ),
          body: IndexedStack(index: selectedPage, children: _pages),
          floatingActionButton: selectedPage == 0 ? CamerabuttonWidget() : null,
          bottomNavigationBar: NavbarWidget(),
        );
      },
    );
  }
}
