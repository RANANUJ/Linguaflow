import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguaflow/features/hone/presentation/screens/main_navigation_screen.dart';

import '../../../../core/localization/translation_helper.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/localization/translation_provider.dart';
import '../../../../shared/widgets/language_selector.dart';

import '../providers/auth_controller.dart';
import '../widgets/login_form.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'rana@gmail.com');
  final _passwordController = TextEditingController(text: '123456');
  
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    final authState = ref.read(authControllerProvider);

    if (authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error.toString()),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    if (authState.value != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Color(0xFF245C48),
        ),
      );

      // Open the main LinguaFlow application after successful login.
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _openRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the translation version.
    // Whenever a new language pack is loaded, this screen will rebuild.
    ref.watch(translationVersionProvider);

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 850) {
              return _buildWideLayout(isLoading);
            }

            return _buildNarrowLayout(isLoading);
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: _buildBrandSection(),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: _buildLoginCard(isLoading),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      child: Column(
        children: [
          _buildBrandSection(),
          const SizedBox(height: 35),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: _buildLoginCard(isLoading),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandSection() {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFF245C48),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.translate_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'LinguaFlow',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF245C48),
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),

          Text(
            translate(
              ref,
              TranslationKeys.loginBrandTitle,
            ),
            style: const TextStyle(
              fontSize: 42,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF243A30),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            translate(
              ref,
              TranslationKeys.loginBrandDescription,
            ),
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF777C73),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE6E5DD),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: LanguageSelector(),
          ),
          const SizedBox(height: 25),

          Text(
            translate(
              ref,
              TranslationKeys.welcomeBack,
            ),
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w800,
              color: Color(0xFF243A30),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            translate(
              ref,
              TranslationKeys.login,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF777C73),
            ),
          ),
          const SizedBox(height: 30),

          LoginForm(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            isPasswordVisible: _isPasswordVisible,
            isLoading: isLoading,
            onPasswordVisibilityChanged: _togglePasswordVisibility,
            onLogin: _login,
            onRegister: _openRegisterScreen,
            emailLabel: translate(
              ref,
              TranslationKeys.email,
            ),
            passwordLabel: translate(
              ref,
              TranslationKeys.password,
            ),
            loginLabel: translate(
              ref,
              TranslationKeys.login,
            ),
            registerLabel: translate(
              ref,
              TranslationKeys.register,
            ),
            dontHaveAccountLabel: translate(
              ref,
              TranslationKeys.dontHaveAccount,
            ),
            enterEmailMessage: translate(
              ref,
              TranslationKeys.enterEmail,
            ),
            validEmailMessage: translate(
              ref,
              TranslationKeys.validEmail,
            ),
            enterPasswordMessage: translate(
              ref,
              TranslationKeys.enterPassword,
            ),
          ),
        ],
      ),
    );
  }
}