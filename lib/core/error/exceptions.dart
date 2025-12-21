/// Base exception class
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Server exception (5xx errors)
class ServerException extends AppException {
  ServerException(super.message, [super.statusCode]);
}

/// Network exception (connection issues)
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Validation exception (422 errors)
class ValidationException extends AppException {
  final List<Map<String, dynamic>>? errors;

  ValidationException(super.message, [this.errors, super.statusCode]);
}

/// Unauthorized exception (401 errors)
class UnauthorizedException extends AppException {
  UnauthorizedException(super.message, [super.statusCode]);
}

/// Not found exception (404 errors)
class NotFoundException extends AppException {
  NotFoundException(super.message, [super.statusCode]);
}
