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
          'Request timed out. Please try again.',
          'TIMEOUT',
        );

      case DioExceptionType.badResponse:
        return ServerException(
          'Server error (${e.response?.statusCode}): ${e.response?.statusMessage}',
          'SERVER_ERROR_${e.response?.statusCode}',
        );

      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const NoInternetException(
            'No internet connection. Please check your network.',
            'NO_INTERNET',
          );
        }
        return UnknownException(
          'Unknown error occurred: ${e.message}',
          'UNKNOWN',
        );

      default:
        return UnknownException(
          'Failed to process request: ${e.message}',
          'UNKNOWN',
        );
    }
  }

  static AppException handleGenericException(Exception e) {
    if (e is AppException) {
      return e;
    }

    return UnknownException('An unexpected error occurred: $e', 'GENERIC');
  }
}
