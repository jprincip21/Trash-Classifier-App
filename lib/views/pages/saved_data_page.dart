import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path/path.dart';
import 'package:trash_classifier_app/data/constants.dart';
import 'package:trash_classifier_app/data/notifiers.dart';
import 'package:trash_classifier_app/utils/app_directory.dart';
import 'package:trash_classifier_app/views/pages/selected_item_page.dart';

class SavedDataPage extends StatefulWidget {
  /// Holds user saved data
  const SavedDataPage({super.key});

  @override
  State<SavedDataPage> createState() => _SavedDataPageState();
}

class _SavedDataPageState extends State<SavedDataPage> {
  //TODO: use show search widget to be able to search for certain entries
  //TODO: Use Slidable for deleting entries.

  List<Directory> loadedFolders = [];

  @override
  void initState() {
    super.initState();
    _loadContent();
    newSavedDataNotifier.addListener(() {
      imageCache
          .clear(); //This works but clears all loaded images. should be changed.
      _loadContent(); //Refreshes loaded folders to update the listtiles that are displayed.
    });
  }

  Future<void> _loadContent() async {
    final Directory appDirectory = await getAppDirectory();
    final String appDirectoryPath = appDirectory.path;

    final Directory userSavedDataDir = Directory(
      "$appDirectoryPath/user_saved_data",
    );

    if (!await userSavedDataDir.exists()) {
      await userSavedDataDir.create(recursive: true);
    }

    final List<FileSystemEntity> userSavedDataContents = await userSavedDataDir
        .list()
        .toList();
    final List<Directory> allFolders = [];

    for (final entity in userSavedDataContents) {
      //Load Directory
      if (entity is Directory) {
        log('Folder: ${entity.path}');
        allFolders.add(entity);
      }
    }
    allFolders.sort((a, b) {
      return a.path.toLowerCase().compareTo(b.path.toLowerCase());
    });
    setState(() {
      loadedFolders = allFolders;
    });
  }

  Future<void> _deleteFolder(Directory folder) async {
    try {
      if (await folder.exists()) {
        await folder.delete(recursive: true);
        log("Deleted Item: ${basename(folder.path)}");
        setState(() {
          loadedFolders.remove(folder);
        });
      }
    } catch (e) {
      log("Error deleting folder: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadedFolders.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: loadedFolders.length,
        itemBuilder: (context, index) {
          final Directory folder = loadedFolders[index];
          final String folderName = basename(folder.path);
          return Column(
            children: [
              Slidable(
                closeOnScroll: true,
                endActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      onPressed: ((context) {
                        _deleteFolder(folder);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text("Item Delete Successfully"),
                          ),
                        );
                      }),
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),

                  title: Text(folderName, style: KTextStyle.labelStyle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return (SelectedItemPage(directory: folder));
                        },
                      ),
                    );
                  },
                ),
              ),
              Divider(
                height: 1,
                thickness: 1.5,
                indent: 8,
                endIndent: 8,
                color: Colors.grey,
              ),
            ],
          );
        },
      );
    } else {
      return Center(
        child: Text("No Saved Data", style: KTextStyle.descriptionStyle),
      );
    }
  }
}
