import 'package:clot_ecommerce_app/data/models/product_model.dart';
import 'package:clot_ecommerce_app/data/repositories/cart_repository.dart';
import 'package:clot_ecommerce_app/data/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorChoice {
  const ColorChoice({required this.name, required this.color});

  final String name;
  final Color color;
}

class ProductDetailsController extends GetxController {
  ProductDetailsController({
    ProductRepository? productRepository,
    CartRepository? cartRepository,
  }) : _productRepository = productRepository ?? Get.find<ProductRepository>(),
       _cartRepository = cartRepository ?? Get.find<CartRepository>();

  final ProductRepository _productRepository;
  final CartRepository _cartRepository;

  static const List<String> _defaultSizes = <String>[
    'S',
    'M',
    'L',
    'XL',
    '2XL',
  ];
  static const List<ColorChoice> _defaultColorOptions = <ColorChoice>[
    ColorChoice(name: 'Orange', color: Color(0xFFE28A3A)),
    ColorChoice(name: 'Black', color: Color(0xFF24252A)),
    ColorChoice(name: 'Red', color: Color(0xFFE74E3D)),
    ColorChoice(name: 'Yellow', color: Color(0xFFE0B63D)),
    ColorChoice(name: 'Blue', color: Color(0xFF4D64E5)),
  ];

  static const List<Color> fallbackGalleryColors = <Color>[
    Color(0xFFB8C49D),
    Color(0xFFA3B183),
    Color(0xFF9BAE7C),
  ];

  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final RxList<String> galleryImages = <String>[].obs;
  final RxList<String> sizes = <String>[].obs;
  final RxList<ColorChoice> colorOptions = <ColorChoice>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedSize = ''.obs;
  final RxInt selectedColorIndex = 0.obs;
  final RxInt quantity = 1.obs;
  final RxBool isWishlisted = false.obs;
  final RxBool isAddingToBag = false.obs;

  String? _productId;

  String get productName => product.value?.name ?? 'Product';

  String get priceLabel => _formatPrice(product.value?.finalPrice ?? 0);

  String? get oldPriceLabel {
    if (product.value?.onSale != true) return null;
    return _formatPrice(product.value?.price ?? 0);
  }

