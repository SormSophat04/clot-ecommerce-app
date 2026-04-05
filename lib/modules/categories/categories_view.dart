import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: const Center(
        child: Text('Categories View - To be implemented'),
      ),
    );
  }
}

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CategoriesController>(() => CategoriesController());
  }
}
