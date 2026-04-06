import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common/feature_placeholder_scaffold.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Add Address',
      message: 'Add address view is coming soon.',
      icon: Icons.add_location_alt_outlined,
    );
  }
}

class AddAddressBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AddAddressController>(() => AddAddressController());
  }
}
