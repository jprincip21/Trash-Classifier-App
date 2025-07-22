import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trash_classifier_app/data/constants.dart';
import 'package:trash_classifier_app/data/notifiers.dart';

class SaveImagePage extends StatefulWidget {
  const SaveImagePage({super.key});

  @override
  State<SaveImagePage> createState() => _SaveImagePageState();
}

class _SaveImagePageState extends State<SaveImagePage> {
  TextEditingController nameController = TextEditingController();
  //TODO: Create logic to save images with corresponding data

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save Image"),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          color: Colors.red,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 3),
                content: Text("Image not saved."),
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: imageCapturedNotifier,
        builder: (context, image, child) {
          if (image == null) {
            return Center(
              child: Text(
                "No Image Found!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: Image.file(File(image.path)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    width: double.infinity,
                    child: Card(
                      child: ListTile(
                        leading: Text(
                          "Name:",
                          style: KTextStyle.descriptionStyle,
                        ),
                        title: TextField(
                          decoration: InputDecoration(
                            labelText: "Enter Object Name",
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          controller: nameController,
                          onEditingComplete: () {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                  Material(
                    shape: CircleBorder(),
                    color: Colors.blue,
                    elevation: 4,
                    child: IconButton(
                      icon: Icon(Icons.save),
                      color: Colors.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "Image saved as: ${nameController.text}",
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
