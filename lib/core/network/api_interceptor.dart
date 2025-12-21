import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../utils/api_key_generator.dart';

/// Interceptor for adding API key and authorization headers
class ApiInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  ApiInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Generate API key and timestamp
    final (apiKey, timestamp) = ApiKeyGenerator.generate();

    // Add API key headers
    options.headers[AppConfig.headerApiKey] = apiKey;
    options.headers[AppConfig.headerRequestAt] = timestamp;

    // Add authorization token if available
    final token = await _secureStorage.read(key: AppConfig.storageKeyToken);
    if (token != null && token.isNotEmpty) {
      options.headers[AppConfig.headerAuthorization] = 'Bearer $token';
    }

    // Debug logging - Print all headers being sent
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 REQUEST: ${options.method} ${options.uri}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📋 HEADERS SENT FROM FLUTTER:');
    options.headers.forEach((key, value) {
      final valueStr = value.toString();
      if (key.toLowerCase() == 'authorization' && valueStr.length > 30) {
        print('  $key: ${valueStr.substring(0, 30)}...');
      } else {
        print('  $key: $valueStr');
      }
    });
    if (token == null || token.isEmpty) {
      print('  ⚠️ WARNING: No Authorization token found!');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // You can add custom error handling here if needed
    super.onError(err, handler);
  }
}
