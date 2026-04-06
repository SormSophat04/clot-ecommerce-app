import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common/feature_placeholder_scaffold.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'My Orders',
      message: 'Orders list view is coming soon.',
      icon: Icons.receipt_long_outlined,
    );
  }
}

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
