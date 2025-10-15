import 'package:auto_injector/auto_injector.dart';
import 'package:dio/dio.dart';
import 'package:mascan/core/configs/dio_config.dart';
import 'package:mascan/services/api_service.dart';
import 'package:mascan/services/firebase_ml_service.dart';
import 'package:mascan/services/gemini_service.dart';
import 'package:mascan/services/lite_rt_service.dart';

final injector = AutoInjector();

void setupInjector() {
  injector.addSingleton<FirebaseMlService>(() => FirebaseMlService());
  injector.addSingleton<Dio>(() => DioConfig.createDio());

  injector.add<LiteRtService>(
    () => LiteRtService(injector.get<FirebaseMlService>()),
  );

  injector.add<ApiService>(() => ApiService(injector.get<Dio>()));
  injector.add<GeminiService>(() => GeminiService());

  injector.commit();
}
