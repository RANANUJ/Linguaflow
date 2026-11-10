import 'app_strings.dart';
import 'translation_keys.dart';

class TranslationRepository {
  TranslationRepository();

  // Stores translations for languages loaded from the backend.
  final Map<String, Map<String, String>> _languagePacks = {};

  // Returns the translation for a key in the selected language.
  String getTranslation({
    required String key,
    required String languageCode,
  }) {
    // English is always the original source language.
    if (languageCode == 'en') {
      return _englishTranslations[key] ?? key;
    }

    // Look for the selected language pack.
    final languagePack = _languagePacks[languageCode];

    if (languagePack != null && languagePack.containsKey(key)) {
      return languagePack[key]!;
    }

    // If the translation is not available yet, safely fall back to English.
    return _englishTranslations[key] ?? key;
  }

  // Saves a complete language pack received from the backend.
  void saveLanguagePack({
    required String languageCode,
    required Map<String, String> translations,
  }) {
    _languagePacks[languageCode] = translations;
  }

  // Checks whether translations for a language are already available.
  bool hasLanguagePack(String languageCode) {
    return languageCode == 'en' ||
        _languagePacks.containsKey(languageCode);
  }

  // Removes a language pack from memory if needed.
  void removeLanguagePack(String languageCode) {
    _languagePacks.remove(languageCode);
  }

  // Centralized English source text.
  static const Map<String, String> _englishTranslations = {
    TranslationKeys.appName: AppStrings.appName,
    TranslationKeys.welcome: AppStrings.welcome,
    TranslationKeys.login: AppStrings.login,
    TranslationKeys.register: AppStrings.register,
    TranslationKeys.currentLanguage: AppStrings.currentLanguage,
    TranslationKeys.welcomeBack: AppStrings.welcomeBack,
    TranslationKeys.signInToContinue: AppStrings.signInToContinue,
    TranslationKeys.email: AppStrings.email,
    TranslationKeys.password: AppStrings.password,
    TranslationKeys.dontHaveAccount: AppStrings.dontHaveAccount,
    TranslationKeys.enterEmail: AppStrings.enterEmail,
    TranslationKeys.validEmail: AppStrings.validEmail,
    TranslationKeys.enterPassword: AppStrings.enterPassword,

    // Registration screen text.
    TranslationKeys.createAccount: AppStrings.createAccount,
    TranslationKeys.createAccountToGetStarted:
        AppStrings.createAccountToGetStarted,
    TranslationKeys.name: AppStrings.name,
    TranslationKeys.confirmPassword: AppStrings.confirmPassword,
    TranslationKeys.alreadyHaveAccount:
        AppStrings.alreadyHaveAccount,

    // Registration validation messages.
    TranslationKeys.enterName: AppStrings.enterName,
    TranslationKeys.confirmYourPassword:
        AppStrings.confirmYourPassword,
    TranslationKeys.passwordsDoNotMatch:
        AppStrings.passwordsDoNotMatch,
  };
}