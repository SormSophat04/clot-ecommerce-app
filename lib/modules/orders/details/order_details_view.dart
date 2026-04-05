import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: const Center(
        child: Text('Order Details View - To be implemented'),
      ),
    );
  }
}

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<OrderDetailsController>(() => OrderDetailsController());
  }
}
