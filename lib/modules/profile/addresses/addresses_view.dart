import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressesView extends StatelessWidget {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/add-address'),
          ),
        ],
      ),
      body: const Center(
        child: Text('Addresses View - To be implemented'),
      ),
    );
  }
}

class AddressesBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AddressesController>(() => AddressesController());
  }
}