  String get description {
    final trimmed = product.value?.description.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'Product description is not available.';
    }
    return trimmed;
  }

  List<String> get displayGalleryImages {
    if (galleryImages.isNotEmpty) {
      return galleryImages.toList();
    }

    final value = product.value;
    if (value == null) {
      return const <String>[];
    }

    final images = <String>[];
    final cover = value.image?.trim();
    if (cover != null && cover.isNotEmpty) {
      images.add(cover);
    }

    for (final image in value.images ?? const <String>[]) {
      final normalized = image.trim();
      if (normalized.isNotEmpty && !images.contains(normalized)) {
        images.add(normalized);
      }
    }

    return images;
  }

  @override
  void onInit() {
    super.onInit();
    _resolveArguments(Get.arguments);
    loadProduct();
  }

  Future<void> retry() async {
    await loadProduct(forceRefresh: true);
  }

  Future<void> loadProduct({bool forceRefresh = false}) async {
    if (_productId == null && product.value == null) {
      errorMessage.value = 'Product information is missing.';
      return;
    }

    if (product.value != null && !forceRefresh) {
      _applyProductState(product.value!);
      if (_productId != null && _productId!.isNotEmpty) {
        await _loadProductImages(_productId!);
      }
      return;
    }

    final productId = _productId ?? _toBackendProductId(product.value?.id);
    if (productId == null || productId.isEmpty) {
      if (product.value != null) {
        _applyProductState(product.value!);
        return;
      }
      errorMessage.value = 'Unable to identify this product.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetchedProduct = await _productRepository.getProductById(productId);
      _productId = fetchedProduct.id;
      _applyProductState(fetchedProduct);
      await _loadProductImages(fetchedProduct.id);
    } catch (_) {
      errorMessage.value = 'Failed to load product details.';
    } finally {
      isLoading.value = false;
    }
  }

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
    if (index < 0 || index >= colorOptions.length) return;
    selectedColorIndex.value = index;
  }

  Future<void> addToBag() async {
    if (isAddingToBag.value) return;

    final productId = _productId ?? _toBackendProductId(product.value?.id);
    if (productId == null || productId.isEmpty) {
      return;
    }

    isAddingToBag.value = true;
    try {
      final qty = quantity.value.clamp(1, 99).toInt();
      await _cartRepository.addToCart(productId: productId, quantity: qty);
    } catch (error) {
      // Error handled silently or via state
    } finally {
      isAddingToBag.value = false;
    }
  }

  Future<void> _loadProductImages(String productId) async {
    try {
      final images = await _productRepository.getProductImages(productId);
      final normalized = images
          .map((image) => 'data:${image.mimeType};base64,${image.base64Data}')
          .toList();
      galleryImages.assignAll(normalized);
    } catch (_) {
      galleryImages.clear();
    }
  }

  void _resolveArguments(dynamic arguments) {
    if (arguments is ProductModel) {
      product.value = arguments;
      _productId = _toBackendProductId(arguments.id);
      return;
    }

    if (arguments is String) {
      _productId = _toBackendProductId(arguments);
      return;
    }

    if (arguments is num) {
      _productId = arguments.toString();
      return;
    }

    if (arguments is Map) {
      final nestedProduct = arguments['product'];
      if (nestedProduct is ProductModel) {
        product.value = nestedProduct;
        _productId = _toBackendProductId(nestedProduct.id);
      } else if (nestedProduct is Map) {
        final parsed = ProductModel.fromJson(
          Map<String, dynamic>.from(nestedProduct),
        );
        product.value = parsed;
        _productId = _toBackendProductId(parsed.id);
      }

      final productId =
          arguments['productId'] ?? arguments['id'] ?? arguments['product_id'];
      if (productId != null) {
        final parsedId = _toBackendProductId(productId);
        if (parsedId != null) {
          _productId = parsedId;
        }
      }
    }
  }

  String? _toBackendProductId(dynamic value) {
    if (value == null) return null;
    final candidate = value.toString().trim();
    if (candidate.isEmpty) return null;
    return int.tryParse(candidate) != null ? candidate : null;
  }

  void _applyProductState(ProductModel value) {
    product.value = value;

    final parsedSizes = value.availableSizes
        .where((size) => size.isNotEmpty)
        .toList();
    sizes.assignAll(parsedSizes.isEmpty ? _defaultSizes : parsedSizes);

    final parsedColors = value.availableColors
        .where((color) => color.isNotEmpty)
        .map(
          (colorName) =>
              ColorChoice(name: colorName, color: _colorFromName(colorName)),
        )
        .toList();
    colorOptions.assignAll(
      parsedColors.isEmpty ? _defaultColorOptions : parsedColors,
    );

    if (!sizes.contains(selectedSize.value)) {
      selectedSize.value = sizes.first;
    }

    if (selectedColorIndex.value >= colorOptions.length) {
      selectedColorIndex.value = 0;
    }
  }

  Color _colorFromName(String colorName) {
    switch (colorName.trim().toLowerCase()) {
      case 'black':
        return const Color(0xFF24252A);
      case 'white':
        return const Color(0xFFF1F1F1);
      case 'red':
        return const Color(0xFFE74E3D);
      case 'blue':
        return const Color(0xFF4D64E5);
      case 'green':
        return const Color(0xFF44A86A);
      case 'yellow':
        return const Color(0xFFE0B63D);
      case 'orange':
        return const Color(0xFFE28A3A);
      case 'brown':
        return const Color(0xFF8A6239);
      case 'gray':
      case 'grey':
        return const Color(0xFF8B8B90);
      default:
        return _stableFallbackColor(colorName);
    }
  }

  Color _stableFallbackColor(String seed) {
    const palette = <Color>[
      Color(0xFF8093F1),
      Color(0xFFF4A259),
      Color(0xFF70A288),
      Color(0xFFC8553D),
      Color(0xFF6B4E71),
      Color(0xFF6CA6C1),
    ];
    final hash = seed.codeUnits.fold<int>(0, (sum, char) => sum + char);
    return palette[hash % palette.length];
  }

  String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';


}
