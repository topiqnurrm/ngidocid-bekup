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
