import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final inputFillColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              // Profile Picture
              Container(
                width: 96.w,
                height: 96.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: inputFillColor,
                  image: const DecorationImage(
                    image: AssetImage(AppAssets.profile),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // User Info Card
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: inputFillColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gilbert Jones',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Glbertjones001@gmail.com',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '121-224-7890',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.editProfile),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.topRight,
                      ),
                      child: Text(
                        'Edit',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Menu Options
              _ProfileMenuTile(
                title: 'Address',
                onTap: () => Get.toNamed(Routes.addresses),
              ),
              SizedBox(height: 12.h),
              _ProfileMenuTile(
                title: 'Wishlist',
                onTap: () => Get.toNamed(Routes.wishlist),
              ),
              SizedBox(height: 12.h),
              _ProfileMenuTile(
                title: 'Payment',
                onTap: () => Get.toNamed(Routes.payment),
              ),
              SizedBox(height: 12.h),
              _ProfileMenuTile(title: 'Help', onTap: () {}),
              SizedBox(height: 12.h),
              _ProfileMenuTile(title: 'Support', onTap: () {}),

              SizedBox(height: 48.h),

              // Sign Out Button
              TextButton(
                onPressed: () => _showLogoutDialog(context),
                child: Text(
                  'Sign Out',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(Routes.login);
            },
            child: Text('Logout', style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final inputFillColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return Material(
      color: inputFillColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                  fontSize: 16.sp,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
