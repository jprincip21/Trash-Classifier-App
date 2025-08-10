import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:trash_classifier_app/data/classes/custom_search_delegate.dart';
import 'package:trash_classifier_app/utils/app_directory.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  List<String> folderNames = [];

  Future<void> _loadContent() async {
    final List<Directory> loadedFolders = await loadFolders();
    folderNames = loadedFolders.map((f) => basename(f.path)).toList();
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
          delegate: CustomSearchDelegate(searchTerms: folderNames),
        );
      },
      icon: Icon(Icons.search),
    );
  }
}
