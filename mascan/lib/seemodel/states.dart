import 'package:mascan/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class FoodViewModelState {
  final bool isLoading;
  final String? error;
  final FoodRecipe? foodRecipe;
  const FoodViewModelState({
    this.isLoading = false,
    this.error,
    this.foodRecipe,
  });
  FoodViewModelState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    FoodRecipe? foodRecipe,
  }) {
    return FoodViewModelState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      foodRecipe: foodRecipe,
    );
  }
}

@immutable
class GeminiViewModelState {
  final bool isLoading;
  final String? error;
  final Nutrition? nutrition;
  const GeminiViewModelState({
    this.isLoading = false,
    this.error,
    this.nutrition,
  });
  GeminiViewModelState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    Nutrition? nutrition,
  }) {
    return GeminiViewModelState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      nutrition: nutrition,
    );
  }
}

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
