import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common/feature_placeholder_scaffold.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Onboarding',
      message: 'Onboarding view is coming soon.',
      icon: Icons.rocket_launch_outlined,
      showAppBar: false,
    );
  }
}

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
