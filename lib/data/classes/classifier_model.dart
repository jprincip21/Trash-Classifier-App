import 'dart:developer';
import 'dart:io';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:trash_classifier_app/utils/preprocess_image.dart';

//Input Shape = [1, 224, 224, 3]
//Input Type = float32

//Output Shape: [1, 6]
//Output Type: float32

class ClassifierModel {
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
      print(_interpreter.getOutputTensor(0).shape);
      print(_interpreter.getOutputTensor(0).type);
    } catch (e) {
      log("Error while Creating Interpreter: $e");
    }
  }

  void runModel(String imagePath) async {
    File image = File(imagePath);
    List output = List.filled(1 * 6, 0.0).reshape([1, 6]);
    var input = await preProcessImage(image);

    log("Running Model");
    _interpreter.run(input, output);
    print(input);
    print("\n");
    print(output);

    int maxIndex = 0;
    for (int i = 1; i < output[0].length; i++) {
      if (output[0][maxIndex] < output[0][i]) {
        maxIndex = i;
      }
    }
    log("Prediction: ${_labels[maxIndex]}");
    log("Model output: ${output[0]}");
    final List<double> resultList = List<double>.from(output[0]);
    double maxVal = resultList.reduce((a, b) => a > b ? a : b);
    log("Confidence: ${(maxVal * 100).toStringAsFixed(2)}%");
  }
}
