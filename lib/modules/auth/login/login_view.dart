import 'package:clot_ecommerce_app/core/widgets/custom_buttons/platform_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_inputs/custom_text_field.dart';
import '../../../core/widgets/custom_buttons/primary_button.dart';
import '../../../core/widgets/custom_buttons/secondary_button.dart';
import '../../../core/utils/validators.dart';
import '../auth_controller/auth_controller.dart';

class LoginView extends StatelessWidget {
  final VoidCallback? onToggleToRegister;

  const LoginView({super.key, this.onToggleToRegister});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.05),
                  // Title
                  const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Email field
                  CustomTextField(
                    hint: 'Email',
                    controller: controller.loginEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  // Password field
                  CustomTextField(
                    hint: 'Password',
                    controller: controller.loginPasswordController,
                    obscureText: !controller.isLoginPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isLoginPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: controller.toggleLoginPasswordVisibility,
                    ),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 44),
                  // Login button
                  PrimaryButton(
                    text: 'Sign In',
                    isLoading: controller.isLoading,
                    onPressed: controller.login,
                  ),
                  const SizedBox(height: 16),
                  // Register button
                  SecondaryButton(
                    text: 'Create Account',
                    onPressed:
                        onToggleToRegister ??
                        () => Get.toNamed(Routes.register),
                  ),
                  const SizedBox(height: 16),
                  // Forgot password
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.forgotPassword),
                    child: const Text('Forgot Password?'),
                  ),
                  const SizedBox(height: 16),
                  // Platform button
                  PlatformButton(
                    text: "Facebook",
                    icon: const Icon(
                      Icons.facebook,
                      color: Colors.blue,
                      size: 36,
                    ),
                    onPressed: () {
                      // Implement sign in with Apple logic
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
}
