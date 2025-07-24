import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedDataPage extends StatefulWidget {
  /// Holds user saved data
  const SavedDataPage({super.key});

  @override
  State<SavedDataPage> createState() => _SavedDataPageState();
}

class _SavedDataPageState extends State<SavedDataPage> {
  //TODO: change from loading singluar file to loading list of files, use show search widget with listview builder
  List<File>? loadedFiles;
  File? loadedContent;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final String appDirectory = (await getApplicationDocumentsDirectory()).path;

    final String fileName = "a.jpg";

    final file = File("$appDirectory/user_saved_data/a/$fileName");
    if (await file.exists()) {
      setState(() {
        loadedContent = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Saved Data"),

          if (loadedContent != null) Image.file(loadedContent!),
        ],
      ),
    );
  }
}
