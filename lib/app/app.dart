import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguaflow/features/auth/presentation/login_screen.dart';

import '../core/localization/language_provider.dart';
import '../core/localization/translation_keys.dart';
import '../core/localization/translation_provider.dart';

class LinguaFlowApp extends ConsumerWidget {
  const LinguaFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the language while it is loading from local storage.
    final languageAsync = ref.watch(languageProvider);

    return languageAsync.when(
      // Show a loading screen while the saved language is loading.
      loading: () {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },

      // Show an error screen if the language cannot be loaded.
      error: (error, stackTrace) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Text(
                'Error loading language: $error',
              ),
            ),
          ),
        );
      },

      // Build the main application after the language is ready.
      data: (selectedLanguage) {
        final translationManager =
            ref.watch(translationManagerProvider);

        return MaterialApp(
          title: translationManager.translate(
            key: TranslationKeys.appName,
            languageCode: selectedLanguage.code,
          ),
          debugShowCheckedModeBanner: false,

          // The Login Screen is now the first screen of the application.
          home: const LoginScreen(),
        );
      },
    );
  }
}