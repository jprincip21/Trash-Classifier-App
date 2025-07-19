import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  late CameraDescription _backCamera;
  late CameraDescription _frontCamera;

  bool _isCameraReady = false;
  bool _isBackCamera = true;
  int _flashSetting = 0;

  final List<IconData> _flashIcons = [
    Icons.flash_off,
    Icons.flash_on,
    Icons.flash_auto,
  ];

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCameras() async {
    _cameras = await availableCameras();

    _backCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras.first, // fallback if no back camera found
    );

    _frontCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.last, // fallback if no front camera found
    );

    _controller = CameraController(_backCamera, ResolutionPreset.max);
    _controller
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

  void flipCamera() async {
    setState(() {
      _isCameraReady = false;
    });
    await _controller.dispose();

    _controller = _isBackCamera
        ? CameraController(
            _frontCamera,
            ResolutionPreset.max,
          ) //If Were on the back camera create a controller for the front camera
        : CameraController(
            _backCamera,
            ResolutionPreset.max,
          ); //If Were on the front camera create a controller for the back camera

    _isBackCamera = !_isBackCamera;

    _controller
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

  //test
  void _changeFlash() {
    _flashSetting = (_flashSetting + 1) % 3;
    if (_flashSetting == 0) {
      log("Flash Mode: Off");
      _controller.setFlashMode(FlashMode.off);
    } else if (_flashSetting == 1) {
      log("Flash Mode: On");
      _controller.setFlashMode(FlashMode.always);
    } else {
      log("Flash Mode: Auto");
      _controller.setFlashMode(FlashMode.auto);
    }
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
          IconButton(
            onPressed: () {
              log("Flash Button Pressed");
              setState(() {
                _changeFlash();
              });
            },
            icon: Icon(_flashIcons[_flashSetting], color: Colors.white),
          ),

          IconButton(
            onPressed: () {
              flipCamera();
              setState(() {});
              log("Camera Flip Pressed");
            },
            icon: Icon(Icons.flip_camera_ios_outlined, color: Colors.white),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: _isCameraReady
          ? SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(child: CameraPreview(_controller)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          log("Capture Button Pressed");
                          //TODO: Take Picture Logic
                          _controller.takePicture();
                        },
                        child: Icon(
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
