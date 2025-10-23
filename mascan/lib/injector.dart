import 'package:auto_injector/auto_injector.dart';
import 'package:dio/dio.dart';
import 'package:mascan/core/configs.dart';
import 'package:mascan/services.dart';

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
