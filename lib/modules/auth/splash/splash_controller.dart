import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate initialization
    await Future.delayed(const Duration(seconds: 2));

    // Check if onboarding is complete
    // For now, navigate to home - you can implement onboarding check later
    Get.offAllNamed('/home');

    // Future implementation:
    // final storageService = Get.find<StorageService>();
    // if (storageService.isOnboardingComplete) {
    //   Get.offAllNamed('/home');
    // } else {
    //   Get.offAllNamed('/onboarding');
    // }
  }
}
