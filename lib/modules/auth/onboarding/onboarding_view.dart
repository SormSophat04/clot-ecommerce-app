import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Onboarding View - To be implemented'),
      ),
    );
  }
}

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
