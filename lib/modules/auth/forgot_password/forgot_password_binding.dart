import 'package:get/get.dart';
import '../auth_controller/auth_binding.dart';
import '../auth_controller/auth_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>(tag: authControllerTag)) {
      Get.lazyPut<AuthController>(
        () => AuthController(),
        tag: authControllerTag,
        fenix: true,
      );
    }
  }
}
