import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/config/app_config.dart';

/// Authentication local data source for token storage
class AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSource(this._secureStorage);

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(
      key: AppConfig.storageKeyToken,
      value: token,
    );
  }

  /// Get authentication token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConfig.storageKeyToken);
  }

  /// Delete authentication token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: AppConfig.storageKeyToken);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
