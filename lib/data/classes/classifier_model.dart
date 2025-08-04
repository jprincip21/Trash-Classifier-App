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

  void runModel(File imagePath) async {
    List output = List.filled(1 * 6, 0.0).reshape([1, 6]);
    List<double> input = await preProcessImage(imagePath);
    _interpreter.run(input, output);

    //Process the output either in another function or within the runmodel function
  }
}
