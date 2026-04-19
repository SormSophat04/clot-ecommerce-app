import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/core/utils/validators.dart';
import 'package:clot_ecommerce_app/core/widgets/auth/auth_form_scaffold.dart';
import 'package:clot_ecommerce_app/core/widgets/auth/auth_header.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_buttons/primary_button.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_buttons/secondary_button.dart';
import 'package:clot_ecommerce_app/core/widgets/custom_inputs/custom_text_field.dart';
import 'package:clot_ecommerce_app/modules/auth/auth_controller/auth_binding.dart';
import 'package:clot_ecommerce_app/modules/auth/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class RegisterView extends StatelessWidget {
  final VoidCallback? onToggleToLogin;

  const RegisterView({super.key, this.onToggleToLogin});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>(tag: authControllerTag);

    return Obx(() {
      if (controller.registrationStep.value == 0) {
        return _buildRegistrationForm(controller);
      } else {
        return _buildVerificationForm(controller);
      }
    });
  }

  Widget _buildRegistrationForm(AuthController controller) {
    return AuthFormScaffold(
      key: const ValueKey('registration_form'),
      formKey: controller.signUpFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
          Obx(() => CustomTextField(
                hint: 'Password',
                controller: controller.signUpPasswordController,
                obscureText: !controller.isSignUpPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isSignUpPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: controller.toggleSignUpPasswordVisibility,
                ),
                validator: Validators.password,
              )),
          SizedBox(height: 16.h),
          Obx(() => CustomTextField(
                hint: 'Confirm Password',
                controller: controller.signUpConfirmPasswordController,
                obscureText: !controller.isSignUpConfirmPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isSignUpConfirmPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: controller.toggleSignUpConfirmPasswordVisibility,
                ),
                validator: Validators.confirmPassword(
                  controller.signUpPasswordController.text,
                ),
              )),
          SizedBox(height: 44.h),
          Obx(() => PrimaryButton(
                text: 'Sign Up',
                isLoading: controller.isLoading.value,
                onPressed: controller.signUp,
              )),
          SizedBox(height: 16.h),
          SecondaryButton(
            text: 'Login',
            onPressed: onToggleToLogin ?? () => Get.offNamed(Routes.login),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildVerificationForm(AuthController controller) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: Get.theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Get.theme.colorScheme.primary, width: 2),
      color: Get.theme.colorScheme.surface,
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Get.theme.colorScheme.error, width: 2),
    );

    return AuthFormScaffold(
      key: const ValueKey('verification_form'),
      formKey: GlobalKey<FormState>(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthHeader(
            title: 'Verify your email',
            topSpacing: Get.height * 0.05,
          ),
          SizedBox(height: 24.h),
          Text(
            'We have sent a verification code to:',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.signUpEmailController.text,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Get.theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 48.h),
          Center(
            child: Pinput(
              length: 6,
              controller: controller.otpController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              errorPinTheme: errorPinTheme,
              forceErrorState: controller.registrationOtpError.value != null,
              errorText: controller.registrationOtpError.value,
              errorTextStyle: TextStyle(
                color: Get.theme.colorScheme.error,
                fontSize: 14.sp,
              ),
              onCompleted: (pin) => controller.verifyRegistration(),
              onChanged: (pin) {
                if (controller.registrationOtpError.value != null) {
                  controller.registrationOtpError.value = null;
                }
              },
            ),
          ),
          SizedBox(height: 48.h),
          Obx(() => PrimaryButton(
                text: 'Verify',
                isLoading: controller.isLoading.value,
                onPressed: controller.verifyRegistration,
              )),
          SizedBox(height: 24.h),
          Center(
            child: TextButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.resendRegistrationOtp,
              child: Text(
                "Didn't receive code? Resend",
                style: Get.textTheme.labelLarge?.copyWith(
                  color: Get.theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SecondaryButton(
            text: 'Back to Register',
            onPressed: () => controller.registrationStep.value = 0,
          ),
        ],
      ),
    );
  }
}
