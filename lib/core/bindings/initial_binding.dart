import 'package:get/get.dart';
import 'package:clot_ecommerce_app/core/network/api_client.dart';
import 'package:clot_ecommerce_app/data/repositories/category_repository.dart';
import 'package:clot_ecommerce_app/data/repositories/auth_repository.dart';
import 'package:clot_ecommerce_app/data/repositories/cart_repository.dart';
import 'package:clot_ecommerce_app/data/repositories/product_repository.dart';
import 'package:clot_ecommerce_app/data/sources/local/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    }
    final apiClient = Get.find<ApiClient>();

    if (Get.isRegistered<StorageService>()) {
      final cachedToken = Get.find<StorageService>().token;
      if (cachedToken != null && cachedToken.trim().isNotEmpty) {
        apiClient.setToken(cachedToken.trim());
      }
    }

    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    }

    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRepository>(
        () => ProductRepository(Get.find<ApiClient>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<CategoryRepository>()) {
      Get.lazyPut<CategoryRepository>(
        () => CategoryRepository(Get.find<ApiClient>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<CartRepository>()) {
      Get.lazyPut<CartRepository>(
        () => CartRepository(Get.find<ApiClient>(), Get.find<StorageService>()),
        fenix: true,
      );
    }
  }
}
