import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteModel {
  late Interpreter _interpreter;

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
        "assets/trash-classifier-model-v0_1.tflite",
        options: InterpreterOptions()..threads = 6,
      );
      _interpreter.allocateTensors();
    } catch (e) {
      log("Error while Creating Interpreter: $e");
    }

    print(_interpreter.getInputTensor(0).shape);
  }
}
