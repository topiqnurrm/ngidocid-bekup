import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mascan/injector.dart';
import 'package:mascan/services/api_service.dart';
import 'package:mascan/services/firebase_ml_service.dart';
import 'package:mascan/services/gemini_service.dart';
import 'package:mascan/services/lite_rt_service.dart';
import 'package:mascan/viewmodels/gemini_view_model.dart';
import 'package:mascan/viewmodels/lite_rt_view_model.dart';
import 'package:mascan/viewmodels/states/gemini_view_model_states.dart';

import 'food_view_model.dart';
import 'states/food_view_model_state.dart';
import 'states/lite_rt_view_model_state.dart';

final firebaseMlServiceProvider = Provider<FirebaseMlService>((ref) {
  return injector.get<FirebaseMlService>();
});

final liteRtServiceProvider = Provider<LiteRtService>((ref) {
  return injector.get<LiteRtService>();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return injector.get<ApiService>();
});

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return injector.get<GeminiService>();
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
