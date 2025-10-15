import 'package:mascan/models/food_recipe_model.dart';
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
