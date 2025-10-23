import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mascan/core/exceptions/app_exceptions.dart';

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
