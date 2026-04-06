import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/common/feature_placeholder_scaffold.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScaffold(
      title: 'Notifications',
      message: 'Notifications view is coming soon.',
      icon: Icons.notifications_outlined,
    );
  }
}

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}
