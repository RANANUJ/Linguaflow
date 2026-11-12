
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';

// Fetch published stories from MongoDB.
final storiesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/stories'),
    headers: {
      'Accept': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load stories. Status: ${response.statusCode}',
    );
  }

  final decodedData = jsonDecode(response.body);

  if (decodedData is! List) {
    throw Exception(
      'Invalid stories response from server.',
    );
  }

  return decodedData
      .whereType<Map>()
      .map(
        (story) => Map<String, dynamic>.from(story),
      )
      .where(
        (story) => story['isPublished'] == true,
      )
      .toList();
});

// Translate stories using the language code provided by the screen.
//
// Examples:
// translatedStoriesProvider('en')
// translatedStoriesProvider('hi')
// translatedStoriesProvider('fr')
final translatedStoriesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, languageCode) async {
    debugPrint(
      '========== DYNAMIC STORY TRANSLATION ==========',
    );
    debugPrint(
      'Requested language: $languageCode',
    );

    // Get the original stories from MongoDB.
    final stories = await ref.watch(
      storiesProvider.future,
    );

    debugPrint(
      'Stories loaded from MongoDB: ${stories.length}',
    );

    // No translation is needed for English.
    if (languageCode == 'en') {
      debugPrint(
        'English selected. Showing original stories.',
      );

      return stories;
    }

    // Stop if there are no stories.
    if (stories.isEmpty) {
      debugPrint(
        'No stories available for translation.',
      );

      return stories;
    }

    // Collect every story title and content for batch translation.
    final sourceTexts = <String>[];

    for (final story in stories) {
      final title = story['title']?.toString() ?? '';
      final content = story['content']?.toString() ?? '';

      sourceTexts.add(title);
      sourceTexts.add(content);
    }

    debugPrint(
      'Sending ${sourceTexts.length} story texts for translation.',
    );

    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/translation/batch',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'texts': sourceTexts,
          'targetLanguage': languageCode,
        }),
      );

      debugPrint(
        'Story translation status: ${response.statusCode}',
      );

      debugPrint(
        'Story translation response: ${response.body}',
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'Story translation failed with status: '
          '${response.statusCode}',
        );
      }

      final decodedResponse = jsonDecode(response.body);

      // The response should contain one translation for every text sent.
      if (decodedResponse is! List ||
          decodedResponse.length != sourceTexts.length) {
        throw Exception(
          'Story translation response was incomplete.',
        );
      }

      final translatedStories = <Map<String, dynamic>>[];

      // Put the translated title and content back into each story.
      for (int i = 0; i < stories.length; i++) {
        final translatedStory =
            Map<String, dynamic>.from(stories[i]);

        final titleItem = decodedResponse[i * 2];
        final contentItem = decodedResponse[(i * 2) + 1];

        if (titleItem is Map &&
            titleItem['translatedText'] is String) {
          translatedStory['title'] =
              titleItem['translatedText'];
        }

        if (contentItem is Map &&
            contentItem['translatedText'] is String) {
          translatedStory['content'] =
              contentItem['translatedText'];
        }

        translatedStories.add(translatedStory);
      }

      debugPrint(
        'Successfully translated '
        '${translatedStories.length} stories to $languageCode.',
      );

      return translatedStories;
    } catch (error) {
      debugPrint(
        'Dynamic story translation error: $error',
      );

      // If translation fails, show the original stories.
      return stories;
    }
  },
);
