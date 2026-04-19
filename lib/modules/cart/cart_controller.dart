import 'dart:async';

import 'package:clot_ecommerce_app/data/models/cart_model.dart' as cart_model;
import 'package:clot_ecommerce_app/data/models/product_model.dart';
import 'package:clot_ecommerce_app/data/repositories/cart_repository.dart';
import 'package:clot_ecommerce_app/data/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  CartController({
    CartRepository? cartRepository,
    ProductRepository? productRepository,
  }) : _cartRepository = cartRepository ?? Get.find<CartRepository>(),
       _productRepository = productRepository ?? Get.find<ProductRepository>();

  final CartRepository _cartRepository;
  final ProductRepository _productRepository;

  final RxList<cart_model.CartItemModel> cartItems =
      <cart_model.CartItemModel>[].obs;
  final RxSet<String> _busyProductIds = <String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isClearing = false.obs;
  final RxString errorMessage = ''.obs;

  final RxDouble shippingCost = 8.0.obs;
  final RxDouble taxRate = 0.0.obs;

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * taxRate.value;

  double get total {
    if (cartItems.isEmpty) return 0.0;
    return subtotal + tax + shippingCost.value;
  }

  bool isItemBusy(cart_model.CartItemModel item) =>
      _busyProductIds.contains(item.product.id);

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final items = await _cartRepository.getCartItems();
      cartItems.assignAll(items);
      unawaited(_hydrateCartItemImages(items));
    } catch (error) {
      errorMessage.value = _buildErrorMessage(
        error,
        fallback: 'Failed to load your cart.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCart() => fetchCart();

  Future<void> updateQuantity(cart_model.CartItemModel item, int delta) async {
    final productId = item.product.id.trim();
    if (productId.isEmpty) {
      return;
    }
    if (_busyProductIds.contains(productId) || isClearing.value) {
      return;
    }

    final newQuantity = item.quantity + delta;
    _busyProductIds.add(productId);
    try {
      if (newQuantity <= 0) {
        await _cartRepository.removeFromCart(productId);
        _removeLocalItemByProductId(productId);
      } else {
        final updated = await _cartRepository.updateCartItem(
          productId: productId,
          quantity: newQuantity,
        );
        _upsertLocalItem(updated);
      }
    } catch (error) {
      // Error handled silently or via state
    } finally {
      _busyProductIds.remove(productId);
    }
  }

  Future<void> removeItem(cart_model.CartItemModel item) async {
    final productId = item.product.id.trim();
    if (productId.isEmpty) {
      return;
    }
    if (_busyProductIds.contains(productId) || isClearing.value) {
      return;
    }

    _busyProductIds.add(productId);
    try {
      await _cartRepository.removeFromCart(productId);
      _removeLocalItemByProductId(productId);
    } catch (error) {
      // Error handled silently or via state
    } finally {
      _busyProductIds.remove(productId);
    }
  }

  Future<void> removeAll() async {
    if (cartItems.isEmpty || isClearing.value) {
      return;
    }

    isClearing.value = true;
    try {
      await _cartRepository.clearCart();
      cartItems.clear();
    } catch (error) {
      // Error handled silently or via state
    } finally {
      isClearing.value = false;
    }
  }

  void _upsertLocalItem(cart_model.CartItemModel item) {
    final index = _indexOfProductId(item.product.id);
    if (index == -1) {
      cartItems.add(item);
      unawaited(_hydrateCartItemImages(cartItems.toList()));
      return;
    }
    final existing = cartItems[index];
    final merged = _mergeImageIfMissing(incoming: item, existing: existing);
    cartItems[index] = merged;
    unawaited(_hydrateCartItemImages(cartItems.toList()));
  }

  void _removeLocalItemByProductId(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  int _indexOfProductId(String productId) {
    return cartItems.indexWhere((item) => item.product.id == productId);
  }

  Future<void> _hydrateCartItemImages(
    List<cart_model.CartItemModel> snapshot,
  ) async {
    if (snapshot.isEmpty) return;

    final missingImages = snapshot.where((item) => !_hasImage(item)).toList();
    if (missingImages.isEmpty) return;

    try {
      final hydratedProducts = await _productRepository.hydrateFirstImages(
        snapshot.map((item) => item.product).toList(),
        maxProducts: snapshot.length,
      );

      if (hydratedProducts.isEmpty) {
        return;
      }

      final productById = <String, ProductModel>{
        for (final product in hydratedProducts)
          if (product.id.trim().isNotEmpty) product.id: product,
      };
      if (productById.isEmpty) return;

      final updatedItems = cartItems.map((item) {
        final hydrated = productById[item.product.id];
        if (hydrated == null) return item;
        return item.copyWith(product: hydrated);
      }).toList();
      cartItems.assignAll(updatedItems);
    } catch (_) {
      // Keep cart visible even if image hydration fails.
    }
  }

  bool _hasImage(cart_model.CartItemModel item) {
    final value = item.product.image?.trim();
    return value != null && value.isNotEmpty;
  }

  cart_model.CartItemModel _mergeImageIfMissing({
    required cart_model.CartItemModel incoming,
    required cart_model.CartItemModel existing,
  }) {
    final hasIncomingImage = _hasImage(incoming);
    final existingImage = existing.product.image?.trim();
    if (hasIncomingImage || existingImage == null || existingImage.isEmpty) {
      return incoming;
    }

    return incoming.copyWith(
      product: incoming.product.copyWith(
        image: existing.product.image,
        images: existing.product.images,
      ),
    );
  }


  String _buildErrorMessage(Object error, {required String fallback}) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        return 'Please sign in again to continue.';
      }
      if (statusCode == 404) {
        return 'Cart item not found.';
      }
      if (statusCode == 409) {
        return 'Cart is out of sync. Please refresh.';
      }

      final serverMessage = _extractServerMessage(error.response?.data);
      if (serverMessage != null && serverMessage.isNotEmpty) {
        return serverMessage;
      }
    }

    final raw = error.toString().trim();
    if (raw.isNotEmpty && raw.toLowerCase() != 'exception') {
      return raw.replaceFirst('Exception: ', '');
    }
    return fallback;
  }

  String? _extractServerMessage(dynamic data) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final message =
          map['message'] ??
          map['error'] ??
          (map['data'] is Map ? (map['data'] as Map)['message'] : null);
      if (message == null) return null;
      final text = message.toString().trim();
      return text.isEmpty ? null : text;
    }

    if (data is String) {
      final text = data.trim();
      return text.isEmpty ? null : text;
    }
    return null;
  }
}
