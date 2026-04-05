import 'package:get/get.dart';
import '../auth_controller/auth_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    }
  }
}
