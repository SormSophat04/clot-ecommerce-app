
import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'widgets/home_app_bar_widgets.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/section_header.dart';
import 'widgets/categories_row.dart';
import 'widgets/product_list.dart';// ---------------------------------------------------------------------------
// HomeView
// ---------------------------------------------------------------------------

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final surfaceMuted =
        theme.inputDecorationTheme.fillColor ?? colors.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, controller, surfaceMuted, colors),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // ── Search bar ──────────────────────────────────────────────
            HomeSearchBar(surfaceMuted: surfaceMuted, colors: colors),
            SizedBox(height: 24.h),

            // ── Categories ──────────────────────────────────────────────
            SectionHeader(
              title: 'Categories',
              textTheme: textTheme,
              colors: colors,
              onSeeAll: () => Get.toNamed(Routes.categories),
            ),
            SizedBox(height: 16.h),
            CategoriesRow(
              categories: controller.categories,
              textTheme: textTheme,
              colors: colors,
              mutedSurface: surfaceMuted,
              onCategoryTap: (category) =>
                  Get.toNamed(Routes.categories, arguments: category.label),
            ),
            SizedBox(height: 28.h),

            // ── Top Selling ─────────────────────────────────────────────
            SectionHeader(
              title: 'Top Selling',
              textTheme: textTheme,
              colors: colors,
              onSeeAll: () => Get.toNamed(Routes.product),
            ),
            SizedBox(height: 16.h),
            ProductList(
              products: controller.topSelling,
              controller: controller,
              textTheme: textTheme,
              colors: colors,
              mutedSurface: surfaceMuted,
            ),
            SizedBox(height: 28.h),

            // ── New In ───────────────────────────────────────────────────
            SectionHeader(
              title: 'New In',
              textTheme: textTheme,
              colors: colors,
              titleColor: colors.primary,
              onSeeAll: () => Get.toNamed(Routes.product),
            ),
            SizedBox(height: 16.h),
            ProductList(
              products: controller.newIn,
              controller: controller,
              textTheme: textTheme,
              colors: colors,
              mutedSurface: surfaceMuted,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    HomeController controller,
    Color surfaceMuted,
    ColorScheme colors,
  ) {
    return AppBar(
      backgroundColor: colors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 60.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: AvatarButton(surfaceMuted: surfaceMuted, colors: colors),
      ),
      title: Obx(
        () => GenderDropdown(
          selectedGender: controller.selectedGender.value,
          surfaceMuted: surfaceMuted,
          colors: colors,
          onTap: () {},
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: const CartButton(),
        ),
      ],
    );
  }
}

