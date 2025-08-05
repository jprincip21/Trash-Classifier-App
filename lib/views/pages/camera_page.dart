import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trash_classifier_app/data/notifiers.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

//TODO: Allow users to pull images from their camera roll instead of having to take a new picture

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  late CameraDescription _backCamera;
  late CameraDescription _frontCamera;

  final _picker = ImagePicker();

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

  Future<void> pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      imageCapturedNotifier.value = pickedImage;
      setState(() {});
      Navigator.pop(context);
    }
  }

  Future<void> _initializeCameras() async {
    // We get the list of available cameras, then back and front cameras by checking lens direction. If no camera is found for either we default to where the camera normally is.
    // By default we use the back camera, then initialze the camera and update the isCameraReady Variable.
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
    // Update the isCameraReady Variable to false and dispose of the controller
    // Then we check if the user was using the back or front camera and set the controller to the opposite camera
    // Then update the variable
    setState(() {
      _isCameraReady = false;
    });
    await _controller.dispose();

    _controller = _isBackCamera
        ? CameraController(
            _frontCamera,
            ResolutionPreset.max,
          ) //If on the back camera create a controller for the front camera
        : CameraController(
            _backCamera,
            ResolutionPreset.max,
          ); //If on the front camera create a controller for the back camera

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

  void _changeFlash() {
    // Update the flash setting variable when called and log the information
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
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            log("Camera Page Close");
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
            icon: Icon(_flashIcons[_flashSetting]),
          ),

          IconButton(
            onPressed: () {
              flipCamera();
              setState(() {});
              log("Camera Flip Pressed");
            },
            icon: Icon(Icons.flip_camera_ios_outlined),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),

      //If the camera is ready we will display the camera preview, otherwise we will display a loading icon.
      body: _isCameraReady
          ? SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CameraPreview(_controller),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: () async {
                              pickImage();
                            },
                            icon: Icon(Icons.photo_outlined, size: 40),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () async {
                                XFile image = await _controller.takePicture();
                                if (!mounted) return;
                                log("Capture Button Pressed");
                                log('Picture saved at: ${image.path}');
                                imageCapturedNotifier.value = image;
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.circle_outlined,
                                size: 100.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
