import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:clot_ecommerce_app/modules/cart/cart_view.dart';
import 'package:clot_ecommerce_app/modules/home/home_view.dart';
import 'package:clot_ecommerce_app/modules/notifications/notifications_view.dart';
import 'package:clot_ecommerce_app/modules/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_layout_controller.dart';

class MainLayoutView extends StatelessWidget {
  MainLayoutView({super.key});

  final MainLayoutController controller = Get.put(MainLayoutController());

  final List<Widget> pages = [
    const HomeView(),
    const NotificationsView(),
    const CartView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomNavTheme = theme.bottomNavigationBarTheme;
    final selectedIconColor =
        bottomNavTheme.selectedItemColor ?? theme.colorScheme.primary;
    final unselectedIconColor =
        bottomNavTheme.unselectedItemColor ??
        theme.colorScheme.onSurfaceVariant;
    final navBackgroundColor =
        bottomNavTheme.backgroundColor ?? theme.colorScheme.surface;

    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(color: navBackgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(
              icon: AppAssets.home,
              index: 0,
              selectedColor: selectedIconColor,
              unselectedColor: unselectedIconColor,
            ),
            _buildItem(
              icon: AppAssets.notification,
              index: 1,
              selectedColor: selectedIconColor,
              unselectedColor: unselectedIconColor,
            ),
            _buildItem(
              icon: AppAssets.receipt,
              index: 2,
              selectedColor: selectedIconColor,
              unselectedColor: unselectedIconColor,
            ),
            _buildItem(
              icon: AppAssets.profile,
              index: 3,
              selectedColor: selectedIconColor,
              unselectedColor: unselectedIconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required String icon,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          controller.changeIndex(index);
        },
        child: Container(
          padding: const EdgeInsets.all(10), // Increased hit area
          height: 50,
          width: 50,
          child: Image.asset(
            icon,
            color: isSelected ? selectedColor : unselectedColor,
          ),
        ),
      );
    });
  }
}
