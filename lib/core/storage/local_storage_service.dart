
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static const String _languageKey = 'selected_language';
  static const String _tokenKey = 'access_token';

  // Secure storage for authentication tokens.
  static const FlutterSecureStorage _secureStorage =
      FlutterSecureStorage();

  // Save selected language.
  Future<void> saveLanguage(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _languageKey,
      languageCode,
    );
  }

  // Get selected language.
  Future<String?> getLanguage() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(_languageKey);
  }

  // Save JWT access token securely.
  Future<void> saveToken(String token) async {
    await _secureStorage.write(
      key: _tokenKey,
      value: token,
    );
  }

  // Get saved JWT access token.
  Future<String?> getToken() async {
    return await _secureStorage.read(
      key: _tokenKey,
    );
  }

  // Delete JWT access token during logout.
  Future<void> deleteToken() async {
    await _secureStorage.delete(
      key: _tokenKey,
    );
  }
}
