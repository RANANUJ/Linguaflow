
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isLoading,
    required this.onPasswordVisibilityChanged,
    required this.onConfirmPasswordVisibilityChanged,
    required this.onRegister,
    required this.onLogin,
    required this.nameLabel,
    required this.emailLabel,
    required this.passwordLabel,
    required this.confirmPasswordLabel,
    required this.registerLabel,
    required this.alreadyHaveAccountLabel,
    required this.loginLabel,
    required this.enterNameMessage,
    required this.enterEmailMessage,
    required this.validEmailMessage,
    required this.enterPasswordMessage,
    required this.confirmPasswordMessage,
    required this.passwordMismatchMessage,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;

  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onConfirmPasswordVisibilityChanged;
  final VoidCallback onRegister;
  final VoidCallback onLogin;

  final String nameLabel;
  final String emailLabel;
  final String passwordLabel;
  final String confirmPasswordLabel;
  final String registerLabel;
  final String alreadyHaveAccountLabel;
  final String loginLabel;

  final String enterNameMessage;
  final String enterEmailMessage;
  final String validEmailMessage;
  final String enterPasswordMessage;
  final String confirmPasswordMessage;
  final String passwordMismatchMessage;

  static const Color primaryColor = Color(0xFF245C48);
  static const Color secondaryColor = Color(0xFF777C73);
  static const Color borderColor = Color(0xFFE6E5DD);

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: secondaryColor,
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFFBFAF7),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 19,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            enabled: !isLoading,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration(
              label: nameLabel,
              icon: Icons.person_outline_rounded,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return enterNameMessage;
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: emailController,
            enabled: !isLoading,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              label: emailLabel,
              icon: Icons.mail_outline_rounded,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return enterEmailMessage;
              }

              if (!value.contains('@') || !value.contains('.')) {
                return validEmailMessage;
              }

              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: passwordController,
            enabled: !isLoading,
            obscureText: !isPasswordVisible,
            decoration: _inputDecoration(
              label: passwordLabel,
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                onPressed:
                    isLoading ? null : onPasswordVisibilityChanged,
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: secondaryColor,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return enterPasswordMessage;
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: confirmPasswordController,
            enabled: !isLoading,
            obscureText: !isConfirmPasswordVisible,
            decoration: _inputDecoration(
              label: confirmPasswordLabel,
              icon: Icons.lock_reset_rounded,
              suffixIcon: IconButton(
                onPressed: isLoading
                    ? null
                    : onConfirmPasswordVisibilityChanged,
                icon: Icon(
                  isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: secondaryColor,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return confirmPasswordMessage;
              }

              if (value != passwordController.text) {
                return passwordMismatchMessage;
              }

              return null;
            },
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: isLoading ? null : onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    primaryColor.withValues(alpha: 0.65),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      registerLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  alreadyHaveAccountLabel,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 13,
                  ),
                ),
              ),
              TextButton(
                onPressed: isLoading ? null : onLogin,
                child: Text(
                  loginLabel,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
