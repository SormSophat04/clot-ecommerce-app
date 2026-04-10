import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';

class ProductImagePayload {
  const ProductImagePayload({
    required this.id,
    required this.productId,
    required this.base64Data,
    required this.mimeType,
    required this.size,
  });

  final String id;
  final String productId;
  final String base64Data;
  final String mimeType;
  final int size;

  factory ProductImagePayload.fromJson(Map<String, dynamic> json) {
    return ProductImagePayload(
      id: (json['productImageId'] ?? json['id'] ?? '').toString(),
      productId: (json['productId'] ?? json['product_id'] ?? '').toString(),
      base64Data: (json['imageData'] ?? json['image'] ?? '').toString(),
      mimeType: (json['mimeType'] ?? json['mime_type'] ?? 'image/jpeg')
          .toString(),
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductRepository extends GetxService {
  final ApiClient _apiClient;
  final Map<String, String> _firstImageByProductId = <String, String>{};
  final Map<String, Future<String?>> _inFlightFirstImageRequests =
      <String, Future<String?>>{};

  ProductRepository(this._apiClient);

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }

  Map<String, dynamic> _extractMapPayload(
    dynamic data, {
    List<String> preferredKeys = const <String>[],
  }) {
    final root = _asMap(data);

    for (final key in preferredKeys) {
      final candidate = root[key];
      if (candidate is Map) {
        return Map<String, dynamic>.from(candidate);
      }
    }

    if (root['data'] is Map) {
      return Map<String, dynamic>.from(root['data'] as Map);
    }

    return root;
  }

  List<dynamic> _extractListPayload(
    dynamic data, {
    List<String> preferredKeys = const <String>[],
  }) {
    if (data is List) return data;

    final root = _asMap(data);

    for (final key in preferredKeys) {
      final candidate = root[key];
      if (candidate is List) {
        return candidate;
      }
    }

    final nestedData = root['data'];
    if (nestedData is List) {
      return nestedData;
    }
    if (nestedData is Map && nestedData['content'] is List) {
      return List<dynamic>.from(nestedData['content'] as List);
    }

    return const <dynamic>[];
  }

  /// Get all products with pagination
  Future<List<ProductModel>> getProducts({
    int page = 0,
    int limit = 20,
    String? categoryId,
    String? sortBy,
    bool includeFirstImage = false,
  }) async {
    final endpoint = (categoryId != null && categoryId.trim().isNotEmpty)
        ? '${ApiConstants.products}/category/$categoryId'
        : ApiConstants.products;

    final response = await _apiClient.get(
      endpoint,
      queryParameters: (categoryId != null && categoryId.trim().isNotEmpty)
          ? null
          : {
              'page': page,
              'size': limit,
              if (sortBy != null && sortBy.trim().isNotEmpty) 'sort': sortBy,
            },
    );

    if (response.statusCode == 200) {
      final productsJson = _extractListPayload(
        response.data,
        preferredKeys: const <String>['products', 'content'],
      );

      final products = productsJson
          .map((json) => ProductModel.fromJson(_asMap(json)))
          .toList();

      if (!includeFirstImage || products.isEmpty) {
        return products;
      }

      return hydrateFirstImages(products);
    }

    throw Exception('Failed to fetch products');
  }

  /// Get product by ID
  Future<ProductModel> getProductById(String productId) async {
    final response = await _apiClient.get(
      '${ApiConstants.productDetails}/$productId',
    );

    if (response.statusCode == 200) {
      final productJson = _extractMapPayload(
        response.data,
        preferredKeys: const <String>['product'],
      );
      return ProductModel.fromJson(productJson);
    }

    throw Exception('Product not found');
  }

  /// Search products
  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.search,
      queryParameters: {'name': query, 'q': query, 'page': page, 'size': limit},
    );

    if (response.statusCode == 200) {
      final productsJson = _extractListPayload(
        response.data,
        preferredKeys: const <String>['products', 'content'],
      );
      return productsJson
          .map((json) => ProductModel.fromJson(_asMap(json)))
          .toList();
    }

    throw Exception('Search failed');
  }

