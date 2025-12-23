/// Application configuration
///
/// This file contains all configurable values for the application.
/// You can easily change the base URL here for different environments.
class AppConfig {
  // API Configuration
  // Change this based on your testing environment:
  // - For physical device: Use your computer's local IP (e.g., 'http://192.168.1.100:8085/api/v1')
  // - For Android emulator: Use 'http://10.0.2.2:8085/api/v1'
  // - For iOS simulator: Use 'http://localhost:8085/api/v1'
  // - For production: Use your production API URL
  static const String baseUrl = 'http://192.168.0.9:8085/api/v1';

  // API Security
  static const String signatureKey = 'nauUBioyuwbSdqwyhfd';

  // API Headers
  static const String headerApiKey = 'x-api-key';
  static const String headerRequestAt = 'x-request-at';
  static const String headerServiceName = 'x-service-name';
  static const String headerAuthorization = 'Authorization';

  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUser = 'user_data';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 10;
}
