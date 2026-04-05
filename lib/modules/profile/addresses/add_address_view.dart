import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Address')),
      body: const Center(
        child: Text('Add Address View - To be implemented'),
      ),
    );
  }
}

class AddAddressBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AddAddressController>(() => AddAddressController());
  }
}
