import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/common/feature_placeholder_scaffold.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Wishlist',
      message: 'Wishlist view is coming soon.',
      icon: Icons.favorite_border,
    );
  }
}

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<WishlistController>(() => WishlistController());
  }
}
