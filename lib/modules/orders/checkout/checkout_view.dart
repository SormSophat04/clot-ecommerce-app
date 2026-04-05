import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(
        child: Text('Checkout View - To be implemented'),
      ),
    );
  }
}

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
