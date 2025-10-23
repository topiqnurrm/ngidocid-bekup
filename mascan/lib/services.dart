import 'package:dio/dio.dart';
import 'package:mascan/init/configs.dart';
import 'package:mascan/models.dart';

import 'dart:io';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio);
  Future<FoodRecipe?> searchFood(String query) async {
    try {
      final response = await _dio.get('search.php?s=$query');
      final result = response.data['meals'] as List?;
      if (result == null) return null;
      return result.map((json) => FoodRecipe.fromJson(json)).first;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } on ParseException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e as Exception);
    }
  }
}

class FirebaseMlService {
  File? _cachedModel;
  Future<File> loadModel() async {
    if (_cachedModel != null) {
      return _cachedModel!;
    }
    final instance = FirebaseModelDownloader.instance;
    final model = await instance.getModel(
      Env.firebaseMlModel,
      FirebaseModelDownloadType.localModel,
      FirebaseModelDownloadConditions(
        iosAllowsCellularAccess: true,
        iosAllowsBackgroundDownloading: false,
        androidChargingRequired: false,
        androidWifiRequired: false,
        androidDeviceIdleRequired: false,
      ),
    );
    _cachedModel = model.file;
    return _cachedModel!;
  }
  void clearCache() {
    _cachedModel = null;
  }
}

class GeminiService {
  late final GenerativeModel model;
  GeminiService() {
    final geminiApiKey = Env.geminiApiKey;
    final geminiModel = Env.geminiModel;
    if (geminiApiKey.isEmpty) {
      throw Exception(
        'Gemini API key is not set in the environment variables.',
      );
    }
    model = GenerativeModel(
      model: geminiModel,
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          requiredProperties: ["nutrition"],
          properties: {
            "nutrition": Schema(
              SchemaType.object,
              requiredProperties: [
                "calories",
                "carbs",
                "protein",
                "fat",
                "fiber",
              ],
              properties: {
                "calories": Schema(SchemaType.number),
                "carbs": Schema(SchemaType.number),
                "protein": Schema(SchemaType.number),
                "fat": Schema(SchemaType.number),
                "fiber": Schema(SchemaType.number),
              },
            ),
          },
        ),
      ),
    );
  }
  Future<Nutrition> generateNutrition(String foodLabel) async {
    final prompt = 'Nama makanannya adalah $foodLabel';
    final systemInstruction =
        'Saya adalah suatu mesin yang mampu mengidentifikasi nutrisi atau kandungan gizi pada makanan layaknya uji laboratorium makanan. Hal yang bisa diidentifikasi adalah kalori, karbohidrat, lemak, serat, dan protein pada makanan. Satuan dari indikator tersebut berupa gram.';
    final content = [Content.text(systemInstruction), Content.text(prompt)];
    try {
      final response = await model.generateContent(content);
      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }
      return Nutrition.fromJson(json.decode(response.text!)['nutrition']);
    } catch (e) {
      throw Exception('Failed to parse nutrition data: $e');
    }
  }
}

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

class LiteRtService {
  final FirebaseMlService _firebaseMlService;
  LiteRtService(this._firebaseMlService);
  File? modelFile;
  bool isModelInitialized = false;
  List<String>? labels;
  Future<void> initModel() async {
    if (isModelInitialized) return;
    modelFile = await _firebaseMlService.loadModel();
    await _loadLabels();
    isModelInitialized = true;
  }
  Future<void> _loadLabels() async {
    final labelsString = await rootBundle.loadString('assets/labels.txt');
    labels = labelsString
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }
  Future<List<FoodPrediction>> inferenceFromImage(String imagePath) async {
    if (!isModelInitialized || modelFile == null || labels == null) {
      throw Exception('Model not initialized');
    }
    final predictions = await IsolateInferenceService.runInference(
      imagePath: imagePath,
      modelPath: modelFile!.path,
      labels: labels!,
    );
    final filteredPredictions = predictions
        .where((p) => p.confidence >= 0.15)
        .toList();
    return filteredPredictions;
  }
  void close() {
    isModelInitialized = false;
  }
}


