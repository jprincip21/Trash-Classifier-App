import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trash_classifier_app/data/constants.dart';
import 'package:trash_classifier_app/data/notifiers.dart';
import 'package:trash_classifier_app/views/pages/save_image_page.dart';

class HomePage extends StatelessWidget {
  ///Builds the HomePage when called
  const HomePage({super.key});

  void _deleteImage() {
    if (imageCapturedNotifier.value != null) {
      imageCapturedNotifier.value = null;
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
          return Column(
            children: [
              SizedBox(
                height: 500,
                width: double.infinity,
                child: Image.file(File(image.path)),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                width: double.infinity,
                child: Card(
                  child: ListTile(
                    leading: Text("Type: ", style: KTextStyle.descriptionStyle),
                    title: Text("Loading..."),
                    trailing: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(),
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
                      color: Colors.green,
                      elevation: 4,
                      child: IconButton(
                        icon: Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SaveImagePage();
                              },
                            ),
                          );
                        },
                        tooltip: "Save",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
