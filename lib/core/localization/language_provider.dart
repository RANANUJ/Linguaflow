import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage_provider.dart';
import 'language_model.dart';

// Temporary built-in languages.
//
// These allow the app to work before the backend language API is connected.
// Later, the backend will provide the complete list of supported languages.
const List<Language> defaultLanguages = [
  Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
  ),
  Language(
    code: 'hi',
    name: 'Hindi',
    nativeName: 'हिन्दी',
  ),
  Language(
    code: 'fr',
    name: 'French',
    nativeName: 'Français',
  ),
];

// Provides the currently available languages.
//
// For now, this uses the built-in development list.
// Later, this provider will receive the language list from the backend.
final availableLanguagesProvider = Provider<List<Language>>((ref) {
  return defaultLanguages;
});

class LanguageNotifier extends AsyncNotifier<Language> {
  @override
  Future<Language> build() async {
    final storage = ref.read(localStorageProvider);
    final availableLanguages = ref.read(availableLanguagesProvider);

    // Get the saved language code from the device.
    final savedLanguageCode = await storage.getLanguage();

    // If no language was previously saved, use English.
    if (savedLanguageCode == null) {
      return _getEnglishLanguage(availableLanguages);
    }

    // Find the saved language in the available languages.
    for (final language in availableLanguages) {
      if (language.code == savedLanguageCode) {
        return language;
      }
    }

    // Fall back to English if the saved language is unavailable.
    return _getEnglishLanguage(availableLanguages);
  }

  Future<void> setLanguage(Language language) async {
    // Update the selected language immediately.
    state = AsyncData(language);

    // Save the selected language on the device.
    final storage = ref.read(localStorageProvider);
    await storage.saveLanguage(language.code);
  }

  Language _getEnglishLanguage(List<Language> languages) {
    for (final language in languages) {
      if (language.code == 'en') {
        return language;
      }
    }

    // English should always exist in the supported language list.
    return languages.first;
  }
}

final languageProvider =
    AsyncNotifierProvider<LanguageNotifier, Language>(
  LanguageNotifier.new,
);