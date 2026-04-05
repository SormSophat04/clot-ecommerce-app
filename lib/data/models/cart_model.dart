import 'product_model.dart';

class CartModel {
  final String id;
  final List<CartItemModel> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;

  CartModel({
    required this.id,
    required this.items,
    this.subtotal = 0,
    this.shipping = 0,
    this.tax = 0,
    this.total = 0,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List?)
            ?.map((item) => CartItemModel.fromJson(item))
            .toList() ??
        [];

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + (item.product.finalPrice * item.quantity),
    );

    return CartModel(
      id: json['id']?.toString() ?? '',
      items: items,
      subtotal: subtotal,
      shipping: (json['shipping'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: subtotal + (json['shipping'] ?? 0) + (json['tax'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
    };
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;
  final String? variationId;
  final String? variationName;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    this.variationId,
    this.variationName,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      product: ProductModel.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
      variationId: json['variation_id'],
      variationName: json['variation_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'variation_id': variationId,
      'variation_name': variationName,
    };
  }

  double get totalPrice => product.finalPrice * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    String? variationId,
    String? variationName,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      variationId: variationId ?? this.variationId,
      variationName: variationName ?? this.variationName,
    );
  }
}
