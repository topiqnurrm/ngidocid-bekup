import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:mascan/models/food_prediction_model.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateInferenceService {
  static Future<List<FoodPrediction>> runInference({
    required String imagePath,
    required String modelPath,
    required List<String> labels,
  }) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(_inferenceIsolate, {
      'sendPort': receivePort.sendPort,
      'imagePath': imagePath,
      'modelPath': modelPath,
      'labels': labels,
    });

    final result = await receivePort.first;
    receivePort.close();

    if (result is String) {
      throw Exception(result);
    }

    return (result as List)
        .map((json) => FoodPrediction.fromJson(json))
        .toList();
  }

  static void _inferenceIsolate(Map<String, dynamic> params) async {
    final SendPort sendPort = params['sendPort'];
    final String imagePath = params['imagePath'];
    final String modelPath = params['modelPath'];
    final List<String> labels = params['labels'];

    try {
      
      final options = InterpreterOptions()
        ..useNnApiForAndroid = true
        ..useMetalDelegateForIOS = true;

      final interpreter = Interpreter.fromFile(
        File(modelPath),
        options: options,
      );

      
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes)!;

      final resizedImage = img.copyResize(image, width: 224, height: 224);

      final input = _imageToUint8Tensor(resizedImage);

      
      final outputFormat = interpreter.getOutputTensors();
      final outputShape = outputFormat[0].shape;
      final outputSize = outputShape.fold<int>(1, (acc, dim) => acc * dim);
      final output = Uint8List(outputSize);

      interpreter.run(input, output);

      final predictions = _processOutput(output, labels);

      interpreter.close();

      sendPort.send(predictions.map((p) => p.toJson()).toList());
    } catch (e) {
      sendPort.send('Inference error: ${e.toString()}');
      Logger().e("Kesalahan when isolate inference: $e");
    }
  }

  static Uint8List _imageToUint8Tensor(img.Image image) {
    final inputSize = 192;
    final tensor = Uint8List(1 * inputSize * inputSize * 3);
    int pixelIndex = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);

        final r = pixel.r.toInt().clamp(0, 255);
        final g = pixel.g.toInt().clamp(0, 255);
        final b = pixel.b.toInt().clamp(0, 255);

        tensor[pixelIndex] = r;
        tensor[pixelIndex + 1] = g;
        tensor[pixelIndex + 2] = b;
        pixelIndex += 3;
      }
    }

    return tensor;
  }

  static List<FoodPrediction> _processOutput(
    Uint8List output,
    List<String> labels,
  ) {
    List<FoodPrediction> predictions = [];

    for (int i = 0; i < output.length && i < labels.length; i++) {
      final confidence = output[i] / 255.0;

      if (confidence > 0.01) {
        predictions.add(
          FoodPrediction(label: labels[i], confidence: confidence),
        );
      }
    }

    predictions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return predictions.take(3).toList();
  }
}
