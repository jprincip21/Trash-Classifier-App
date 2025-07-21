import 'package:flutter/material.dart';
import 'package:trash_classifier_app/data/notifiers.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  @override
  Widget build(BuildContext context) {
    /// Builds the Bottom Navigation bar when called
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          //TODO: Update icon color based on dark/light mode
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.list), label: "Saved Data"),
          ],
          selectedIndex: selectedPage,
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
        );
      },
    );
  }
}
