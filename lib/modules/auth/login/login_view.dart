import 'package:clot_ecommerce_app/core/widgets/custom_buttons/platform_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widgets/auth/auth_form_scaffold.dart';
import '../../../core/widgets/auth/auth_header.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_inputs/custom_text_field.dart';
import '../../../core/widgets/custom_buttons/primary_button.dart';
import '../../../core/widgets/custom_buttons/secondary_button.dart';
import '../../../core/utils/validators.dart';
import '../auth_controller/auth_binding.dart';
import '../auth_controller/auth_controller.dart';

class LoginView extends StatelessWidget {
  final VoidCallback? onToggleToRegister;

  const LoginView({super.key, this.onToggleToRegister});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>(tag: authControllerTag);

    return AuthFormScaffold(
      key: UniqueKey(),
      formKey: controller.loginFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthHeader(title: 'Sign in', topSpacing: Get.height * 0.05),
          SizedBox(height: 40.h),
          CustomTextField(
            hint: 'Phone Number',
            controller: controller.loginPhoneNumberController,
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
          ),
          SizedBox(height: 16.h),
          Obx(
            () => CustomTextField(
              hint: 'Password',
              controller: controller.loginPasswordController,
              obscureText: !controller.isLoginPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isLoginPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: controller.toggleLoginPasswordVisibility,
              ),
              validator: Validators.password,
            ),
          ),
          SizedBox(height: 44.h),
          Obx(
            () => PrimaryButton(
              text: 'Sign In',
              isLoading: controller.isLoading.value,
              onPressed: controller.login,
            ),
          ),
          SizedBox(height: 16.h),
          SecondaryButton(
            text: 'Create Account',
            onPressed: onToggleToRegister ?? () => Get.offNamed(Routes.register),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => Get.offNamed(Routes.forgotPassword),
            child: const Text('Forgot Password?'),
          ),
          SizedBox(height: 16.h),
          PlatformButton(
            text: 'Facebook',
            icon: Icon(Icons.facebook, color: Colors.blue, size: 36.sp),
            onPressed: () {
              // Implement social login logic
            },
          ),
        ],
      ),
    );
  }
}
