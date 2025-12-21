import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

/// Custom error logger for Retrofit
class CustomParseErrorLogger extends ParseErrorLogger {
  CustomParseErrorLogger();

  @override
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions options,
  ) {
    // Log error details for debugging
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔴 Retrofit Parse Error');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Error: $error');
    print('StackTrace: $stackTrace');
    print('Request: ${options.method} ${options.uri}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
