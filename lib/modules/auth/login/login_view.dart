import 'package:clot_ecommerce_app/core/widgets/custom_buttons/platform_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/auth/auth_form_scaffold.dart';
import '../../../core/widgets/auth/auth_header.dart';
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
      builder: (controller) => AuthFormScaffold(
        formKey: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(title: 'Sign in', topSpacing: Get.height * 0.05),
            const SizedBox(height: 40),
            CustomTextField(
              hint: 'Email',
              controller: controller.loginEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
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
            PrimaryButton(
              text: 'Sign In',
              isLoading: controller.isLoading,
              onPressed: controller.login,
            ),
            const SizedBox(height: 16),
            SecondaryButton(
              text: 'Create Account',
              onPressed:
                  onToggleToRegister ?? () => Get.toNamed(Routes.register),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.toNamed(Routes.forgotPassword),
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 16),
            PlatformButton(
              text: 'Facebook',
              icon: const Icon(Icons.facebook, color: Colors.blue, size: 36),
              onPressed: () {
                // Implement social login logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
