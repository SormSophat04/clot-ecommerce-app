import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import 'widgets/cart_states.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Obx(() {
          if (controller.cartItems.isEmpty) {
            return const EmptyCartState();
          } else {
            return const PopulatedCartState();
          }
        }),
      ),
    );
  }
}