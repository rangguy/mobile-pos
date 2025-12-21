import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../config/app_config.dart';

/// Utility class for generating API keys
class ApiKeyGenerator {
  /// Generates API key using SHA256 hash of signatureKey:timestamp
  ///
  /// Returns a tuple of (apiKey, timestamp)
  static (String, String) generate() {
    // Use seconds (10 digits) instead of milliseconds (13 digits)
    final timestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    // Format: signatureKey:timestamp (with colon separator)
    final input = '${AppConfig.signatureKey}:$timestamp';
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    final apiKey = digest.toString();

    return (apiKey, timestamp);
  }
}
