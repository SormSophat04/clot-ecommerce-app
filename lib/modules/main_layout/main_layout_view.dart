import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:clot_ecommerce_app/core/constants/app_colors.dart';
import 'package:clot_ecommerce_app/modules/home/home_view.dart';
import 'package:clot_ecommerce_app/modules/notifications/notifications_view.dart';
import 'package:clot_ecommerce_app/modules/profile/profile_view.dart';
import 'package:clot_ecommerce_app/modules/receipt/receipt_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'main_layout_controller.dart';

class MainLayoutView extends GetView<MainLayoutController> {
  MainLayoutView({super.key});

  final List<Widget> pages = [
    const HomeView(),
    const NotificationsView(),
    const ReceiptView(),
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
        height: 90.h,
        padding: EdgeInsets.only(bottom: 20.h),
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
          padding: EdgeInsets.all(10.r), // Increased hit area
          height: 50.h,
          width: 50.w,
          child: Image.asset(
            icon,
            color: isSelected ? selectedColor : unselectedColor,
          ),
        ),
      );
    });
  }
}
