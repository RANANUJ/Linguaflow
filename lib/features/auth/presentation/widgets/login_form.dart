import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onPasswordVisibilityChanged,
    required this.onLogin,
    required this.onRegister,
    required this.emailLabel,
    required this.passwordLabel,
    required this.loginLabel,
    required this.registerLabel,
    required this.dontHaveAccountLabel,
    required this.enterEmailMessage,
    required this.validEmailMessage,
    required this.enterPasswordMessage,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final GlobalKey<FormState> formKey;

  final bool isPasswordVisible;
  final bool isLoading;

  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  final String emailLabel;
  final String passwordLabel;
  final String loginLabel;
  final String registerLabel;
  final String dontHaveAccountLabel;
  final String enterEmailMessage;
  final String validEmailMessage;
  final String enterPasswordMessage;

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
        borderSide: const BorderSide(
          color: borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: borderColor,
        ),
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

              if (!value.contains('@') ||
                  !value.contains('.')) {
                return validEmailMessage;
              }

              return null;
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: passwordController,
            enabled: !isLoading,
            obscureText: !isPasswordVisible,
            decoration: _inputDecoration(
              label: passwordLabel,
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                onPressed: isLoading
                    ? null
                    : onPasswordVisibilityChanged,
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

          const SizedBox(height: 28),

          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
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
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          loginLabel,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 19,
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  dontHaveAccountLabel,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 13,
                  ),
                ),
              ),
              TextButton(
                onPressed: isLoading ? null : onRegister,
                child: Text(
                  registerLabel,
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