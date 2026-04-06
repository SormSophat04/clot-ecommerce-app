import 'package:get/get.dart';
import 'package:clot_ecommerce_app/modules/categories/categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoriesController>(() => CategoriesController());
  }
}
