import 'translation_repository.dart';

class TranslationManager {
  final TranslationRepository repository;

  const TranslationManager({
    required this.repository,
  });

  String translate({
    required String key,
    required String languageCode,
  }) {
    return repository.getTranslation(
      key: key,
      languageCode: languageCode,
    );
  }

  // Saves a complete language pack received from the backend.
  //
  // The backend connection will be added later.
  void loadLanguagePack({
    required String languageCode,
    required Map<String, String> translations,
  }) {
    repository.saveLanguagePack(
      languageCode: languageCode,
      translations: translations,
    );
  }

  // Checks whether a language pack is already available.
  bool isLanguageLoaded(String languageCode) {
    return repository.hasLanguagePack(languageCode);
  }

  // Removes a language pack from memory if needed.
  void removeLanguagePack(String languageCode) {
    repository.removeLanguagePack(languageCode);
  }
}