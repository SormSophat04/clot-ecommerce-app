import 'package:clot_ecommerce_app/core/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/auth/auth_form_scaffold.dart';
import '../../../core/widgets/auth/auth_header.dart';
import '../../../core/widgets/custom_buttons/primary_button.dart';
import '../../../core/widgets/custom_inputs/custom_text_field.dart';
import '../auth_controller/auth_binding.dart';
import '../auth_controller/auth_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      tag: authControllerTag,
      autoRemove: false,
      builder: (controller) => AuthFormScaffold(
        appBar: const CustomAppBar(title: 'Forgot Password'),
        formKey: controller.forgotPasswordFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(
              title: 'Reset your password',
              subtitle: 'Enter your email and we will send a reset link.',
              topSpacing: Get.height * 0.05,
            ),
            SizedBox(height: 32.h),
            CustomTextField(
              hint: 'Email',
              controller: controller.forgotPasswordEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              text: 'Send Reset Link',
              isLoading: controller.isLoading,
              onPressed: controller.sendForgotPasswordLink,
            ),
          ],
        ),
      ),
    );
  }
}
