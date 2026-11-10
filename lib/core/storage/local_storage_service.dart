import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _languageKey = 'selected_language';

  Future<void> saveLanguage(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _languageKey,
      languageCode,
    );
  }

  Future<String?> getLanguage() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(_languageKey);
  }
}