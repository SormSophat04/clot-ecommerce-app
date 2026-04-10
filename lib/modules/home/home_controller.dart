import 'dart:async';

import 'package:clot_ecommerce_app/data/models/category_model.dart';
import 'package:clot_ecommerce_app/data/models/product_model.dart';
import 'package:clot_ecommerce_app/data/repositories/category_repository.dart';
import 'package:clot_ecommerce_app/data/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.label,
    required this.color,
    this.image,
  });

  final String id;
  final String label;
  final Color color;
  final String? image;
}

class HomeController extends GetxController {
  HomeController({
    ProductRepository? productRepository,
    CategoryRepository? categoryRepository,
  }) : _productRepository = productRepository ?? Get.find<ProductRepository>(),
       _categoryRepository =
           categoryRepository ?? Get.find<CategoryRepository>();

  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  // ── Gender filter ────────────────────────────────────────────────────────
  final selectedGender = 'Men'.obs;

  // ── Wishlist set (stores product ids) ───────────────────────────────────
  final RxSet<String> wishlist = <String>{}.obs;

  void toggleWishlist(String productId) {
    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
    } else {
      wishlist.add(productId);
    }
  }

  bool isWishlisted(String productId) => wishlist.contains(productId);

  // ── Home products state ──────────────────────────────────────────────────
  final RxList<ProductModel> topSelling = <ProductModel>[].obs;
  final RxList<ProductModel> newIn = <ProductModel>[].obs;
  final RxBool isLoadingProducts = false.obs;
  final RxString productsError = ''.obs;

  // ── Home categories state ────────────────────────────────────────────────
  final RxList<CategoryItem> categories = <CategoryItem>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString categoriesError = ''.obs;

  static const List<CategoryItem> _fallbackCategories = <CategoryItem>[
    CategoryItem(id: '', label: 'Hoodies', color: Color(0xFFD4C5F9)),
    CategoryItem(id: '', label: 'Shorts', color: Color(0xFFC5E8C1)),
    CategoryItem(id: '', label: 'Shoes', color: Color(0xFFC5DCF9)),
    CategoryItem(id: '', label: 'Bag', color: Color(0xFFF9DFC5)),
    CategoryItem(id: '', label: 'Accessories', color: Color(0xFFF9C5D4)),
  ];

  static const List<Color> _categoryColors = <Color>[
    Color(0xFFD4C5F9),
    Color(0xFFC5E8C1),
    Color(0xFFC5DCF9),
    Color(0xFFF9DFC5),
    Color(0xFFF9C5D4),
    Color(0xFFCDE6E8),
  ];

  int _homeProductsGeneration = 0;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    await Future.wait<void>(<Future<void>>[
      fetchCategories(),
      fetchHomeProducts(),
    ]);
  }

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    categoriesError.value = '';

    try {
      final apiCategories = await _categoryRepository.getCategories();
      _applyHomeCategories(apiCategories);
    } catch (error) {
      categoriesError.value = _buildCategoriesErrorMessage(error);
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchHomeProducts() async {
    final requestGeneration = ++_homeProductsGeneration;
    isLoadingProducts.value = true;
    productsError.value = '';

    try {
      final products = await _productRepository.getProducts(
        page: 0,
        limit: 20,
        includeFirstImage: false,
      );
      _applyHomeSections(products);

      final productsToHydrate = <ProductModel>[
        ...topSelling,
        ...newIn,
      ];
      if (productsToHydrate.isNotEmpty) {
        unawaited(
          _hydrateHomeSectionImages(
            products: productsToHydrate,
            generation: requestGeneration,
          ),
        );
      }
    } catch (error) {
      topSelling.clear();
      newIn.clear();
      productsError.value = _buildProductsErrorMessage(error);
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void _applyHomeCategories(List<CategoryModel> apiCategories) {
    if (apiCategories.isEmpty) {
      categories.assignAll(_fallbackCategories);
      return;
    }

    final mappedCategories = apiCategories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      return CategoryItem(
        id: category.id,
        label: category.name,
        color: _categoryColors[index % _categoryColors.length],
        image: category.image,
      );
    }).toList();

    categories.assignAll(mappedCategories);
  }

  void _applyHomeSections(List<ProductModel> products) {
    if (products.isEmpty) {
      topSelling.clear();
      newIn.clear();
      return;
    }

    final topCount = products.length >= 4 ? 4 : products.length;
    final topProducts = products.take(topCount).toList();
    final remaining = products.skip(topCount).toList();
    final newProducts = remaining.isNotEmpty
        ? remaining.take(4).toList()
        : products.reversed.take(topCount).toList();

    topSelling.assignAll(topProducts);
    newIn.assignAll(newProducts);
  }

  Future<void> _hydrateHomeSectionImages({
    required List<ProductModel> products,
    required int generation,
  }) async {
    if (products.isEmpty) return;

    final hydratedProducts = await _productRepository.hydrateFirstImages(
      products,
      maxProducts: 8,
    );
    if (generation != _homeProductsGeneration || hydratedProducts.isEmpty) {
      return;
    }

    final updatesById = <String, ProductModel>{};
    for (final product in hydratedProducts) {
      final image = product.image?.trim();
      if (image == null || image.isEmpty) continue;
      updatesById[product.id] = product;
    }

    if (updatesById.isEmpty) return;

    topSelling.assignAll(
      topSelling.map((product) => updatesById[product.id] ?? product).toList(),
    );
    newIn.assignAll(
      newIn.map((product) => updatesById[product.id] ?? product).toList(),
    );
  }

  String _buildProductsErrorMessage(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        return 'Unauthorized. Please sign in again.';
      }
      if (statusCode == 403) {
        return 'You do not have permission to view products.';
      }
      return 'Unable to load home products (${statusCode ?? 'network'}).';
    }
    return 'Unable to load home products.';
  }

  String _buildCategoriesErrorMessage(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        return 'Unauthorized. Please sign in again.';
      }
      if (statusCode == 403) {
        return 'You do not have permission to view categories.';
      }
      return 'Unable to load categories (${statusCode ?? 'network'}).';
    }
    return 'Unable to load categories.';
  }
}
