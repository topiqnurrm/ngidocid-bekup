import 'package:dio/dio.dart';

import 'package:envied/envied.dart';

import 'dart:io';


class DioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.mealDbApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return dio;
  }
}

final class _Env {
  static const String geminiApiKey = 'AIzaSyC_G4tYZgNQqZMGdX0zuYwc1ISAghalac8';
  static const String geminiModel = 'gemini-2.0-flash-lite';
  static const String firebaseMlModel = 'mascan-food';
  static const String mealDbApiUrl = 'https://www.themealdb.com/api/json/v1/1/';
}

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

abstract class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, [this.code]);
  @override
  String toString() => message;
}
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}
class TimeoutException extends AppException {
  const TimeoutException(super.message, [super.code]);
}
class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
}
class ParseException extends AppException {
  const ParseException(super.message, [super.code]);
}
class NoInternetException extends AppException {
  const NoInternetException(super.message, [super.code]);
}
class UnknownException extends AppException {
  const UnknownException(super.message, [super.code]);
}

class ExceptionHandler {
  static AppException handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException(
          'Permintaan habis waktu. Silakan coba lagi.',
          'waktu tunggu berakhir',
        );
      case DioExceptionType.badResponse:
        return ServerException(
          'Error pada server (${e.response?.statusCode}): ${e.response?.statusMessage}',
          'Error pada server ${e.response?.statusCode}',
        );
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const NoInternetException(
            'Tidak ada koneksi internet. Silakan periksa jaringan Anda.',
            'TIDAK ADA INTERNET',
          );
        }
        return UnknownException(
          'Terjadi kesalahan yang tidak diketahui: ${e.message}',
          'Tidak diketahui',
        );
      default:
        return UnknownException(
          'Permintaan gagal diproses: ${e.message}',
          'Tidak diketahui',
        );
    }
  }
  static AppException handleGenericException(Exception e) {
    if (e is AppException) {
      return e;
    }
    return UnknownException('Terjadi kesalahan yang tidak terduga: $e', 'Umum');
  }
}

