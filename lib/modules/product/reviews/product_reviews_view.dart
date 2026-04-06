import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common/feature_placeholder_scaffold.dart';

class ProductReviewsView extends StatelessWidget {
  const ProductReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Product Reviews',
      message: 'Product reviews view is coming soon.',
      icon: Icons.reviews_outlined,
    );
  }
}

class ProductReviewsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ProductReviewsController>(() => ProductReviewsController());
  }
}
