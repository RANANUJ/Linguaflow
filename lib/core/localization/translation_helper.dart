import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'language_provider.dart';
import 'translation_provider.dart';

String translate(WidgetRef ref, String key) {
  // Watch the translation version so the UI rebuilds when
  // a new language pack is loaded.
  ref.watch(translationVersionProvider);

  // Watch the currently selected language.
  final languageAsync = ref.watch(languageProvider);

  final languageCode = languageAsync.when(
    data: (language) => language.code,
    loading: () => 'en',
    error: (error, stackTrace) => 'en',
  );

  final translationManager = ref.watch(
    translationManagerProvider,
  );

  return translationManager.translate(
    key: key,
    languageCode: languageCode,
  );
}