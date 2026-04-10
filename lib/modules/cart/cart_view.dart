import 'package:clot_ecommerce_app/core/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/common/skeleton_loader.dart';
import 'cart_controller.dart';
import 'widgets/cart_states.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(title: 'Cart', actions: [Container(width: 40)]),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.cartItems.isEmpty) {
            return const CartListSkeleton();
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.cartItems.isEmpty) {
            return CartErrorState(
              message: controller.errorMessage.value,
              onRetry: controller.fetchCart,
            );
          }

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
