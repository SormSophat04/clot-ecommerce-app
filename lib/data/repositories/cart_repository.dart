import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../models/cart_model.dart';
import '../sources/local/storage_service.dart';

class CartRepository extends GetxService {
  CartRepository(this._apiClient, this._storageService);

  final ApiClient _apiClient;
  final StorageService _storageService;

  /// Get all cart items for current user.
  Future<List<CartItemModel>> getCartItems() async {
    final userId = await _resolveUserId();
    final response = await _apiClient.get(ApiConstants.userCart(userId));

    if (response.statusCode == 200) {
      final payload = _extractListPayload(response.data);
      return payload
          .map((item) => CartItemModel.fromJson(_asMap(item)))
          .toList();
    }

    throw Exception('Failed to fetch cart items');
  }

  /// Add item to cart.
  Future<CartItemModel> addToCart({
    required String productId,
    required int quantity,
  }) async {
    final userId = await _resolveUserId();
    final parsedProductId = int.tryParse(productId.trim());
    if (parsedProductId == null) {
      throw Exception('Invalid product id');
    }

    final response = await _apiClient.post(
      ApiConstants.userCart(userId),
      const <String, String>{},
      data: <String, dynamic>{
        'productId': parsedProductId,
        'quantity': quantity.clamp(1, 99).toInt(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CartItemModel.fromJson(_extractItemPayload(response.data));
    }

    throw Exception('Failed to add product to cart');
  }

  /// Update existing cart item quantity.
  Future<CartItemModel> updateCartItem({
    required String productId,
    required int quantity,
  }) async {
    final userId = await _resolveUserId();
    final parsedProductId = int.tryParse(productId.trim());
    if (parsedProductId == null) {
      throw Exception('Invalid product id');
    }

    final response = await _apiClient.put(
      ApiConstants.userCartItem(userId, productId),
      data: <String, dynamic>{
        'productId': parsedProductId,
        'quantity': quantity.clamp(1, 99).toInt(),
      },
    );

    if (response.statusCode == 200) {
      return CartItemModel.fromJson(_extractItemPayload(response.data));
    }

    throw Exception('Failed to update cart item');
  }

  /// Remove item from cart by product id.
  Future<void> removeFromCart(String productId) async {
    final userId = await _resolveUserId();
    final response = await _apiClient.delete(
      ApiConstants.userCartItem(userId, productId),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw Exception('Failed to remove item from cart');
  }

  /// Clear current user's cart.
  Future<void> clearCart() async {
    final userId = await _resolveUserId();
    final response = await _apiClient.delete(ApiConstants.userCart(userId));

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw Exception('Failed to clear cart');
  }

  /// Get cart item count.
  Future<int> getCartItemCount() async {
    final userId = await _resolveUserId();
    final response = await _apiClient.get(ApiConstants.userCartCount(userId));

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is num) {
        return data.toInt();
      }
      if (data is String) {
        return int.tryParse(data) ?? 0;
      }
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final nested = map['data'];
        if (nested is num) return nested.toInt();
        if (nested is String) return int.tryParse(nested) ?? 0;
      }
      return 0;
    }

    throw Exception('Failed to fetch cart item count');
  }

  Future<String> _resolveUserId() async {
    final cachedUserId = _extractUserId(_storageService.userData);
    if (cachedUserId != null) {
      return cachedUserId;
    }

    final response = await _apiClient.get(ApiConstants.currentUser);
    if (response.statusCode != 200) {
      throw Exception('Unable to resolve current user. Please sign in again.');
    }

    final userPayload = _extractCurrentUserPayload(response.data);
    final resolvedUserId = _extractUserId(userPayload);
    if (resolvedUserId == null) {
      throw Exception('Unable to resolve current user. Please sign in again.');
    }

    final existing = _storageService.userData ?? <String, dynamic>{};
    await _storageService.saveUserData(<String, dynamic>{
      ...existing,
      ...userPayload,
    });
    return resolvedUserId;
  }

  Map<String, dynamic> _extractCurrentUserPayload(dynamic data) {
    final map = _asMap(data);
    final nestedData = map['data'];
    if (nestedData is Map) {
      return Map<String, dynamic>.from(nestedData);
    }

    final nestedUser = map['user'];
    if (nestedUser is Map) {
      return Map<String, dynamic>.from(nestedUser);
    }

    return map;
  }

  String? _extractUserId(Map<String, dynamic>? source) {
    if (source == null || source.isEmpty) return null;

    final direct = _extractUserIdFromMap(source);
    if (direct != null) return direct;

    final nestedUser = source['user'];
    if (nestedUser is Map) {
      return _extractUserIdFromMap(Map<String, dynamic>.from(nestedUser));
    }

    final nestedData = source['data'];
    if (nestedData is Map) {
      return _extractUserIdFromMap(Map<String, dynamic>.from(nestedData));
    }

    return null;
  }

  String? _extractUserIdFromMap(Map<String, dynamic> source) {
    final dynamic rawUserId =
        source['userId'] ?? source['id'] ?? source['user_id'];
    if (rawUserId == null) return null;

    final candidate = rawUserId.toString().trim();
    if (candidate.isEmpty) return null;
    return candidate;
  }

  Map<String, dynamic> _extractItemPayload(dynamic data) {
    final map = _asMap(data);
    if (map.isEmpty) return map;

    final nestedData = map['data'];
    if (nestedData is Map) {
      return Map<String, dynamic>.from(nestedData);
    }

    final nestedItem = map['item'];
    if (nestedItem is Map) {
      return Map<String, dynamic>.from(nestedItem);
    }

    return map;
  }

  List<dynamic> _extractListPayload(dynamic data) {
    if (data is List) return data;
    final map = _asMap(data);
    if (map.isEmpty) return const <dynamic>[];

    final nestedData = map['data'];
    if (nestedData is List) {
      return nestedData;
    }

    final nestedItems = map['items'];
    if (nestedItems is List) {
      return nestedItems;
    }

    final nestedCart = map['cart'];
    if (nestedCart is Map && nestedCart['items'] is List) {
      return nestedCart['items'] as List;
    }

    return const <dynamic>[];
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }
}
