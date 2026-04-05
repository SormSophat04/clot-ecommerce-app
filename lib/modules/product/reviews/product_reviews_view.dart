import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductReviewsView extends StatelessWidget {
  const ProductReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Reviews')),
      body: const Center(
        child: Text('Product Reviews View - To be implemented'),
      ),
    );
  }
}

class ProductReviewsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ProductReviewsController>(() => ProductReviewsController());
  }
}
