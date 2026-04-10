import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/core/widgets/common/loading_indicator.dart';
import 'package:clot_ecommerce_app/core/widgets/common/skeleton_loader.dart';
import 'package:clot_ecommerce_app/data/models/product_model.dart';
import 'package:clot_ecommerce_app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'widgets/home_app_bar_widgets.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/section_header.dart';
import 'widgets/categories_row.dart';
import 'widgets/product_list.dart';
// ---------------------------------------------------------------------------
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
            Obx(
              () => _buildCategoriesSection(
                controller: controller,
                textTheme: textTheme,
                colors: colors,
                mutedSurface: surfaceMuted,
              ),
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
            Obx(
              () => _buildHomeProductSection(
                products: controller.topSelling.toList(),
                isLoading:
                    controller.isLoadingProducts.value &&
                    controller.topSelling.isEmpty &&
                    controller.newIn.isEmpty,
                error: controller.productsError.value,
                onRetry: controller.fetchHomeProducts,
                controller: controller,
                textTheme: textTheme,
                colors: colors,
                mutedSurface: surfaceMuted,
                emptyMessage: 'No top selling products yet.',
              ),
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
            Obx(
              () => _buildHomeProductSection(
                products: controller.newIn.toList(),
                isLoading:
                    controller.isLoadingProducts.value &&
                    controller.topSelling.isEmpty &&
                    controller.newIn.isEmpty,
                error: controller.productsError.value,
                onRetry: controller.fetchHomeProducts,
                controller: controller,
                textTheme: textTheme,
                colors: colors,
                mutedSurface: surfaceMuted,
                emptyMessage: 'No new products right now.',
              ),
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

  Widget _buildHomeProductSection({
    required List<ProductModel> products,
    required bool isLoading,
    required String error,
    required VoidCallback onRetry,
    required HomeController controller,
    required TextTheme textTheme,
    required ColorScheme colors,
    required Color mutedSurface,
    required String emptyMessage,
  }) {
    if (isLoading) {
      return const HomeProductListSkeleton();
    }

    if (error.isNotEmpty && products.isEmpty) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: colors.errorContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              error,
              style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(onPressed: onRetry, child: const Text('Retry')),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(
          emptyMessage,
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      );
    }

    return ProductList(
      products: products,
      controller: controller,
      textTheme: textTheme,
      colors: colors,
      mutedSurface: mutedSurface,
    );
  }

  Widget _buildCategoriesSection({
    required HomeController controller,
    required TextTheme textTheme,
    required ColorScheme colors,
    required Color mutedSurface,
  }) {
    final categories = controller.categories.toList();
    final loading = controller.isLoadingCategories.value;
    final error = controller.categoriesError.value;

    if (loading && categories.isEmpty) {
      return const CategoriesRowSkeleton();
    }

    if (categories.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(
          error.isEmpty ? 'No categories available.' : error,
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              error,
              style: textTheme.bodySmall?.copyWith(color: colors.error),
            ),
          ),
        if (error.isNotEmpty) SizedBox(height: 8.h),
        CategoriesRow(
          categories: categories,
          textTheme: textTheme,
          colors: colors,
          mutedSurface: mutedSurface,
          onCategoryTap: (category) => Get.toNamed(
            Routes.product,
            arguments: <String, dynamic>{
              'categoryId': category.id,
              'category': category.label,
            },
          ),
        ),
      ],
    );
  }
}
