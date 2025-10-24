import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mascan/services.dart';
import 'package:logger/logger.dart';

import 'states.dart';

import 'package:mascan/injector.dart';

class FoodViewModel extends StateNotifier<FoodViewModelState> {
  final ApiService _apiService;
  FoodViewModel(this._apiService) : super(const FoodViewModelState());
  Future<void> searchFood(String foodLabel) async {
    if (state.isLoading || foodLabel.isEmpty) return;
    state = state.copyWith(isLoading: true, clearError: true, foodRecipe: null);
    try {
      final food = await _apiService.searchFood(foodLabel);
      state = state.copyWith(foodRecipe: food, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        foodRecipe: null,
      );
      Logger().e("Kesalahan fetching meal data: $e");
    }
  }
}

class GeminiViewModel extends StateNotifier<GeminiViewModelState> {
  final GeminiService _geminiService;
  GeminiViewModel(this._geminiService) : super(const GeminiViewModelState());
  Future<void> generateResponse(String foodLabel) async {
    try {
      if (state.isLoading || foodLabel.isEmpty) return;
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        nutrition: null,
      );
      final nutrition = await _geminiService.generateNutrition(foodLabel);
      state = state.copyWith(nutrition: nutrition, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        nutrition: null,
      );
      throw Exception("Failed to generate response: ${e.toString()}");
    }
  }
}

class LiteRtViewModel extends StateNotifier<LiteRtViewModelState> {
  final LiteRtService _liteRtService;
  LiteRtViewModel(this._liteRtService) : super(const LiteRtViewModelState()) {
    _initializeModelOnCreation();
  }
  Future<void> _initializeModelOnCreation() async {
    await initializeModel();
  }
  Future<void> initializeModel() async {
    if (_liteRtService.isModelInitialized || state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _liteRtService.initModel();
      state = state.copyWith(isModelInitialized: true, isLoading: false);
    } catch (e) {
      final errorMsg = "Failed to initialize model: ${e.toString()}";
      state = state.copyWith(error: errorMsg, isLoading: false);
      Logger().e("Kesalahan initializing model: $errorMsg");
    }
  }
  Future<void> runImageInference(String imagePath) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearFoods: true,
      currentImagePath: imagePath,
    );
    try {
      if (!_liteRtService.isModelInitialized) {
        await _liteRtService.initModel();
        state = state.copyWith(isModelInitialized: true);
      }
      state = state.copyWith(isLoading: true, clearError: true);
      final foods = await _liteRtService.inferenceFromImage(imagePath);
      state = state.copyWith(foods: foods, isLoading: false);
      if (foods.isNotEmpty) {
        final topPred = foods.first;
        if (topPred.confidence < 0.15) {
          foods.clear();
          state = state.copyWith(foods: foods);
          return;
        }
      }
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(error: errorMsg, isLoading: false);
      Logger().e("Kesalahan during inference: $errorMsg");
    }
  }
}

final firebaseMlServiceProvider = Provider<FirebaseMlService>((ref) {
  return di.get<FirebaseMlService>();
});
final liteRtServiceProvider = Provider<LiteRtService>((ref) {
  return di.get<LiteRtService>();
});
final apiServiceProvider = Provider<ApiService>((ref) {
  return di.get<ApiService>();
});
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return di.get<GeminiService>();
});
final liteRtViewModelProvider =
StateNotifierProvider<LiteRtViewModel, LiteRtViewModelState>((ref) {
  final liteRtService = ref.read(liteRtServiceProvider);
  return LiteRtViewModel(liteRtService);
});
final foodViewModelProvider =
StateNotifierProvider<FoodViewModel, FoodViewModelState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return FoodViewModel(apiService);
});
final geminiViewModelProvider =
StateNotifierProvider<GeminiViewModel, GeminiViewModelState>((ref) {
  final geminiService = ref.read(geminiServiceProvider);
  return GeminiViewModel(geminiService);
});
