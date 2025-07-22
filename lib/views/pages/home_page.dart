import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trash_classifier_app/data/constants.dart';
import 'package:trash_classifier_app/data/notifiers.dart';

TextEditingController _nameController = TextEditingController();

class HomePage extends StatefulWidget {
  ///Builds the HomePage when called
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  void _deleteImage() {
    if (imageCapturedNotifier.value != null) {
      imageCapturedNotifier.value = null;
      _nameController.text = "";
      log("Image Deleted");
    }
  }

  @override
  Widget build(BuildContext context) {
    // If an image has not been taken we display a default page that will direct the use to take or pick an image
    // If an image has been taken we will display the image on the page.
    // We do this by listening to a notifier which will update the state of the screen.

    //TODO: Update Page that displays if had not taken a picture yet.

    return ValueListenableBuilder(
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
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                        controller: _nameController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        shape: CircleBorder(),
                        color: Colors.red,
                        elevation: 4,

                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: () {
                            _deleteImage();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Image Deleted Successfully"),
                              ),
                            );
                          },
                          tooltip: "Delete",
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
                                  "Image saved as: ${_nameController.text}",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
