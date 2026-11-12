
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/localization/translation_helper.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/widgets/language_selector.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  ConsumerState<CreateStoryScreen> createState() =>
      _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _contentController =
      TextEditingController();

  final LocalStorageService _storage = LocalStorageService();

  String _selectedLanguage = 'English';

  bool _isPublishing = false;

  final List<String> _languages = [
    'English',
    'Hindi',
    'Punjabi',
    'Spanish',
    'French',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Colors.red.shade700
            : const Color(0xFF245C48),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveDraft() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      _showMessage(
        translate(ref, TranslationKeys.startWritingMessage),
      );
      return;
    }

    // Draft storage will be connected later.
    _showMessage(
      translate(ref, TranslationKeys.draftSaved),
    );
  }

  // Publish story to NestJS backend.
  Future<void> _publishStory() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showMessage(
        translate(ref, TranslationKeys.addTitleAndContent),
        isError: true,
      );
      return;
    }

    if (_isPublishing) return;

    setState(() {
      _isPublishing = true;
    });

    try {
      // Get saved JWT token.
      final token = await _storage.getToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'Please log in again before publishing your story.',
        );
      }

      // Send story to NestJS.
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/stories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'language': _selectedLanguage,
        }),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        if (!mounted) return;

        _showMessage('Your story was published successfully!');

        _titleController.clear();
        _contentController.clear();

        return;
      }

      String errorMessage = 'Unable to publish your story.';

      try {
        final responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'];

          if (message is String) {
            errorMessage = message;
          } else if (message is List) {
            errorMessage = message.join(', ');
          }
        }
      } catch (_) {
        // Keep the default error message.
      }

      throw Exception(errorMessage);
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPublishing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5EF),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Text(
          translate(ref, TranslationKeys.createStory),
          style: const TextStyle(
            color: Color(0xFF243A30),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: LanguageSelector(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(
                      ref,
                      TranslationKeys.writeAtYourOwnPace,
                    ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF243A30),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translate(
                      ref,
                      TranslationKeys.createStoryDescription,
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF777C73),
                    ),
                  ),
                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE6E5DD),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate(ref, TranslationKeys.storyTitle),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF243A30),
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextField(
                          controller: _titleController,
                          textCapitalization:
                              TextCapitalization.sentences,
                          decoration: _inputDecoration(
                            hintText: translate(
                              ref,
                              TranslationKeys.storyTitleHint,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          translate(
                            ref,
                            TranslationKeys.writingLanguage,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF243A30),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBFBF8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE6E5DD),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedLanguage,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF245C48),
                              ),
                              items: _languages.map((language) {
                                return DropdownMenuItem<String>(
                                  value: language,
                                  child: Text(
                                    language,
                                    style: const TextStyle(
                                      color: Color(0xFF243A30),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() {
                                  _selectedLanguage = value;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          translate(ref, TranslationKeys.yourStory),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF243A30),
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextField(
                          controller: _contentController,
                          minLines: 10,
                          maxLines: 16,
                          textCapitalization:
                              TextCapitalization.sentences,
                          decoration: _inputDecoration(
                            hintText: translate(
                              ref,
                              TranslationKeys.storyContentHint,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen =
                          constraints.maxWidth < 430;

                      if (isSmallScreen) {
                        return Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            _buildSaveDraftButton(),
                            const SizedBox(height: 12),
                            _buildPublishButton(),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: _buildSaveDraftButton(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: _buildPublishButton(),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveDraftButton() {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: _saveDraft,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF245C48),
          side: const BorderSide(
            color: Color(0xFFB8C8C0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          translate(ref, TranslationKeys.saveDraft),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isPublishing ? null : _publishStory,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF245C48),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF8DA99B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: _isPublishing
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                translate(ref, TranslationKeys.publishStory),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF9A9D96),
      ),
      filled: true,
      fillColor: const Color(0xFFFBFBF8),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE6E5DD),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE6E5DD),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF245C48),
          width: 1.5,
        ),
      ),
    );
  }
}
