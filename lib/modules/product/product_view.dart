import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final Set<String> _wishlist = <String>{};

  static const List<_GridProduct> _products = [
    _GridProduct(
      name: "Men's Harrington Jacket",
      price: '\$148.00',
      imageColor: Color(0xFFB8D8C8),
    ),
    _GridProduct(
      name: "Max Cirro Men's Slides",
      price: '\$55.00',
      oldPrice: '\$100.97',
      imageColor: Color(0xFFD0D8E8),
    ),
    _GridProduct(
      name: 'Nike Sportswear Club',
      price: '\$45.00',
      imageColor: Color(0xFFE8D8C8),
    ),
    _GridProduct(
      name: 'Nike Club Fleece',
      price: '\$55.00',
      imageColor: Color(0xFFD8C8E8),
    ),
    _GridProduct(
      name: 'Nike Air Max 270',
      price: '\$160.00',
      oldPrice: '\$200.00',
      imageColor: Color(0xFFC8E8D8),
    ),
    _GridProduct(
      name: 'Jordan Flight MVP',
      price: '\$90.00',
      imageColor: Color(0xFFE8C8C8),
    ),
  ];

  void _toggleWishlist(String productName) {
    setState(() {
      if (_wishlist.contains(productName)) {
        _wishlist.remove(productName);
      } else {
        _wishlist.add(productName);
      }
    });
  }

  bool _isWishlisted(String productName) => _wishlist.contains(productName);

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
        title: Text(
          'All Products',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: colors.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_products.length} Items',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: colors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 14.w,
                    childAspectRatio: 0.54,
                  ),
                  itemBuilder: (context, index) {
                    final product = _products[index];

                    return _ProductGridCard(
                      product: product,
                      textTheme: textTheme,
                      colors: colors,
                      mutedSurface: surfaceMuted,
                      isWishlisted: _isWishlisted(product.name),
                      onWishlistTap: () => _toggleWishlist(product.name),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({
    required this.product,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
    required this.isWishlisted,
    required this.onWishlistTap,
  });

  final _GridProduct product;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;
  final bool isWishlisted;
  final VoidCallback onWishlistTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.productDetails),
      child: Container(
        // padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          // color: mutedSurface,
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

class _GridProduct {
  const _GridProduct({
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imageColor,
  });

  final String name;
  final String price;
  final String? oldPrice;
  final Color imageColor;
}
