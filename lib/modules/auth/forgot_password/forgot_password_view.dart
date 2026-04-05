import 'package:clot_ecommerce_app/core/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_buttons/primary_button.dart';
import '../../../core/widgets/custom_inputs/custom_text_field.dart';
import '../auth_controller/auth_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBar(title: 'Forgot Password'),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.forgotPasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.05),
                  const Text(
                    'Reset your password',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter your email and we will send a reset link.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    hint: 'Email',
                    controller: controller.forgotPasswordEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Send Reset Link',
                    isLoading: controller.isLoading,
                    onPressed: controller.sendForgotPasswordLink,
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
