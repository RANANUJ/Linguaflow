import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/translation_helper.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../shared/widgets/language_selector.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Temporary output for testing.
      // Backend authentication will be added later.
      debugPrint('Email: $email');
      debugPrint('Password entered: ${password.isNotEmpty}');
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _openRegisterScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
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

                const SizedBox(height: 60),

                // Login heading.
                Text(
                  translate(
                    ref,
                    TranslationKeys.welcomeBack,
                  ),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Login subtitle.
                Text(
                  translate(
                    ref,
                    TranslationKeys.signInToContinue,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

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

                const SizedBox(height: 20),

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

                const SizedBox(height: 24),

                // Login button.
                ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    translate(
                      ref,
                      TranslationKeys.login,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Registration section.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      translate(
                        ref,
                        TranslationKeys.dontHaveAccount,
                      ),
                    ),
                    TextButton(
                      onPressed: _openRegisterScreen,
                      child: Text(
                        translate(
                          ref,
                          TranslationKeys.register,
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