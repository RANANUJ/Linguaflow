
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/translation_helper.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/widgets/language_selector.dart';
import '../providers/stories_provider.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the currently selected language.
    final languageAsync = ref.watch(languageProvider);

    final languageCode = languageAsync.when(
      data: (language) => language.code,
      loading: () => 'en',
      error: (_, __) => 'en',
    );

    // Get stories translated into the selected language.
    final storiesAsync = ref.watch(
      translatedStoriesProvider(languageCode),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EF),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF245C48),
          onRefresh: () async {
            // Refresh original stories and translated stories.
            ref.invalidate(storiesProvider);
            ref.invalidate(
              translatedStoriesProvider(languageCode),
            );

            await ref.read(
              translatedStoriesProvider(languageCode).future,
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 34),

                    Text(
                      translate(
                        ref,
                        TranslationKeys.exploreStories,
                      ),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF243A30),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      translate(
                        ref,
                        TranslationKeys.exploreDescription,
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.55,
                        color: Color(0xFF777C73),
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      decoration: InputDecoration(
                        hintText: translate(
                          ref,
                          TranslationKeys.searchStories,
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFF9A9D96),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF245C48),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E5DD),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E5DD),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF245C48),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      translate(
                        ref,
                        TranslationKeys.discoverStories,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF243A30),
                      ),
                    ),

                    const SizedBox(height: 14),

                    storiesAsync.when(
                      loading: () {
                        return const Padding(
                          padding: EdgeInsets.all(35),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF245C48),
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return _buildError(
                          ref: ref,
                          error: error.toString(),
                          languageCode: languageCode,
                        );
                      },
                      data: (stories) {
                        if (stories.isEmpty) {
                          return _buildEmptyState(ref);
                        }

                        return Column(
                          children: stories.map((story) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 14,
                              ),
                              child: _buildStoryCard(
                                ref: ref,
                                story: story,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF245C48),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.translate_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'LinguaFlow',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF245C48),
            ),
          ),
        ),
        const LanguageSelector(),
      ],
    );
  }

  Widget _buildStoryCard({
    required WidgetRef ref,
    required Map<String, dynamic> story,
  }) {
    final title = story['title']?.toString() ?? 'Untitled Story';
    final content = story['content']?.toString() ?? '';
    final language = story['language']?.toString() ?? 'Unknown';
    final userId = story['userId']?.toString() ?? '';

    final initial =
        title.isNotEmpty ? title[0].toUpperCase() : 'S';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Story detail screen can be added later.
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE6E5DD),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFEAF0EC),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Color(0xFF245C48),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LinguaFlow Community',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF243A30),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$language • ${translate(ref, TranslationKeys.story)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF777C73),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Color(0xFF777C73),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF243A30),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF777C73),
                ),
              ),
              const SizedBox(height: 10),
              if (userId.isNotEmpty)
                Text(
                  'Story ID: ${userId.substring(0, userId.length > 8 ? 8 : userId.length)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9A9D96),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6E5DD),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.menu_book_rounded,
            size: 42,
            color: Color(0xFF245C48),
          ),
          const SizedBox(height: 12),
          Text(
            translate(ref, TranslationKeys.noStoriesYet),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF243A30),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            translate(ref, TranslationKeys.startWriting),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF777C73),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError({
    required WidgetRef ref,
    required String error,
    required String languageCode,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6E5DD),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 36,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 10),
          const Text(
            'Could not load stories',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF243A30),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777C73),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(storiesProvider);
              ref.invalidate(
                translatedStoriesProvider(languageCode),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF245C48),
              foregroundColor: Colors.white,
            ),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
