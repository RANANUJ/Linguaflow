import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/language_model.dart';
import '../../core/localization/language_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageAsync = ref.watch(languageProvider);

    return languageAsync.when(
      loading: () => const CircularProgressIndicator(),

      error: (error, stackTrace) => const SizedBox(),

      data: (selectedLanguage) {
        return DropdownButton<Language>(
          value: selectedLanguage,
          items: supportedLanguages.map((language) {
            return DropdownMenuItem<Language>(
              value: language,
              child: Text(language.nativeName),
            );
          }).toList(),

          onChanged: (Language? newLanguage) {
            if (newLanguage != null) {
              ref
                  .read(languageProvider.notifier)
                  .setLanguage(newLanguage);
            }
          },
        );
      },
    );
  }
}