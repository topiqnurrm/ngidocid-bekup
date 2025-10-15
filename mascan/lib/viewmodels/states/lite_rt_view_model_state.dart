import 'package:mascan/models/food_prediction_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class LiteRtViewModelState {
  final List<FoodPrediction>? foods;
  final bool isLoading;
  final bool isModelInitialized;
  final String? error;
  final String? currentImagePath;

  const LiteRtViewModelState({
    this.foods,
    this.isLoading = false,
    this.isModelInitialized = false,
    this.error,
    this.currentImagePath,
  });

  LiteRtViewModelState copyWith({
    List<FoodPrediction>? foods,
    bool isLoading = false,
    bool? isModelInitialized,
    String? error,
    String? currentImagePath,
    bool clearFoods = false,
    bool clearError = false,
  }) {
    return LiteRtViewModelState(
      foods: clearFoods ? null : foods ?? this.foods,
      isLoading: isLoading,
      isModelInitialized: isModelInitialized ?? this.isModelInitialized,
      error: clearError ? null : error ?? this.error,
      currentImagePath: currentImagePath,
    );
  }
}
