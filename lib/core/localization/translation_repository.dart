
import 'app_strings.dart';
import 'translation_keys.dart';

class TranslationRepository {
  TranslationRepository();

  // Stores translated language packs received from the backend.
  final Map<String, Map<String, String>> _languagePacks = {};

  // Returns the translation for a key in the selected language.
  String getTranslation({
    required String key,
    required String languageCode,
  }) {
    // English is the application's original language.
    if (languageCode == 'en') {
      return _englishTranslations[key] ?? key;
    }

    // Get the translation pack for the selected language.
    final languagePack = _languagePacks[languageCode];

    // Return the translated text if it is available.
    if (languagePack != null && languagePack.containsKey(key)) {
      return languagePack[key]!;
    }

    // Safely fall back to the original English text.
    return _englishTranslations[key] ?? key;
  }

  // Returns all English source texts.
  //
  // TranslationManager uses this complete map when sending texts
  // to the backend for translation.
  Map<String, String> getSourceTexts() {
    return Map<String, String>.from(_englishTranslations);
  }

  // Saves a complete language pack received from the backend.
  void saveLanguagePack({
    required String languageCode,
    required Map<String, String> translations,
  }) {
    _languagePacks[languageCode] = translations;
  }

  // Checks whether a language pack has already been loaded.
  bool hasLanguagePack(String languageCode) {
    return languageCode == 'en' ||
        _languagePacks.containsKey(languageCode);
  }

  // Removes a language pack from memory.
  void removeLanguagePack(String languageCode) {
    _languagePacks.remove(languageCode);
  }

  // All original English text used by the application.
  //
  // IMPORTANT:
  // Every piece of text that should be translated must be included here.
  static const Map<String, String> _englishTranslations = {
    // General application text.
    TranslationKeys.appName: AppStrings.appName,
    TranslationKeys.welcome: AppStrings.welcome,
    TranslationKeys.login: AppStrings.login,
    TranslationKeys.register: AppStrings.register,
    TranslationKeys.currentLanguage: AppStrings.currentLanguage,

    // Login screen.
    TranslationKeys.welcomeBack: AppStrings.welcomeBack,
    TranslationKeys.signInToContinue:
        AppStrings.signInToContinue,
    TranslationKeys.email: AppStrings.email,
    TranslationKeys.password: AppStrings.password,
    TranslationKeys.dontHaveAccount:
        AppStrings.dontHaveAccount,

    // Login validation messages.
    TranslationKeys.enterEmail: AppStrings.enterEmail,
    TranslationKeys.validEmail: AppStrings.validEmail,
    TranslationKeys.enterPassword:
        AppStrings.enterPassword,

    // Login left-side brand section.
    TranslationKeys.loginBrandTitle:
        AppStrings.loginBrandTitle,
    TranslationKeys.loginBrandDescription:
        AppStrings.loginBrandDescription,

    // Registration screen.
    TranslationKeys.createAccount:
        AppStrings.createAccount,
    TranslationKeys.createAccountToGetStarted:
        AppStrings.createAccountToGetStarted,
    TranslationKeys.name: AppStrings.name,
    TranslationKeys.confirmPassword:
        AppStrings.confirmPassword,
    TranslationKeys.alreadyHaveAccount:
        AppStrings.alreadyHaveAccount,

    // Registration left-side brand section.
    TranslationKeys.registerBrandTitle:
        AppStrings.registerBrandTitle,
    TranslationKeys.registerBrandSubtitle:
        AppStrings.registerBrandSubtitle,

    // Registration validation messages.
    TranslationKeys.enterName: AppStrings.enterName,
    TranslationKeys.confirmYourPassword:
        AppStrings.confirmYourPassword,
    TranslationKeys.passwordsDoNotMatch:
        AppStrings.passwordsDoNotMatch,
  };
}