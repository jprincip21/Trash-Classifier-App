import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<List<List<List<List<double>>>>> preProcessImage(File imagePath) async {
  log("PreProcessing Image");

  final int imageSize = 224;
  final Uint8List imageBytes = await imagePath.readAsBytes();

  img.Image? image = img.decodeImage(imageBytes);
  if (image == null) throw Exception("Could not decode image");

  img.Image resizedImage = img.copyResize(
    image,
    width: imageSize,
    height: imageSize,
  );

  List<List<List<double>>> imageAsFloatList = List.generate(
    imageSize,
    (index) => List.generate(imageSize, (index) => List.filled(3, 0.0)),
  );

  for (int y = 0; y < imageSize; y++) {
    for (int x = 0; x < imageSize; x++) {
      img.Pixel pixel = resizedImage.getPixel(x, y);

      // Normalize RGB values from 0-255 to 0-1
      double r = pixel.r.toDouble();
      double g = pixel.g.toDouble();
      double b = pixel.b.toDouble();

      imageAsFloatList[y][x][0] = r;
      imageAsFloatList[y][x][1] = g;
      imageAsFloatList[y][x][2] = b;
    }
  }
  return [
    imageAsFloatList,
  ]; //Put imageAsFloatList in a 1D list because expected shape is [1, 224, 224, 3]

  // 1: the number of images being sent at once.
  // 224: The row of the image (matrix)
  // 224: The column of the image (matrix)
  // 3: color chanels each pixel

  //When we specify an index such as [10, 180, 1], we are on the 11th row, 181st column, and looking at the green colour channel

  // the bottom most portion of the list (3) will be the colour values of the pixel where each number specifies the either the red green or blue values for that pixel.
  // The second bottom most portion of the list (224) is the column (width of the image) we are looking at. For each column there is 224 pixels so well have 224 items of size 3.
  // the highest portion of the list is the row (height of the image). For each column we will have 1 row of 224 pixels.
}
