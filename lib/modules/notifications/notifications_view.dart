import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Text('Notifications View - To be implemented'),
      ),
    );
  }
}

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}
