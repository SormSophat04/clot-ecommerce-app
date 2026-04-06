import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common/feature_placeholder_scaffold.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Checkout',
      message: 'Checkout view is coming soon.',
      icon: Icons.payment_outlined,
    );
  }
}

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
