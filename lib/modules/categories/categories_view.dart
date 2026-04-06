import 'package:clot_ecommerce_app/core/widgets/common/app_bar.dart';
import 'package:clot_ecommerce_app/modules/categories/categories_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/categories_list.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoriesController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final mutedSurface =
        theme.inputDecorationTheme.fillColor ?? colors.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Shop by Categories',
                style: textTheme.headlineSmall?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              SizedBox(height: 18.h),
              Expanded(
                child: CategoriesList(
                  controller: controller,
                  textTheme: textTheme,
                  colors: colors,
                  mutedSurface: mutedSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

