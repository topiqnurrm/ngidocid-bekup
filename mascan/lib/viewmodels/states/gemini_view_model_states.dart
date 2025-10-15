import 'package:mascan/models/nutrition_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
