import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/translation_helper.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/widgets/language_selector.dart';
import '../providers/auth_controller.dart';
import '../widgets/register_form.dart';

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
  final _confirmPasswordController =
      TextEditingController();

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

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref.read(authControllerProvider.notifier).register(
          name: _nameController.text.trim(),
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
          content: Text('Account created successfully!'),
          backgroundColor: Color(0xFF245C48),
        ),
      );
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
                constraints:
                    const BoxConstraints(maxWidth: 440),
                child: _buildRegisterCard(isLoading),
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
            constraints:
                const BoxConstraints(maxWidth: 440),
            child: _buildRegisterCard(isLoading),
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
              TranslationKeys.registerBrandTitle,
            ),
            style: const TextStyle(
              fontSize: 38,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF243A30),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            translate(
              ref,
              TranslationKeys.registerBrandSubtitle,
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

  Widget _buildRegisterCard(bool isLoading) {
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
              TranslationKeys.createAccount,
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
              TranslationKeys.createAccountToGetStarted,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF777C73),
            ),
          ),

          const SizedBox(height: 30),

          RegisterForm(
            formKey: _formKey,
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController:
                _confirmPasswordController,
            isPasswordVisible: _isPasswordVisible,
            isConfirmPasswordVisible:
                _isConfirmPasswordVisible,
            isLoading: isLoading,
            onPasswordVisibilityChanged:
                _togglePasswordVisibility,
            onConfirmPasswordVisibilityChanged:
                _toggleConfirmPasswordVisibility,
            onRegister: _register,
            onLogin: _goToLoginScreen,
            nameLabel:
                translate(ref, TranslationKeys.name),
            emailLabel:
                translate(ref, TranslationKeys.email),
            passwordLabel:
                translate(ref, TranslationKeys.password),
            confirmPasswordLabel: translate(
              ref,
              TranslationKeys.confirmPassword,
            ),
            registerLabel:
                translate(ref, TranslationKeys.register),
            alreadyHaveAccountLabel: translate(
              ref,
              TranslationKeys.alreadyHaveAccount,
            ),
            loginLabel:
                translate(ref, TranslationKeys.login),
            enterNameMessage:
                translate(ref, TranslationKeys.enterName),
            enterEmailMessage:
                translate(ref, TranslationKeys.enterEmail),
            validEmailMessage:
                translate(ref, TranslationKeys.validEmail),
            enterPasswordMessage: translate(
              ref,
              TranslationKeys.enterPassword,
            ),
            confirmPasswordMessage: translate(
              ref,
              TranslationKeys.confirmYourPassword,
            ),
            passwordMismatchMessage: translate(
              ref,
              TranslationKeys.passwordsDoNotMatch,
            ),
          ),
        ],
      ),
    );
  }
}