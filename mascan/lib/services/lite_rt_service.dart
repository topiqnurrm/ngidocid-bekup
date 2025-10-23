import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mascan/models/food_prediction_model.dart';
import 'package:mascan/services/firebase_ml_service.dart';
import 'package:mascan/services/isolate_inference_service.dart';

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
