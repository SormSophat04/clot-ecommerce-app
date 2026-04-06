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
  final List<ProductItem> products;
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
    required this.controller,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
  });
  final ProductItem product;
  final HomeController controller;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.productDetails),
      child: Container(
        width: 170.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: product.imageColor,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_rounded,
                        size: 46.sp,
                        color: const Color.fromRGBO(255, 255, 255, 0.75),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => controller.toggleWishlist(product.name),
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
                              color: controller.isWishlisted(product.name)
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
                  product.price,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                if (product.oldPrice != null) ...[
                  SizedBox(width: 6.w),
                  Text(
                    product.oldPrice!,
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
}
