import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'translation_manager.dart';
import 'translation_repository.dart';

final translationRepositoryProvider =
    Provider<TranslationRepository>((ref) {
  return TranslationRepository();
});

final translationManagerProvider =
    Provider<TranslationManager>((ref) {
  final repository = ref.watch(translationRepositoryProvider);

  return TranslationManager(
    repository: repository,
  );
});

// Tracks the current translation data version.
//
// Whenever a new language pack is loaded, this provider can be updated.
// Widgets watching translations will rebuild automatically.
final translationVersionProvider = StateProvider<int>((ref) {
  return 0;
});