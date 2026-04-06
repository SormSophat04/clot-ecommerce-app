import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/common/feature_placeholder_scaffold.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Search',
      message: 'Search view is coming soon.',
      icon: Icons.search,
    );
  }
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<SearchController>(() => SearchController());
  }
}
