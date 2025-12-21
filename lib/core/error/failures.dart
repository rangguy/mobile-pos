import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base failure class for error handling
@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
  }) = NetworkFailure;

  const factory Failure.validation({
    required String message,
    List<ValidationError>? errors,
  }) = ValidationFailure;

  const factory Failure.unauthorized({
    required String message,
  }) = UnauthorizedFailure;

  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;

  const factory Failure.unknown({
    required String message,
  }) = UnknownFailure;
}

/// Validation error model
class ValidationError {
  final String field;
  final String message;

  ValidationError({
    required this.field,
    required this.message,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
    );
  }
}
