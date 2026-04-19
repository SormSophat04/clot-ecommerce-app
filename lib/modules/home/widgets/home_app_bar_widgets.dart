import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routes/app_routes.dart';

class AvatarButton extends StatelessWidget {
  const AvatarButton({super.key, required this.surfaceMuted, required this.colors});
  final Color surfaceMuted;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.profile),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(color: surfaceMuted, shape: BoxShape.circle),
        child: Center(
          child: Image.asset(
            AppAssets.profile,
            width: 22.w,
            height: 22.h,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class TypeDropdown extends StatelessWidget {
  const TypeDropdown({
    super.key,
    required this.selectedType,
    required this.surfaceMuted,
    required this.colors,
    required this.onTap,
  });
  final String selectedType;
  final Color surfaceMuted;
  final ColorScheme colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: surfaceMuted,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedType,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.sp,
              color: colors.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.cart),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            AppAssets.cart,
            width: 20.w,
            height: 20.h,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
