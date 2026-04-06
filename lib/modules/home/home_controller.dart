import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class CategoryItem {
  const CategoryItem({required this.label, required this.color});
  final String label;
  final Color color;
}

class ProductItem {
  const ProductItem({
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imageColor,
  });
  final String name;
  final String price;
  final String? oldPrice;
  final Color imageColor;
}

// ---------------------------------------------------------------------------
// HomeController
// ---------------------------------------------------------------------------

class HomeController extends GetxController {
  // ── Gender filter ────────────────────────────────────────────────────────
  final selectedGender = 'Men'.obs;

  // ── Wishlist set (stores product names) ─────────────────────────────────
  final RxSet<String> wishlist = <String>{}.obs;

  void toggleWishlist(String productName) {
    if (wishlist.contains(productName)) {
      wishlist.remove(productName);
    } else {
      wishlist.add(productName);
    }
  }

  bool isWishlisted(String productName) => wishlist.contains(productName);

  // ── Static data ──────────────────────────────────────────────────────────
  final List<CategoryItem> categories = const [
    CategoryItem(label: 'Hoodies', color: Color(0xFFD4C5F9)),
    CategoryItem(label: 'Shorts', color: Color(0xFFC5E8C1)),
    CategoryItem(label: 'Shoes', color: Color(0xFFC5DCF9)),
    CategoryItem(label: 'Bag', color: Color(0xFFF9DFC5)),
    CategoryItem(label: 'Accessories', color: Color(0xFFF9C5D4)),
  ];

  final List<ProductItem> topSelling = const [
    ProductItem(
      name: "Men's Harrington Jacket",
      price: '\$148.00',
      imageColor: Color(0xFFB8D8C8),
    ),
    ProductItem(
      name: "Max Cirro Men's Slides",
      price: '\$55.00',
      oldPrice: '\$100.97',
      imageColor: Color(0xFFD0D8E8),
    ),
    ProductItem(
      name: 'Nike Sportswear Club',
      price: '\$45.00',
      imageColor: Color(0xFFE8D8C8),
    ),
  ];

  final List<ProductItem> newIn = const [
    ProductItem(
      name: 'Nike Club Fleece',
      price: '\$55.00',
      imageColor: Color(0xFFD8C8E8),
    ),
    ProductItem(
      name: 'Nike Air Max 270',
      price: '\$160.00',
      oldPrice: '\$200.00',
      imageColor: Color(0xFFC8E8D8),
    ),
    ProductItem(
      name: 'Jordan Flight MVP',
      price: '\$90.00',
      imageColor: Color(0xFFE8C8C8),
    ),
  ];
}