import 'dart:io';

import 'package:flutter/material.dart';
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
          return Column(children: [Image.file(File(image.path))]);
        }
      },
    );
  }
}
