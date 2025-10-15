import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mascan/services/api_service.dart';
import 'package:logger/logger.dart';

import 'states/food_view_model_state.dart';

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
      Logger().e("Error fetching meal data: $e");
    }
  }
}
