import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: const Center(
        child: Text('Product Details View - To be implemented'),
      ),
    );
  }
}

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ProductDetailsController>(() => ProductDetailsController());
  }
}
