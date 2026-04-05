import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: const Center(
        child: Text('Cart View - To be implemented'),
      ),
    );
  }
}

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CartController>(() => CartController());
  }
}
