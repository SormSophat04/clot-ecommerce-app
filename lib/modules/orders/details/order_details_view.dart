import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common/feature_placeholder_scaffold.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Order Details',
      message: 'Order details view is coming soon.',
      icon: Icons.description_outlined,
    );
  }
}

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<OrderDetailsController>(() => OrderDetailsController());
  }
}
