
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
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

  Future<void> loadLanguagePack({
    required String languageCode,
    required Map<String, String> sourceTexts,
  }) async {
    if (languageCode == 'en') {
      return;
    }

    if (repository.hasLanguagePack(languageCode)) {
      return;
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/translation/batch'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'texts': sourceTexts.values.toList(),
        'targetLanguage': languageCode,
      }),
    );

    // Accept any successful HTTP status (200–299).
    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Batch translation failed: ${response.statusCode}',
      );
    }

    final List<dynamic> responseData =
        jsonDecode(response.body) as List<dynamic>;

    if (responseData.length != sourceTexts.length) {
      throw Exception('Incomplete translation response.');
    }

    final translatedTexts = <String, String>{};
    final keys = sourceTexts.keys.toList();

    for (int i = 0; i < keys.length; i++) {
      final item = responseData[i] as Map<String, dynamic>;

      translatedTexts[keys[i]] =
          item['translatedText'] as String;
    }

    repository.saveLanguagePack(
      languageCode: languageCode,
      translations: translatedTexts,
    );
  }

  bool isLanguageLoaded(String languageCode) {
    return repository.hasLanguagePack(languageCode);
  }

  void removeLanguagePack(String languageCode) {
    repository.removeLanguagePack(languageCode);
  }
}
