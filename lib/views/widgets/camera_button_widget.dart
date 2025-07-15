import 'package:flutter/material.dart';
import 'package:trash_classifier_app/views/pages/camera_page.dart';

class CamerabuttonWidget extends StatelessWidget {
  const CamerabuttonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// Builds the camera button when called
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CameraPage();
            },
          ),
        );
      },
      child: const Icon(Icons.camera_alt_outlined),
    );
  }
}
