import '../models/cart_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';

class CartRepository {
  final ApiClient _apiClient;

  CartRepository(this._apiClient);

  /// Get cart items
  Future<CartModel> getCart() async {
    try {
      final response = await _apiClient.get(ApiConstants.cart);

      if (response.statusCode == 200) {
        return CartModel.fromJson(response.data['cart']);
      } else {
        throw Exception('Failed to fetch cart');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Add item to cart
  Future<CartModel> addToCart(String productId, int quantity, {String? variationId}) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.addToCart,
        data: {
          'product_id': productId,
          'quantity': quantity,
          if (variationId != null) 'variation_id': variationId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartModel.fromJson(response.data['cart']);
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update cart item quantity
  Future<CartModel> updateCartItem(String itemId, int quantity) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.updateCart,
        data: {
          'item_id': itemId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200) {
        return CartModel.fromJson(response.data['cart']);
      } else {
        throw Exception('Failed to update cart');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Remove item from cart
  Future<CartModel> removeFromCart(String itemId) async {
    try {
      final response = await _apiClient.delete(
        '${ApiConstants.removeFromCart}/$itemId',
      );

      if (response.statusCode == 200) {
        return CartModel.fromJson(response.data['cart']);
      } else {
        throw Exception('Failed to remove from cart');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    try {
      final response = await _apiClient.delete(ApiConstants.cart);

      if (response.statusCode != 200) {
        throw Exception('Failed to clear cart');
      }
    } catch (e) {
      rethrow;
    }
  }
}
