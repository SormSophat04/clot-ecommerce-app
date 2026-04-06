import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/common/feature_placeholder_scaffold.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Shopping Cart',
      message: 'Cart view is coming soon.',
      icon: Icons.shopping_cart_outlined,
    );
  }
}

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CartController>(() => CartController());
  }
}
