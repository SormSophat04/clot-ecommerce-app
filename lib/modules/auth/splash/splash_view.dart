import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';
import '../../../core/widgets/common/loading_indicator.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(SplashController());

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Icon(
              Icons.shopping_bag_rounded,
              size: 100,
              color: Color(0xFF8E6CEF),
            ),
            SizedBox(height: 24),
            // App Name
            Text(
              'E-Commerce',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E6CEF),
              ),
            ),
            SizedBox(height: 48),
            LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
