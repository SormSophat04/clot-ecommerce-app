import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common/feature_placeholder_scaffold.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Edit Profile',
      message: 'Edit profile view is coming soon.',
      icon: Icons.person_outline,
    );
  }
}

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}
