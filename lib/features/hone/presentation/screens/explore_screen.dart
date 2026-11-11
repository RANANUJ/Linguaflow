import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/translation_helper.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/widgets/language_selector.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EF),
      body: SafeArea(
        child: SingleChildScrollView(
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

                  _buildStoryCard(
                    ref: ref,
                    author: 'Maria',
                    language: 'Spanish',
                    title: 'A journey through Barcelona',
                    description:
                        'The streets of Barcelona are full of colors, history and unforgettable experiences.',
                    initial: 'M',
                  ),

                  const SizedBox(height: 14),

                  _buildStoryCard(
                    ref: ref,
                    author: 'Kenji',
                    language: 'Japanese',
                    title: 'My first day in Tokyo',
                    description:
                        'A new city, new people and a completely different world waiting to be explored.',
                    initial: 'K',
                  ),

                  const SizedBox(height: 14),

                  _buildStoryCard(
                    ref: ref,
                    author: 'Aman',
                    language: 'Punjabi',
                    title: 'Stories from my village',
                    description:
                        'Some of the best memories are created in the small places we call home.',
                    initial: 'A',
                  ),
                ],
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
    required String author,
    required String language,
    required String title,
    required String description,
    required String initial,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {
          // Story detail screen will be added when real stories
          // are connected to MongoDB.
        },
        borderRadius: BorderRadius.circular(18),
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
                        Text(
                          author,
                          style: const TextStyle(
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
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF777C73),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}