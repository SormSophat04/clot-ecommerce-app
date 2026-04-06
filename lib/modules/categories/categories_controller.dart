import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryData {
  const CategoryData({
    required this.name,
    required this.icon,
    required this.totalItems,
    required this.products,
  });

  final String name;
  final IconData icon;
  final int totalItems;
  final List<CategoryProduct> products;
}

class CategoryProduct {
  const CategoryProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.imageColor,
    required this.icon,
  });

  final String id;
  final String name;
  final String price;
  final Color imageColor;
  final IconData icon;
}

class CategoriesController extends GetxController {
  final Rxn<CategoryData> selectedCategory = Rxn<CategoryData>();
  final RxSet<String> wishlist = <String>{}.obs;

  final List<CategoryData> categories = const [
    CategoryData(
      name: 'Hoodies',
      icon: Icons.checkroom_rounded,
      totalItems: 240,
      products: [
        CategoryProduct(
          id: 'hoodie-1',
          name: "Men's Fleece Pullover Hoodie",
          price: '\$4100.00',
          imageColor: Color(0xFFDCE5DF),
          icon: Icons.checkroom_rounded,
        ),
        CategoryProduct(
          id: 'hoodie-2',
          name: 'Fleece Pullover Skate Hoodie',
          price: '\$4150.97',
          imageColor: Color(0xFFDEE3EA),
          icon: Icons.sports_football_rounded,
        ),
        CategoryProduct(
          id: 'hoodie-3',
          name: 'Fleece Skate Hoodie',
          price: '\$4110.00',
          imageColor: Color(0xFFEDE1CB),
          icon: Icons.waves_rounded,
        ),
        CategoryProduct(
          id: 'hoodie-4',
          name: "Men's Ice-Dye Pullover Hoodie",
          price: '\$4128.97',
          imageColor: Color(0xFFDCEACF),
          icon: Icons.palette_rounded,
        ),
        CategoryProduct(
          id: 'hoodie-5',
          name: 'Club Graphic Hoodie',
          price: '\$495.00',
          imageColor: Color(0xFFE1DDE8),
          icon: Icons.bolt_rounded,
        ),
        CategoryProduct(
          id: 'hoodie-6',
          name: 'Oversized Street Hoodie',
          price: '\$4135.00',
          imageColor: Color(0xFFE7E0D7),
          icon: Icons.star_rounded,
        ),
      ],
    ),
    CategoryData(
      name: 'Accessories',
      icon: Icons.watch_rounded,
      totalItems: 112,
      products: [
        CategoryProduct(
          id: 'acc-1',
          name: 'Classic Metal Watch',
          price: '\$4179.00',
          imageColor: Color(0xFFE8E6DE),
          icon: Icons.watch_rounded,
        ),
        CategoryProduct(
          id: 'acc-2',
          name: 'Sport Sunglasses',
          price: '\$472.00',
          imageColor: Color(0xFFDDE4EE),
          icon: Icons.visibility_rounded,
        ),
      ],
    ),
    CategoryData(
      name: 'Shorts',
      icon: Icons.dry_cleaning_rounded,
      totalItems: 87,
      products: [
        CategoryProduct(
          id: 'shorts-1',
          name: 'Court Dri-FIT Shorts',
          price: '\$468.00',
          imageColor: Color(0xFFDCE6D8),
          icon: Icons.dry_cleaning_rounded,
        ),
        CategoryProduct(
          id: 'shorts-2',
          name: 'Run Division Shorts',
          price: '\$478.00',
          imageColor: Color(0xFFE0E4EC),
          icon: Icons.directions_run_rounded,
        ),
      ],
    ),
    CategoryData(
      name: 'Shoes',
      icon: Icons.directions_walk_rounded,
      totalItems: 196,
      products: [
        CategoryProduct(
          id: 'shoes-1',
          name: 'Air Runner 270',
          price: '\$4160.00',
          imageColor: Color(0xFFDCE1EA),
          icon: Icons.directions_walk_rounded,
        ),
        CategoryProduct(
          id: 'shoes-2',
          name: 'Street Trainer Lite',
          price: '\$4119.00',
          imageColor: Color(0xFFE7E0D8),
          icon: Icons.sports_martial_arts_rounded,
        ),
      ],
    ),
    CategoryData(
      name: 'Bags',
      icon: Icons.shopping_bag_rounded,
      totalItems: 64,
      products: [
        CategoryProduct(
          id: 'bag-1',
          name: 'Essential Duffel Bag',
          price: '\$488.00',
          imageColor: Color(0xFFE5DDD3),
          icon: Icons.shopping_bag_rounded,
        ),
        CategoryProduct(
          id: 'bag-2',
          name: 'Everyday Backpack',
          price: '\$499.00',
          imageColor: Color(0xFFDDE8E4),
          icon: Icons.backpack_rounded,
        ),
      ],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _applyCategoryFromArgs(Get.arguments);
  }

  void openCategory(CategoryData category) {
    selectedCategory.value = category;
  }

  void openCategoryByName(String categoryName) {
    final normalizedInput = _normalizeCategoryName(categoryName);

    for (final category in categories) {
      if (_normalizeCategoryName(category.name) == normalizedInput) {
        selectedCategory.value = category;
        return;
      }
    }
  }

  void clearSelectedCategory() {
    selectedCategory.value = null;
  }

  void toggleWishlist(String productId) {
    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
    } else {
      wishlist.add(productId);
    }
  }

  bool isWishlisted(String productId) => wishlist.contains(productId);

  void _applyCategoryFromArgs(dynamic arguments) {
    if (arguments is String) {
      openCategoryByName(arguments);
      return;
    }

    if (arguments is Map && arguments['category'] is String) {
      openCategoryByName(arguments['category'] as String);
    }
  }

  String _normalizeCategoryName(String value) {
    final lower = value.trim().toLowerCase();
    if (lower == 'bag') return 'bags';
    return lower;
  }
}
