import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mascan/services/lite_rt_service.dart';
import 'package:logger/logger.dart';

import 'states/lite_rt_view_model_state.dart';

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
