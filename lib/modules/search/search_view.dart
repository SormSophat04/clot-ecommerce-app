import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(
        child: Text('Search View - To be implemented'),
      ),
    );
  }
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<SearchController>(() => SearchController());
  }
}
