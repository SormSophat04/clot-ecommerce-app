import 'package:clot_ecommerce_app/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  // Login
  var loginFormKey = GlobalKey<FormState>();
  final loginPhoneNumberController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Sign Up
  var signUpFormKey = GlobalKey<FormState>();
  final signUpNameController = TextEditingController();
  final signUpPhoneController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();

  // Forgot Password
  var forgotPasswordFormKey = GlobalKey<FormState>();
  final forgotPasswordEmailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  /// 0 = enter email/phone, 1 = enter OTP, 2 = set new password
  final forgotPasswordStep = 0.obs;
  final forgotPasswordOtpError = RxnString();

  /// 0 = details form, 1 = OTP verification
  final registrationStep = 0.obs;
  final registrationOtpError = RxnString();

  final isLoading = false.obs;
  final isLoginPasswordVisible = false.obs;
  final isSignUpPasswordVisible = false.obs;
  final isSignUpConfirmPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;

  final AuthRepository _authRepository = Get.find<AuthRepository>();

  @override
  void onClose() {
    // Controllers will be garbage collected with the instance. 
    // Manual disposal here often causes race conditions during navigation.
    super.onClose();
  }

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleSignUpPasswordVisibility() {
    isSignUpPasswordVisible.value = !isSignUpPasswordVisible.value;
  }

  void toggleSignUpConfirmPasswordVisibility() {
    isSignUpConfirmPasswordVisible.value = !isSignUpConfirmPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      await _authRepository.login(
        loginPhoneNumberController.text,
        loginPasswordController.text,
      );

      Get.offAllNamed(Routes.splash);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      final response = await _authRepository.register(
        username: signUpNameController.text,
        phoneNumber: signUpPhoneController.text,
        email: signUpEmailController.text,
        password: signUpPasswordController.text,
      );

      // If token is null, it means verification is required
      if (response['token'] == null || response['token'].toString().isEmpty) {
        registrationStep.value = 1;
        otpController.clear();
        registrationOtpError.value = null;
      } else {
        // Auto-login if token provided (e.g. if we disable OTP for some reason)
        Get.offAllNamed(Routes.splash);
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyRegistration() async {
    registrationOtpError.value = null;
    if (otpController.text.trim().length != 6) {
      return;
    }

    _setLoading(true);
    try {
      await _authRepository.verifyRegistration(
        signUpEmailController.text.trim(),
        otpController.text.trim(),
      );

      Get.offAllNamed(Routes.splash);
    } catch (e) {
      registrationOtpError.value = 'Incorrect or expired code';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resendRegistrationOtp() async {
    _setLoading(true);
    try {
      await _authRepository.resendRegistrationOtp(signUpEmailController.text.trim());
      otpController.clear();
      registrationOtpError.value = null;
    } finally {
      _setLoading(false);
    }
  }

  // ── Forgot Password: 3-Step Flow ──────────────────────────────────────────

  /// Step 1: Send OTP
  Future<void> sendOtp() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      await _authRepository.sendOtp(forgotPasswordEmailController.text.trim());

      forgotPasswordStep.value = 1;
    } finally {
      _setLoading(false);
    }
  }

  /// Step 2: Verify OTP
  Future<void> verifyOtp() async {
    forgotPasswordOtpError.value = null;
    if (otpController.text.trim().length != 6) {
      return;
    }

    _setLoading(true);
    try {
      await _authRepository.verifyOtp(
        forgotPasswordEmailController.text.trim(),
        otpController.text.trim(),
      );

      forgotPasswordStep.value = 2;
    } catch (e) {
      forgotPasswordOtpError.value = 'Incorrect code';
    } finally {
      _setLoading(false);
    }
  }

  /// Step 3: Reset Password
  Future<void> resetPassword() async {
    if (newPasswordController.text.length < 6) {
      return;
    }
    if (newPasswordController.text != confirmNewPasswordController.text) {
      return;
    }

    _setLoading(true);
    try {
      await _authRepository.resetPassword(
        forgotPasswordEmailController.text.trim(),
        otpController.text.trim(),
        newPasswordController.text,
      );

      // Reset state and go back to login
      Future.delayed(const Duration(milliseconds: 500), () {
        _resetForgotPasswordState();
        Get.offAllNamed(Routes.login);
      });
    } finally {
      _setLoading(false);
    }
  }

  void _resetForgotPasswordState() {
    forgotPasswordStep.value = 0;
    forgotPasswordEmailController.clear();
    otpController.clear();
    forgotPasswordOtpError.value = null;
    newPasswordController.clear();
    confirmNewPasswordController.clear();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    isLoading.value = value;
  }

}
