import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common/feature_placeholder_scaffold.dart';

class AddressesView extends StatelessWidget {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return FeaturePlaceholderScaffold(
      title: 'My Addresses',
      message: 'Addresses view is coming soon.',
      icon: Icons.location_on_outlined,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => Get.toNamed('/add-address'),
        ),
      ],
    );
  }
}

class AddressesBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AddressesController>(() => AddressesController());
  }
}
