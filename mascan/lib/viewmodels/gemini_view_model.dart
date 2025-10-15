import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mascan/viewmodels/states/gemini_view_model_states.dart';

import '../services/gemini_service.dart';

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
