import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/translation_helper.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../shared/widgets/language_selector.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();

      debugPrint('Name: $name');
      debugPrint('Email: $email');
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible =
          !_isConfirmPasswordVisible;
    });
  }

  void _goToLoginScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language selector.
                const Align(
                  alignment: Alignment.topRight,
                  child: LanguageSelector(),
                ),

                const SizedBox(height: 40),

                // Registration heading.
                Text(
                  translate(
                    ref,
                    TranslationKeys.createAccount,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Registration subtitle.
                Text(
                  translate(
                    ref,
                    TranslationKeys.createAccountToGetStarted,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Name input field.
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: translate(
                      ref,
                      TranslationKeys.name,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return translate(
                        ref,
                        TranslationKeys.enterName,
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Email input field.
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: translate(
                      ref,
                      TranslationKeys.email,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return translate(
                        ref,
                        TranslationKeys.enterEmail,
                      );
                    }

                    if (!value.contains('@') ||
                        !value.contains('.')) {
                      return translate(
                        ref,
                        TranslationKeys.validEmail,
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password input field.
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: translate(
                      ref,
                      TranslationKeys.password,
                    ),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return translate(
                        ref,
                        TranslationKeys.enterPassword,
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm password input field.
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: translate(
                      ref,
                      TranslationKeys.confirmPassword,
                    ),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed:
                          _toggleConfirmPasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return translate(
                        ref,
                        TranslationKeys.confirmYourPassword,
                      );
                    }

                    if (value != _passwordController.text) {
                      return translate(
                        ref,
                        TranslationKeys.passwordsDoNotMatch,
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Register button.
                ElevatedButton(
                  onPressed: _register,
                  child: Text(
                    translate(
                      ref,
                      TranslationKeys.register,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Login section.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      translate(
                        ref,
                        TranslationKeys.alreadyHaveAccount,
                      ),
                    ),
                    TextButton(
                      onPressed: _goToLoginScreen,
                      child: Text(
                        translate(
                          ref,
                          TranslationKeys.login,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}