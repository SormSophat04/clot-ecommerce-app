import 'package:get/get.dart';

import 'auth_controller.dart';

const String authControllerTag = 'auth_controller';

class AuthBinding extends Bindings {
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
