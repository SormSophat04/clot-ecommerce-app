import 'package:get/get.dart';

import '../home/home_controller.dart';
import 'main_layout_controller.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainLayoutController>(() => MainLayoutController());
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
