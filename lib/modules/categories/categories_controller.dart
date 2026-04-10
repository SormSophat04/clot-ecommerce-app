import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/data/models/category_model.dart';
import 'package:clot_ecommerce_app/data/repositories/category_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  CategoriesController({CategoryRepository? categoryRepository})
    : _categoryRepository =
          categoryRepository ?? Get.find<CategoryRepository>();

  final CategoryRepository _categoryRepository;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetchedCategories = await _categoryRepository.getCategories();
      categories.assignAll(fetchedCategories);
    } catch (error) {
      categories.clear();
      errorMessage.value = _buildErrorMessage(error);
    } finally {
      isLoading.value = false;
    }
  }

  void openCategory(CategoryModel category) {
    Get.toNamed(
      Routes.product,
      arguments: <String, dynamic>{
        'categoryId': category.id,
        'category': category.name,
      },
    );
  }

  String _buildErrorMessage(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        return 'Unauthorized. Please sign in again.';
      }
      if (statusCode == 403) {
        return 'You do not have permission to view categories.';
      }
      return 'Failed to load categories (${statusCode ?? 'network'}).';
    }
    return 'Failed to load categories.';
  }
}
