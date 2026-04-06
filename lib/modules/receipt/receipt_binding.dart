import 'package:clot_ecommerce_app/modules/receipt/receipt_controller.dart';
import 'package:get/get.dart';

class ReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptController>(() => ReceiptController());
  }
}