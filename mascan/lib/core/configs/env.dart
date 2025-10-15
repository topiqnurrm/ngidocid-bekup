import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY')
  static const String geminiApiKey = _Env.geminiApiKey;

  @EnviedField(varName: 'GEMINI_MODEL')
  static const String geminiModel = _Env.geminiModel;

  @EnviedField(varName: 'FIREBASE_ML_MODEL')
  static const String firebaseMlModel = _Env.firebaseMlModel;

  @EnviedField(varName: 'MEALDB_API_URL')
  static const String mealDbApiUrl = _Env.mealDbApiUrl;
}
