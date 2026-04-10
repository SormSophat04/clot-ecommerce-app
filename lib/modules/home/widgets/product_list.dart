import 'dart:convert';
import 'dart:typed_data';

import 'package:clot_ecommerce_app/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/routes/app_routes.dart';
import '../home_controller.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.products,
    required this.controller,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
  });
  final List<ProductModel> products;
  final HomeController controller;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 294.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        separatorBuilder: (_, _) => SizedBox(width: 14.w),
        itemBuilder: (context, i) => ProductCard(
          product: products[i],
          index: i,
          controller: controller,
          textTheme: textTheme,
          colors: colors,
          mutedSurface: mutedSurface,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.index,
    required this.controller,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
  });
  final ProductModel product;
  final int index;
  final HomeController controller;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
      child: Container(
        width: 170.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  _ProductImage(
                    image: product.image,
                    tint: _fallbackTint(index),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => controller.toggleWishlist(product.id),
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
                              color: controller.isWishlisted(product.id)
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                            ),
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

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.image, required this.tint});

  final String? image;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final value = image?.trim();
    if (value == null || value.isEmpty) {
      return _fallback();
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Image.network(
            value,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
          ),
        ),
      );
    }

    final decoded = _decode(value);
    if (decoded == null) {
      return _fallback();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Image.memory(
          decoded,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(),
        ),
      ),
    );
  }

  Uint8List? _decode(String raw) {
    try {
      final payload = raw.contains(',') ? raw.split(',').last : raw;
      return base64Decode(payload);
    } catch (_) {
      return null;
    }
  }

  Widget _fallback() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tint,
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
