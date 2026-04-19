import 'package:clot_ecommerce_app/core/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

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
    final controller = Get.find<AuthController>(tag: authControllerTag);

    return AuthFormScaffold(
      key: UniqueKey(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final step = controller.forgotPasswordStep.value;
          return CustomAppBar(
            title: step == 0
                ? 'Forgot Password'
                : step == 1
                ? 'Verify OTP'
                : 'New Password',
          );
        }),
      ),
      formKey: controller.forgotPasswordFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Obx(() {
        final step = controller.forgotPasswordStep.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step == 0) _buildStep0(controller),
            if (step == 1) _buildStep1(controller),
            if (step == 2) _buildStep2(controller),
          ],
        );
      }),
    );
  }

  // ── Step 0: Enter email or phone ──────────────────────────────────────────

  Widget _buildStep0(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthHeader(
          title: 'Reset your password',
          subtitle:
              'Enter the email or phone number associated with your account.',
          topSpacing: Get.height * 0.05,
        ),
        SizedBox(height: 32.h),
        CustomTextField(
          hint: 'Email or Phone number',
          controller: controller.forgotPasswordEmailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email or phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 24.h),
        Obx(
          () => PrimaryButton(
            text: 'Send OTP',
            isLoading: controller.isLoading.value,
            onPressed: controller.sendOtp,
          ),
        ),
      ],
    );
  }

  // ── Step 1: Enter OTP ─────────────────────────────────────────────────────

  Widget _buildStep1(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthHeader(
          title: 'Enter verification code',
          subtitle:
              'We sent a 6-digit code to ${controller.forgotPasswordEmailController.text}',
          topSpacing: Get.height * 0.05,
        ),
        SizedBox(height: 32.h),
        Center(
          child: Pinput(
            length: 6,
            controller: controller.otpController,
            defaultPinTheme: PinTheme(
              width: 48.w,
              height: 56.h,
              textStyle: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.onSurface,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Get.theme.inputDecorationTheme.fillColor,
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 48.w,
              height: 56.h,
              textStyle: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.onSurface,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Get.theme.inputDecorationTheme.fillColor,
                border: Border.all(
                  color: Get.theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 48.w,
              height: 56.h,
              textStyle: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.onSurface,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Get.theme.inputDecorationTheme.fillColor,
              ),
            ),
            errorPinTheme: PinTheme(
              width: 48.w,
              height: 56.h,
              textStyle: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.error,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Get.theme.inputDecorationTheme.fillColor,
                border: Border.all(
                  color: Get.theme.colorScheme.error,
                  width: 1.5,
                ),
              ),
            ),
            forceErrorState: controller.forgotPasswordOtpError.value != null,
            errorText: controller.forgotPasswordOtpError.value,
            errorTextStyle: TextStyle(
              color: Get.theme.colorScheme.error,
              fontSize: 12.sp,
            ),
            onChanged: (value) =>
                controller.forgotPasswordOtpError.value = null,
            showCursor: true,
            onCompleted: (pin) => controller.verifyOtp(),
          ),
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => TextButton(
              onPressed: controller.isLoading.value ? null : controller.sendOtp,
              child: Text(
                'Resend Code',
                style: TextStyle(
                  color: Get.theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => PrimaryButton(
            text: 'Verify',
            isLoading: controller.isLoading.value,
            onPressed: controller.verifyOtp,
          ),
        ),
      ],
    );
  }

  // ── Step 2: New Password ──────────────────────────────────────────────────

  Widget _buildStep2(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthHeader(
          title: 'Create new password',
          subtitle: 'Your new password must be at least 6 characters long.',
          topSpacing: Get.height * 0.05,
        ),
        SizedBox(height: 32.h),
        Obx(
          () => CustomTextField(
            hint: 'New Password',
            controller: controller.newPasswordController,
            obscureText: !controller.isNewPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isNewPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20.sp,
              ),
              onPressed: controller.toggleNewPasswordVisibility,
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => CustomTextField(
            hint: 'Confirm Password',
            controller: controller.confirmNewPasswordController,
            obscureText: !controller.isNewPasswordVisible.value,
            validator: (value) {
              if (value != controller.newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 24.h),
        Obx(
          () => PrimaryButton(
            text: 'Reset Password',
            isLoading: controller.isLoading.value,
            onPressed: controller.resetPassword,
          ),
        ),
      ],
    );
  }
}
