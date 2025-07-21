import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trash_classifier_app/data/constants.dart';
import 'package:trash_classifier_app/data/notifiers.dart';

class HomePage extends StatelessWidget {
  ///Builds the HomePage when called
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // If an image has not been taken we display a default page that will direct the use to take or pick an image
    // If an image has been taken we will display the image on the page.
    // We do this by listening to a notifier which will update the state of the screen.

    //TODO: Update Page that displays if had not taken a picture yet.
    //TODO: Update page that displays after user has taken a picture.

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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
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
              Padding(
                padding: EdgeInsetsGeometry.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Ink(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.red,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
                        tooltip: "Delete",
                      ),
                    ),
                    Ink(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.green,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {},
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
