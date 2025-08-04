import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

Future<List<double>> preProcessImage(File imagePath) async {
  final int imageSize = 224;
  final Uint8List imageBytes = await imagePath.readAsBytes();
  List<double> imageAsFloatList = [];

  img.Image? image = img.decodeImage(imageBytes);
  if (image == null) throw Exception("Could not decode image");

  img.Image resizedImage = img.copyResize(
    image,
    width: imageSize,
    height: imageSize,
  );

  for (int y = 0; y < imageSize; y++) {
    for (int x = 0; x < imageSize; x++) {
      img.Pixel pixel = resizedImage.getPixel(x, y);

      // Extract and normalize RGB values
      double r = pixel.r / 255.0;
      double g = pixel.g / 255.0;
      double b = pixel.b / 255.0;

      imageAsFloatList.addAll([r, g, b]);
    }
  }
  imageAsFloatList.reshape([1, 224, 224, 3]);
  return imageAsFloatList;
}
