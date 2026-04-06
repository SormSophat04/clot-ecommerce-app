import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorChoice {
  const ColorChoice({required this.name, required this.color});

  final String name;
  final Color color;
}

class ProductDetailsController extends GetxController {
  // Product Data (Statics moved from View)
  static const String productName = "Men's Harrington Jacket";
  static const String priceLabel = '\$148';
  static const String description =
      'Built for life and made to last, this full-zip corduroy jacket is '
      'part of our Nike Life collection. The spacious fit gives you room '
      'to layer through every season.';

  static const List<String> sizes = <String>['S', 'M', 'L', 'XL', '2XL'];
  static const List<ColorChoice> colorOptions = <ColorChoice>[
    ColorChoice(name: 'Orange', color: Color(0xFFE28A3A)),
    ColorChoice(name: 'Black', color: Color(0xFF24252A)),
    ColorChoice(name: 'Red', color: Color(0xFFE74E3D)),
    ColorChoice(name: 'Yellow', color: Color(0xFFE0B63D)),
    ColorChoice(name: 'Blue', color: Color(0xFF4D64E5)),
  ];

  static const List<Color> galleryColors = <Color>[
    Color(0xFFB8C49D),
    Color(0xFFA3B183),
    Color(0xFF9BAE7C),
  ];

  // Observable State Variables
  final RxString selectedSize = 'S'.obs;
  final RxInt selectedColorIndex = 0.obs;
  final RxInt quantity = 1.obs;
  final RxBool isWishlisted = false.obs;

  // Methods
  void updateQuantity(int delta) {
    quantity.value = (quantity.value + delta).clamp(1, 99);
  }

  void toggleWishlist() {
    isWishlisted.toggle();
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectColor(int index) {
    selectedColorIndex.value = index;
  }

  void addToBag() {
    final qty = quantity.value;
    final itemText = qty > 1 ? 'items' : 'item';

    Get.snackbar(
      'Added to Bag',
      'Added $qty $itemText (${selectedSize.value}) to bag.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.7),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
