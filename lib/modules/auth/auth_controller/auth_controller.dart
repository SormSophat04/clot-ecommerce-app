import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  // Login
  final loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Sign Up
  final signUpFormKey = GlobalKey<FormState>();
  final signUpNameController = TextEditingController();
  final signUpPhoneController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();

  // Forgot Password
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final forgotPasswordEmailController = TextEditingController();

  bool isLoading = false;
  bool isLoginPasswordVisible = false;
  bool isSignUpPasswordVisible = false;

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpNameController.dispose();
    signUpPhoneController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    super.onClose();
  }

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible = !isLoginPasswordVisible;
    update();
  }

  void toggleSignUpPasswordVisibility() {
    isSignUpPasswordVisible = !isSignUpPasswordVisible;
    update();
  }

  Future<void> login() async {
    // if (!loginFormKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Get.snackbar(
      //   'Success',
      //   'Logged in successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );

      Get.offAllNamed(Routes.splash);
    } catch (e) {
      _showError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      // TODO: Implement actual sign up with repository
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.splash);
    } catch (e) {
      _showError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendForgotPasswordLink() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      // TODO: Implement actual forgot password with repository
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Email Sent',
        'Reset password link has been sent to your email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _showError(e);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  void _showError(Object error) {
    Get.snackbar(
      'Error',
      error.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
