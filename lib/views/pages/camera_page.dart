import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    initializeCameras();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> initializeCameras() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras.last, ResolutionPreset.low);
    controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {
            _isCameraReady = true;
          });
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    ///Builds the Camera Page when Called
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: _isCameraReady
            ? CameraPreview(controller)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
