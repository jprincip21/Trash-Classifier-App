import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:trash_classifier_app/data/constants.dart';

class SelectedItemPage extends StatefulWidget {
  final Directory directory;
  const SelectedItemPage({super.key, required this.directory});

  @override
  State<SelectedItemPage> createState() => _SelectedItemPageState();
}

class _SelectedItemPageState extends State<SelectedItemPage> {
  late File? image = null;

  @override
  void initState() {
    super.initState();
    imageCache
        .clear(); //This works but clears all loaded images. should be changed.
    _loadContent();
  }

  Future<void> _loadContent() async {
    final List<FileSystemEntity> folder = await widget.directory
        .list()
        .toList();

    for (final file in folder) {
      if (file is File) {
        log("File: ${file.path}");
        image = file;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String itemName = basename(widget.directory.path);

    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: image != null
          ? Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  width: double.infinity,
                  child: Card(
                    child: ListTile(
                      leading: Text(
                        "Name: ",
                        style: KTextStyle.descriptionStyle,
                      ),
                      title: Text(itemName),
                    ),
                  ),
                ),
                SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Image.file(image!),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  width: double.infinity,
                  child: Card(
                    child: ListTile(
                      leading: Text(
                        "Type: ",
                        style: KTextStyle.descriptionStyle,
                      ),
                      title: Text("Loading..."),
                      trailing: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
