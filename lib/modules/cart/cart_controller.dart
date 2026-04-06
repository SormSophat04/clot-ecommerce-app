import 'package:get/get.dart';

class CartItemModel {
  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.color,
    required this.assetPath,
    this.quantity = 1,
  });

  final String id;
  final String name;
  final double price;
  final String size;
  final String color;
  final String assetPath;
  int quantity;
}

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[
    CartItemModel(
      id: '1',
      name: "Men's Harrington Jacket",
      price: 148.0,
      size: 'M',
      color: 'Lemon',
      assetPath: 'assets/images/jacket_lemon.png', // Fallback path
    ),
    CartItemModel(
      id: '2',
      name: "Men's Coaches Jacket",
      price: 52.0,
      size: 'M',
      color: 'Black',
      assetPath: 'assets/images/jacket_black.png', // Fallback path
    ),
  ].obs;

  final RxDouble shippingCost = 8.0.obs;
  final RxDouble taxRate = 0.0.obs; // e.g. 0.0 for 0%

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get tax => subtotal * taxRate.value;

  double get total {
    if (cartItems.isEmpty) return 0.0;
    return subtotal + tax + shippingCost.value;
  }

  void updateQuantity(String id, int delta) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = cartItems[index];
      final newQuantity = item.quantity + delta;
      
      if (newQuantity <= 0) {
        cartItems.removeAt(index);
      } else {
        item.quantity = newQuantity;
        cartItems[index] = item; // Trigger rx update
      }
    }
  }

  void removeAll() {
    cartItems.clear();
  }
}