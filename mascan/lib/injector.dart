import 'package:auto_injector/auto_injector.dart';
import 'package:dio/dio.dart';
import 'package:mascan/init/configs.dart';
import 'package:mascan/services.dart';

final di = AutoInjector();

void initializeDependencies() {
  // Registrasi singleton untuk layanan utama
  di.addSingleton<FirebaseMlService>(() => FirebaseMlService());
  di.addSingleton<Dio>(() => DioConfig.createDio());

  // Registrasi layanan lain yang membutuhkan dependency
  di.add<LiteRtService>(
        () => LiteRtService(di.get<FirebaseMlService>()),
  );

  di.add<ApiService>(() => ApiService(di.get<Dio>()));
  di.add<GeminiService>(() => GeminiService());

  // Komit konfigurasi dependency injector
  di.commit();
}
