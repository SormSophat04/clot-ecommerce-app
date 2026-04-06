import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/modules/categories/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.controller,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
  });

  final CategoriesController controller;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: controller.categories.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final category = controller.categories[index];

        return Material(
          color: mutedSurface,
          borderRadius: BorderRadius.circular(22.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(22.r),
            onTap: () => Get.toNamed(Routes.product, arguments: category.name),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: _categoryAccentColor(colors, index),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(category.icon, size: 24.sp, color: colors.primary),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      category.name,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Color _categoryAccentColor(ColorScheme colors, int index) {
  final accents = <Color>[
    colors.primaryContainer,
    colors.secondaryContainer,
    colors.tertiaryContainer,
    colors.primaryContainer.withValues(alpha: 0.7),
    colors.secondaryContainer.withValues(alpha: 0.7),
  ];
  return accents[index % accents.length];
}
