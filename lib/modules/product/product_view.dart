import 'dart:convert';
import 'dart:typed_data';

import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/core/widgets/common/empty_state.dart';
import 'package:clot_ecommerce_app/core/widgets/common/loading_indicator.dart';
import 'package:clot_ecommerce_app/core/widgets/common/skeleton_loader.dart';
import 'package:clot_ecommerce_app/data/models/product_model.dart';
import 'package:clot_ecommerce_app/modules/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final surfaceMuted =
        theme.inputDecorationTheme.fillColor ?? colors.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
          child: GestureDetector(
            onTap: Get.back,
            child: Container(
              decoration: BoxDecoration(
                color: surfaceMuted,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(10.r),
              child: Image.asset(AppAssets.backArrow, color: colors.onSurface),
            ),
          ),
        ),
        title: Obx(
          () => Text(
            controller.selectedCategory.value.isEmpty
                ? 'All Products'
                : controller.selectedCategory.value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: colors.onSurface,
            ),
          ),
        ),
      ),
      body: Obx(() {
        final products = controller.products;
        final loading = controller.isLoading.value;
        final loadingMore = controller.isLoadingMore.value;
        final errorText = controller.errorMessage.value;
        final hasError = errorText.isNotEmpty;

        if (loading && controller.allProducts.isEmpty) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  const Expanded(child: ProductGridSkeleton()),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${products.length} Items',
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                if (hasError && products.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  _InlineError(
                    message: errorText,
                    onRetry: controller.retry,
                    colors: colors,
                  ),
                ],
                SizedBox(height: 16.h),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshProducts,
                    child: _buildGridOrState(
                      products: products,
                      loadingMore: loadingMore,
                      hasError: hasError,
                      errorText: errorText,
                      textTheme: textTheme,
                      colors: colors,
                      mutedSurface: surfaceMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGridOrState({
    required List<ProductModel> products,
    required bool loadingMore,
    required bool hasError,
    required String errorText,
    required TextTheme textTheme,
    required ColorScheme colors,
    required Color mutedSurface,
  }) {
    if (hasError && products.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 80.h),
          EmptyState(
            title: 'Unable to load products',
            subtitle: errorText,
            icon: Icons.error_outline_rounded,
            action: TextButton(
              onPressed: controller.retry,
              child: const Text('Try Again'),
            ),
          ),
        ],
      );
    }

    if (products.isEmpty) {
      final category = controller.selectedCategory.value;
      final subtitle = category.isEmpty
          ? 'No products found right now.'
          : 'No products found for "$category".';

      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 80.h),
          EmptyState(
            title: 'No products yet',
            subtitle: subtitle,
            icon: Icons.inventory_2_outlined,
          ),
        ],
      );
    }

    final itemCount = loadingMore ? products.length + 2 : products.length;
    return GridView.builder(
      controller: controller.scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 0.54,
      ),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const Center(
            child: LoadingIndicator(size: 24, strokeWidth: 2),
          );
        }

        final product = products[index];
        return _ProductGridCard(
          product: product,
          textTheme: textTheme,
          colors: colors,
          mutedSurface: mutedSurface,
          fallbackTint: _fallbackTint(index),
          isWishlisted: controller.isWishlisted(product.id),
          onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
          onWishlistTap: () => controller.toggleWishlist(product.id),
        );
      },
    );
  }

  Color _fallbackTint(int index) {
    const tints = <Color>[
      Color(0xFFB8D8C8),
      Color(0xFFD0D8E8),
      Color(0xFFE8D8C8),
      Color(0xFFD8C8E8),
      Color(0xFFC8E8D8),
      Color(0xFFE8C8C8),
    ];
    return tints[index % tints.length];
  }
}

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({
    required this.product,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
    required this.fallbackTint,
    required this.isWishlisted,
    required this.onTap,
    required this.onWishlistTap,
  });

  final ProductModel product;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;
  final Color fallbackTint;
  final bool isWishlisted;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  _ProductImageCard(
                    image: product.image,
                    fallbackTint: fallbackTint,
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: onWishlistTap,
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            AppAssets.heart,
                            width: 16.w,
                            height: 16.h,
                            color: isWishlisted
                                ? colors.primary
                                : colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              product.name,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  _formatPrice(product.finalPrice),
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                if (product.onSale) ...[
                  SizedBox(width: 6.w),
                  Text(
                    _formatPrice(product.price),
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: colors.onSurfaceVariant,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';
}

class _ProductImageCard extends StatelessWidget {
  const _ProductImageCard({required this.image, required this.fallbackTint});

  final String? image;
  final Color fallbackTint;

  @override
  Widget build(BuildContext context) {
    final parsedImage = image?.trim();
    if (parsedImage == null || parsedImage.isEmpty) {
      return _fallback();
    }

    if (parsedImage.startsWith('http://') ||
        parsedImage.startsWith('https://')) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: fallbackTint,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Image.network(
            parsedImage,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: LoadingIndicator(size: 22, strokeWidth: 2),
              );
            },
          ),
        ),
      );
    }

    final bytes = _decodeImage(parsedImage);
    if (bytes == null) {
      return _fallback();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: fallbackTint,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(),
        ),
      ),
    );
  }

  Uint8List? _decodeImage(String raw) {
    try {
      final base64Payload = raw.contains(',') ? raw.split(',').last : raw;
      return base64Decode(base64Payload);
    } catch (_) {
      return null;
    }
  }

  Widget _fallback() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: fallbackTint,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Center(
        child: Icon(
          Icons.image_rounded,
          size: 46.sp,
          color: const Color.fromRGBO(255, 255, 255, 0.75),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({
    required this.message,
    required this.onRetry,
    required this.colors,
  });

  final String message;
  final VoidCallback onRetry;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: colors.error, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onSurface),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