  /// Get product reviews
  Future<List<Map<String, dynamic>>> getProductReviews(String productId) async {
    final response = await _apiClient.get(
      ApiConstants.productReviews,
      queryParameters: {'product_id': productId},
    );

    if (response.statusCode == 200) {
      final reviews = _extractListPayload(
        response.data,
        preferredKeys: const <String>['reviews'],
      );
      return reviews
          .map((item) => _asMap(item))
          .where((item) => item.isNotEmpty)
          .toList();
    }

    throw Exception('Failed to fetch reviews');
  }

  /// Get product images for a product
  Future<List<ProductImagePayload>> getProductImages(String productId) async {
    final response = await _apiClient.get(
      '${ApiConstants.products}/$productId/images',
      options: Options(
        // Some backend deployments return 400 for products without image rows.
        // Treat it as an empty gallery instead of throwing a hard error.
        validateStatus: (status) =>
            status != null && status >= 200 && status < 500,
      ),
    );

    if (response.statusCode == 200) {
      final images = _extractListPayload(
        response.data,
        preferredKeys: const <String>['images'],
      );
      return images
          .map((item) => ProductImagePayload.fromJson(_asMap(item)))
          .where((item) => item.base64Data.isNotEmpty)
          .toList();
    }

    if (response.statusCode == 400 || response.statusCode == 404) {
      return const <ProductImagePayload>[];
    }

    throw Exception('Failed to fetch product images');
  }

  /// Toggle favorite
  Future<bool> toggleFavorite(String productId) async {
    final response = await _apiClient.post(
      '${ApiConstants.products}/$productId/toggle-favorite',
      {},
    );

    if (response.statusCode == 200) {
      return _asMap(response.data)['is_favorite'] ?? false;
    }

    throw Exception('Failed to toggle favorite');
  }

  Future<List<ProductModel>> hydrateFirstImages(
    List<ProductModel> products, {
    int maxProducts = 12,
  }) async {
    final result = List<ProductModel>.from(products);
    if (result.isEmpty || maxProducts <= 0) {
      return result;
    }

    for (var i = 0; i < result.length; i++) {
      final currentImage = result[i].image?.trim();
      if (currentImage == null || currentImage.isEmpty) {
        continue;
      }
      _firstImageByProductId[result[i].id] = currentImage;
    }

    final pendingUpdates = <Future<MapEntry<int, ProductModel>?>>[];
    for (var i = 0; i < result.length; i++) {
      final product = result[i];
      final currentImage = product.image?.trim();
      if (currentImage != null && currentImage.isNotEmpty) {
        continue;
      }

      if (product.id.isEmpty) {
        continue;
      }

      final cachedImage = _firstImageByProductId[product.id];
      if (cachedImage != null && cachedImage.isNotEmpty) {
        result[i] = product.copyWith(
          image: cachedImage,
          images: <String>[cachedImage],
        );
        continue;
      }

      pendingUpdates.add(
        _fetchAndBuildHydratedProduct(index: i, product: product),
      );

      if (pendingUpdates.length >= maxProducts) {
        break;
      }
    }

    if (pendingUpdates.isEmpty) {
      return result;
    }

    final updates = await Future.wait(pendingUpdates);

    for (final update in updates) {
      if (update == null) continue;
      result[update.key] = update.value;
    }

    return result;
  }

  Future<MapEntry<int, ProductModel>?> _fetchAndBuildHydratedProduct({
    required int index,
    required ProductModel product,
  }) async {
    final imageData = await _fetchFirstImageData(product.id);
    if (imageData == null || imageData.isEmpty) {
      return null;
    }

    return MapEntry<int, ProductModel>(
      index,
      product.copyWith(image: imageData, images: <String>[imageData]),
    );
  }

  Future<String?> _fetchFirstImageData(String productId) {
    final cached = _firstImageByProductId[productId];
    if (cached != null && cached.isNotEmpty) {
      return Future<String?>.value(cached);
    }

    final inFlight = _inFlightFirstImageRequests[productId];
    if (inFlight != null) {
      return inFlight;
    }

    final request = () async {
      try {
        final images = await getProductImages(productId);
        if (images.isEmpty) {
          return null;
        }

        final first = images.first;
        final imageData = 'data:${first.mimeType};base64,${first.base64Data}';
        _firstImageByProductId[productId] = imageData;
        return imageData;
      } catch (_) {
        return null;
      } finally {
        _inFlightFirstImageRequests.remove(productId);
      }
    }();

    _inFlightFirstImageRequests[productId] = request;
    return request;
  }
}
