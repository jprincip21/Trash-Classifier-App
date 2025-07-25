import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trash_classifier_app/utils/app_directory.dart';

class SavedDataPage extends StatefulWidget {
  /// Holds user saved data
  const SavedDataPage({super.key});

  @override
  State<SavedDataPage> createState() => _SavedDataPageState();
}

class _SavedDataPageState extends State<SavedDataPage> {
  //TODO: change from loading singluar file to loading list of files, use show search widget with listview builder
  //TODO: Probably use a value Notifier to update the page every time a new image is saved.
  //TODO: Most likely convert the appdirectory to a constant because the same line of code is being constantly repeated.
  //TODO:

  List<File>? loadedFiles;
  File? loadedContent;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final Directory appDirectory = await getAppDirectory();
    final String appDirectoryPath = appDirectory.path;

    final Directory userSavedDataDir = Directory(
      "$appDirectoryPath/user_saved_data",
    );

    final List<FileSystemEntity> userSavedDataContents = await userSavedDataDir
        .list()
        .toList();

    for (final entity in userSavedDataContents) {
      if (entity is Directory) {
        log('📁 Folder: ${entity.path}');
        List<FileSystemEntity> folder = await entity.list().toList();

        for (final file in folder) {
          if (file is File) {
            log("File: ${file.path}");
            setState(() {
              loadedContent = file;
            });
          }
        }
      }
    }
    final selectedFile = File("$appDirectoryPath/user_saved_data/a/a.jpg");
    // if (await selectedFile.exists()) {
    //   setState(() {
    //     loadedContent = selectedFile;
    //   });
    // }
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
