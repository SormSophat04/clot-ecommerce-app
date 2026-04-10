import 'dart:async';

import 'package:clot_ecommerce_app/data/models/product_model.dart';
import 'package:clot_ecommerce_app/data/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  ProductController({ProductRepository? productRepository})
    : _productRepository = productRepository ?? Get.find<ProductRepository>();

  final ProductRepository _productRepository;

  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxSet<String> wishlist = <String>{}.obs;
  final RxString selectedCategory = ''.obs;

  final ScrollController scrollController = ScrollController();

  static const int _pageSize = 20;
  int _currentPage = 0;
  bool _hasMore = true;
  int _loadGeneration = 0;
  String? _categoryIdFromArgs;

  List<ProductModel> get products {
    if (selectedCategory.value.isEmpty) {
      return allProducts;
    }

    final categoryFilter = _normalizeCategoryName(selectedCategory.value);
    return allProducts.where((product) {
      return _normalizeCategoryName(product.categoryName) == categoryFilter;
    }).toList();
  }

  bool get canLoadMore => _hasMore && !isLoading.value && !isLoadingMore.value;

  @override
  void onInit() {
    super.onInit();
    _applyArgs(Get.arguments);
    scrollController.addListener(_onScroll);
    loadProducts(reset: true);
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.onClose();
  }

  Future<void> retry() async {
    await loadProducts(reset: true);
  }

  Future<void> refreshProducts() async {
    await loadProducts(reset: true, forceClearError: true);
  }

  Future<void> loadMoreProducts() async {
    await loadProducts(reset: false, forceClearError: false);
  }

  Future<void> loadProducts({
    required bool reset,
    bool forceClearError = true,
  }) async {
    if (reset) {
      isLoading.value = true;
      _currentPage = 0;
      _hasMore = true;
      allProducts.clear();
    } else {
      if (!canLoadMore) return;
      isLoadingMore.value = true;
    }

    if (forceClearError) {
      errorMessage.value = '';
    }

    final requestGeneration = reset ? ++_loadGeneration : _loadGeneration;

    try {
      final shouldBulkFetchForCategory =
          selectedCategory.value.isNotEmpty &&
          (_categoryIdFromArgs == null || _categoryIdFromArgs!.isEmpty);
      final requestPage = shouldBulkFetchForCategory ? 0 : _currentPage;
      final requestLimit = shouldBulkFetchForCategory ? 200 : _pageSize;

      final fetchedProducts = await _productRepository.getProducts(
        page: requestPage,
        limit: requestLimit,
        categoryId: _categoryIdFromArgs,
        includeFirstImage: false,
      );

      List<ProductModel> productsToHydrate = <ProductModel>[];
      if (reset) {
        allProducts.assignAll(fetchedProducts);
        productsToHydrate = fetchedProducts;
      } else {
        final existingIds = allProducts.map((product) => product.id).toSet();
        final newProducts = fetchedProducts
            .where((product) => !existingIds.contains(product.id))
            .toList();
        allProducts.addAll(newProducts);
        productsToHydrate = newProducts;
      }

      if (productsToHydrate.isNotEmpty) {
        unawaited(
          _hydrateFirstImages(
            products: productsToHydrate,
            generation: requestGeneration,
          ),
        );
      }

      if (shouldBulkFetchForCategory) {
        _hasMore = false;
      } else if (_categoryIdFromArgs != null &&
          _categoryIdFromArgs!.isNotEmpty) {
        _hasMore = false;
      } else if (fetchedProducts.length < requestLimit) {
        _hasMore = false;
      } else {
        _currentPage++;
      }
    } catch (error) {
      errorMessage.value = _buildLoadErrorMessage(error);
    } finally {
      if (reset) {
        isLoading.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> _hydrateFirstImages({
    required List<ProductModel> products,
    required int generation,
  }) async {
    if (products.isEmpty) return;

    final hydratedProducts = await _productRepository.hydrateFirstImages(
      products,
    );
    if (generation != _loadGeneration || hydratedProducts.isEmpty) {
      return;
    }

    final updatesById = <String, ProductModel>{};
    for (final product in hydratedProducts) {
      final image = product.image?.trim();
      if (image == null || image.isEmpty) continue;
      updatesById[product.id] = product;
    }

    if (updatesById.isEmpty) return;

    final merged = allProducts
        .map((existing) => updatesById[existing.id] ?? existing)
        .toList();
    allProducts.assignAll(merged);
  }

  void toggleWishlist(String productId) {
    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
      return;
    }
    wishlist.add(productId);
  }

  bool isWishlisted(String productId) => wishlist.contains(productId);

  void _applyArgs(dynamic arguments) {
    if (arguments is String) {
      selectedCategory.value = arguments.trim();
      return;
    }

    if (arguments is Map) {
      final categoryName =
          arguments['category'] ??
          arguments['categoryName'] ??
          arguments['name'];
      if (categoryName is String && categoryName.trim().isNotEmpty) {
        selectedCategory.value = categoryName.trim();
      }

      final categoryId = arguments['categoryId'] ?? arguments['id'];
      if (categoryId != null) {
        _categoryIdFromArgs = categoryId.toString().trim();
      }
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients || !canLoadMore) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (currentScroll >= (maxScroll - 220)) {
      loadMoreProducts();
    }
  }

  String _normalizeCategoryName(String categoryName) {
    final normalized = categoryName.trim().toLowerCase();
    if (normalized == 'bag') return 'bags';
    return normalized;
  }

  String _buildLoadErrorMessage(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        return 'Unauthorized. Please sign in again.';
      }
      if (statusCode == 403) {
        return 'You do not have permission to view products.';
      }
      if (statusCode == 404) {
        return 'Products endpoint was not found.';
      }
      return 'Network error (${statusCode ?? 'unknown'}). Pull to retry.';
    }
    return 'Failed to load products. Pull to retry.';
  }
}
