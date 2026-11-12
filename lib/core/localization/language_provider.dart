
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../storage/storage_provider.dart';
import 'language_model.dart';
import 'translation_provider.dart';

// Fetch all supported languages from our NestJS backend.
final availableLanguagesProvider =
    FutureProvider<List<Language>>((ref) async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/translation/languages'),
    headers: {
      'Accept': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load languages. Status: ${response.statusCode}',
    );
  }

  final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;

  final languages = data.entries.map((entry) {
    return Language.fromJson(
      entry.key,
      Map<String, dynamic>.from(entry.value as Map),
    );
  }).toList();

  languages.sort(
    (a, b) =>
        a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
  );

  if (languages.isEmpty) {
    throw Exception(
      'No supported languages were returned.',
    );
  }

  return languages;
});

// Manages the selected language and its translations.
class LanguageNotifier extends AsyncNotifier<Language> {
  @override
  Future<Language> build() async {
    final storage = ref.read(localStorageProvider);

    final availableLanguages =
        await ref.watch(
      availableLanguagesProvider.future,
    );

    final savedLanguageCode =
        await storage.getLanguage();

    Language selectedLanguage;

    if (savedLanguageCode == null) {
      selectedLanguage =
          _getEnglishLanguage(availableLanguages);
    } else {
      selectedLanguage =
          availableLanguages.firstWhere(
        (language) =>
            language.code == savedLanguageCode,
        orElse: () =>
            _getEnglishLanguage(availableLanguages),
      );
    }

    // Load translations if a non-English language
    // was previously selected.
    if (selectedLanguage.code != 'en') {
      try {
        await _loadTranslations(
          selectedLanguage.code,
        );

        // Notify all widgets using translate().
        ref
            .read(
              translationVersionProvider.notifier,
            )
            .state++;
      } catch (error) {
        debugPrint(
          'Initial translation loading failed: $error',
        );
      }
    }

    return selectedLanguage;
  }

  // Change the selected language.
  Future<void> setLanguage(
    Language language,
  ) async {
    // Immediately update the selected language.
    state = AsyncData(language);

    final storage =
        ref.read(localStorageProvider);

    await storage.saveLanguage(language.code);

    // English does not need to be loaded from the backend.
    if (language.code == 'en') {
      ref
          .read(
            translationVersionProvider.notifier,
          )
          .state++;

      return;
    }

    try {
      // Load the complete translation pack.
      await _loadTranslations(language.code);

      // Rebuild all widgets using translate().
      ref
          .read(
            translationVersionProvider.notifier,
          )
          .state++;
    } catch (error) {
      debugPrint(
        'Translation loading failed: $error',
      );
    }
  }

  // Load all application translations using TranslationManager.
  Future<void> _loadTranslations(
    String languageCode,
  ) async {
    final translationManager =
        ref.read(translationManagerProvider);

    final translationRepository =
        ref.read(translationRepositoryProvider);

    // Get ALL source text from one central location.
    // This includes the left-side brand text.
    final sourceTexts =
        translationRepository.getSourceTexts();

    await translationManager.loadLanguagePack(
      languageCode: languageCode,
      sourceTexts: sourceTexts,
    );
  }

  // Find English in the list returned by the backend.
  Language _getEnglishLanguage(
    List<Language> languages,
  ) {
    for (final language in languages) {
      if (language.code == 'en') {
        return language;
      }
    }

    return languages.first;
  }
}

// Provides the currently selected language.
final languageProvider =
    AsyncNotifierProvider<LanguageNotifier, Language>(
  LanguageNotifier.new,
);