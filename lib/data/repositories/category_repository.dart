import 'package:clot_ecommerce_app/core/network/api_client.dart';
import 'package:clot_ecommerce_app/core/network/api_constants.dart';
import 'package:clot_ecommerce_app/data/models/category_model.dart';
import 'package:get/get.dart';

class CategoryRepository extends GetxService {
  CategoryRepository(this._apiClient);

  final ApiClient _apiClient;

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }

  List<dynamic> _extractListPayload(
    dynamic data, {
    List<String> preferredKeys = const <String>[],
  }) {
    if (data is List) return data;

    final root = _asMap(data);
    for (final key in preferredKeys) {
      final value = root[key];
      if (value is List) {
        return value;
      }
    }

    final nestedData = root['data'];
    if (nestedData is List) {
      return nestedData;
    }

    return const <dynamic>[];
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.categories);

    if (response.statusCode == 200) {
      final categoriesJson = _extractListPayload(
        response.data,
        preferredKeys: const <String>['categories'],
      );

      return categoriesJson
          .map((json) => CategoryModel.fromJson(_asMap(json)))
          .toList();
    }

    throw Exception('Failed to fetch categories');
  }
}
