import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteModel {
  //Model Shape = [1, 224, 224, 3]
  //Model Type = float32
  late Interpreter _interpreter;

  static const String modelPath = "assets/trash-classifier-model-v0_2.tflite";

  final List<String> _labels = [
    "compost",
    "garbage",
    "glass",
    "hazardous-waste",
    "recycling-paper",
    "recycling-plastic",
  ];

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        modelPath,
        options: InterpreterOptions()..threads = 4,
      );
      _interpreter.allocateTensors();
      print(_interpreter.getInputTensor(0).shape);
      print(_interpreter.getInputTensor(0).type);
    } catch (e) {
      log("Error while Creating Interpreter: $e");
    }
  }
}
