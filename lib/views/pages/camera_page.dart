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
    controller = CameraController(_cameras.last, ResolutionPreset.max);
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.flash_on)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.flip_camera_ios_outlined),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: _isCameraReady
          ? SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(child: CameraPreview(controller)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.circle_outlined,
                          size: 100.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
