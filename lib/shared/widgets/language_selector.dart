import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/language_model.dart';
import '../../core/localization/language_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const Color primaryColor = Color(0xFF245C48);
  static const Color backgroundColor = Color(0xFFF7F5EF);

  Future<void> _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    List<Language> languages,
  ) async {
    String searchQuery = '';

    final selectedLanguage = await showDialog<Language>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredLanguages = languages.where((language) {
              final query = searchQuery.toLowerCase();

              return language.name.toLowerCase().contains(query) ||
                  language.nativeName.toLowerCase().contains(query) ||
                  language.code.toLowerCase().contains(query);
            }).toList();

            return Dialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 420,
                  height: 520,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose your language',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF183D31),
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Find the language you want to use.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        autofocus: true,
                        onChanged: (value) {
                          setDialogState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search language...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: primaryColor,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Expanded(
                        child: filteredLanguages.isEmpty
                            ? const Center(
                                child: Text(
                                  'No languages found.',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredLanguages.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final language =
                                      filteredLanguages[index];

                                  return ListTile(
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    title: Text(
                                      language.nativeName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${language.name} (${language.code})',
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                    onTap: () {
                                      Navigator.pop(
                                        dialogContext,
                                        language,
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (selectedLanguage != null) {
      await ref
          .read(languageProvider.notifier)
          .setLanguage(selectedLanguage);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageAsync = ref.watch(languageProvider);
    final availableLanguagesAsync =
        ref.watch(availableLanguagesProvider);

    if (languageAsync.isLoading ||
        availableLanguagesAsync.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    if (languageAsync.hasError ||
        availableLanguagesAsync.hasError) {
      return const Text('Unable to load languages');
    }

    final selectedLanguage = languageAsync.value!;
    final supportedLanguages = availableLanguagesAsync.value!;

    return OutlinedButton.icon(
      onPressed: () {
        _showLanguagePicker(
          context,
          ref,
          supportedLanguages,
        );
      },
      icon: const Icon(
        Icons.language,
        color: primaryColor,
      ),
      label: Text(
        selectedLanguage.nativeName,
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Color(0xFFD8DED7),
        ),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}