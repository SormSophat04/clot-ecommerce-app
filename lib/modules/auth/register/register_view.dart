import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/core/utils/validators.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_buttons/primary_button.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_buttons/secondary_button.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_inputs/custom_text_field.dart';
import 'package:clot_ecommerce_app/modules/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  final VoidCallback? onToggleToLogin;

  const RegisterView({super.key, this.onToggleToLogin});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.05),
                  // Title
                  const Text(
                    'Create an account',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Email field
                  CustomTextField(
                    hint: 'Name',
                    controller: controller.signUpNameController,
                    keyboardType: TextInputType.text,
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: 'Phone number',
                    controller: controller.signUpPhoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: 'Email',
                    controller: controller.signUpEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  // Password field
                  CustomTextField(
                    hint: 'Password',
                    controller: controller.signUpPasswordController,
                    obscureText: !controller.isSignUpPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isSignUpPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: controller.toggleSignUpPasswordVisibility,
                    ),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 44),
                  // Login button
                  PrimaryButton(
                    text: 'Sign Up',
                    isLoading: controller.isLoading,
                    onPressed: controller.signUp,
                  ),
                  const SizedBox(height: 16),
                  // Register button
                  SecondaryButton(
                    text: 'Login',
                    onPressed:
                        onToggleToLogin ?? () => Get.toNamed(Routes.login),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
