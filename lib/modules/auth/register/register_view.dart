import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/core/utils/validators.dart';
import 'package:clot_ecommerce_app/core/widgets/auth/auth_form_scaffold.dart';
import 'package:clot_ecommerce_app/core/widgets/auth/auth_header.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_buttons/primary_button.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_buttons/secondary_button.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_inputs/custom_text_field.dart';
import 'package:clot_ecommerce_app/modules/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  final VoidCallback? onToggleToLogin;

  const RegisterView({super.key, this.onToggleToLogin});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) => AuthFormScaffold(
        formKey: controller.signUpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(
              title: 'Create an account',
              topSpacing: Get.height * 0.05,
            ),
            SizedBox(height: 40.h),
            CustomTextField(
              hint: 'Name',
              controller: controller.signUpNameController,
              keyboardType: TextInputType.text,
              validator: Validators.name,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              hint: 'Phone number',
              controller: controller.signUpPhoneController,
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              hint: 'Email',
              controller: controller.signUpEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            SizedBox(height: 16.h),
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
            SizedBox(height: 44.h),
            PrimaryButton(
              text: 'Sign Up',
              isLoading: controller.isLoading,
              onPressed: controller.signUp,
            ),
            SizedBox(height: 16.h),
            SecondaryButton(
              text: 'Login',
              onPressed: onToggleToLogin ?? () => Get.toNamed(Routes.login),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
