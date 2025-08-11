import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trash_classifier_app/data/classes/custom_search_delegate.dart';
import 'package:trash_classifier_app/utils/app_directory.dart';

class SearchBarWidget extends StatefulWidget {
  /// Allows for users to access a search bar
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  List<Directory> loadedFolders = [];
  List<String> folderNames = [];

  Future<void> _loadContent() async {
    loadedFolders = await loadFolders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (!mounted) {
          return;
        }
        await _loadContent();
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(loadedFolders: loadedFolders),
        );
      },
      icon: Icon(Icons.search),
    );
  }
}
