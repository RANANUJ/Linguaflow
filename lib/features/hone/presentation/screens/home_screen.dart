import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/translation_helper.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/widgets/language_selector.dart';
import 'create_story_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
                  _buildHeader(ref),
                  const SizedBox(height: 36),

                  Text(
                    translate(ref, TranslationKeys.homeTitle),
                    style: const TextStyle(
                      fontSize: 30,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF243A30),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    translate(ref, TranslationKeys.homeDescription),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.55,
                      color: Color(0xFF777C73),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildCreateStoryAction(context, ref),

                  const SizedBox(height: 36),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          translate(
                            ref,
                            TranslationKeys.recentStories,
                          ),
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF243A30),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF245C48),
                        ),
                        child: Text(
                          translate(ref, TranslationKeys.viewAll),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _buildStoryCard(
                    title: 'My journey with new languages',
                    description:
                        'Learning a new language opens the door to new people, cultures and experiences.',
                    language: 'English',
                    icon: Icons.menu_book_outlined,
                  ),

                  const SizedBox(height: 14),

                  _buildStoryCard(
                    title: 'A story from my hometown',
                    description:
                        'Every place has its own beautiful stories waiting to be shared with the world.',
                    language: 'English',
                    icon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 14),

                  _buildStoryCard(
                    title: 'Small moments worth remembering',
                    description:
                        'Sometimes the simplest moments become the stories we remember the longest.',
                    language: 'English',
                    icon: Icons.auto_stories_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
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

  Widget _buildCreateStoryAction(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateStoryScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF245C48),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  translate(ref, TranslationKeys.writeStory),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryCard({
    required String title,
    required String description,
    required String language,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6E5DD),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0EC),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF245C48),
              size: 23,
            ),
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF243A30),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: Color(0xFF777C73),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  language,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF245C48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}