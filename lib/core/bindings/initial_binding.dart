import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Add global dependencies here
    // These will be available throughout the app lifecycle

    // Example:
    // Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    // Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
  }
}
