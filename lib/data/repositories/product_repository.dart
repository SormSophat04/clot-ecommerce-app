import 'package:get/get.dart';
import '../models/product_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';

class ProductRepository extends GetxService {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  /// Get all products with pagination
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? sortBy,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.products,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (categoryId != null) 'category_id': categoryId,
          if (sortBy != null) 'sort': sortBy,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'] ?? [];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get product by ID
  Future<ProductModel> getProductById(String productId) async {
    try {
      final response = await _apiClient.get('${ApiConstants.productDetails}/$productId');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data['product']);
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Search products
  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.search,
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'] ?? [];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get product reviews
  Future<List<Map<String, dynamic>>> getProductReviews(String productId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.productReviews}',
        queryParameters: {'product_id': productId},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['reviews'] ?? []);
      } else {
        throw Exception('Failed to fetch reviews');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Toggle favorite
  Future<bool> toggleFavorite(String productId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.products}/$productId/toggle-favorite',
      );

      if (response.statusCode == 200) {
        return response.data['is_favorite'] ?? false;
      } else {
        throw Exception('Failed to toggle favorite');
      }
    } catch (e) {
      rethrow;
    }
  }
}
