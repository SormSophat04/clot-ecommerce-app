import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/app_assets.dart';
import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return _buildEmptyState(context);
        } else {
          return _buildNotificationsList(context);
        }
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.bell,
              width: 100.w,
              height: 100.h,
            ),
            SizedBox(height: 24.h),
            Text(
              'No Notification yet',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: 180.w,
              child: ElevatedButton(
                onPressed: () {
                  // Action for exploring categories
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Text(
                  'Explore Categories',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(24.r),
      itemCount: controller.notifications.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = controller.notifications[index];
        return _buildNotificationItem(context, item);
      },
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputFillColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: inputFillColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h, right: 2.w), // space for badge
                child: Image.asset(
                  AppAssets.notification,
                  width: 24.w,
                  height: 24.h,
                  color: colorScheme.onSurface,
                ),
              ),
              if (item.isUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              item.message,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.5,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
