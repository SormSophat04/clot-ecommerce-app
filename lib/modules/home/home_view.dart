import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:clot_ecommerce_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final mutedSurfaceColor =
        theme.inputDecorationTheme.fillColor ?? colors.surfaceVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: mutedSurfaceColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                AppAssets.profile,
                width: 20,
                height: 20,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
        title: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: mutedSurfaceColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Men',
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: colors.onSurface,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Image.asset(
                  AppAssets.cart,
                  width: 20,
                  height: 20,
                  color: AppColors.backgroundColor,
                ),
                onPressed: () => Get.toNamed('/cart'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      AppAssets.search,
                      width: 20,
                      height: 20,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  filled: true,
                  fillColor: mutedSurfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 24),

              // Categories Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Categories List
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryItem(context, 'Hoodies', Icons.style),
                    _buildCategoryItem(
                      context,
                      'Shorts',
                      Icons.sports_gymnastics,
                    ),
                    _buildCategoryItem(context, 'Shoes', Icons.snowshoeing),
                    _buildCategoryItem(context, 'Bag', Icons.backpack),
                    _buildCategoryItem(context, 'Accessories', Icons.watch),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Top Selling Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Selling',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Top Selling List
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildProductItem(
                      context: context,
                      name: "Men's Harrington Jacket",
                      price: "\$148.00",
                    ),
                    _buildProductItem(
                      context: context,
                      name: "Max Cirro Men's Slides",
                      price: "\$55.00",
                      oldPrice: "\$100.97",
                    ),
                    _buildProductItem(
                      context: context,
                      name: "Nike Sportswear Club",
                      price: "\$45.00",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // New In Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New In',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // New In List
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildProductItem(
                      context: context,
                      name: "Nike Club Fleece",
                      price: "\$55.00",
                    ),
                    _buildProductItem(
                      context: context,
                      name: "Nike Air Max 270",
                      price: "\$160.00",
                      oldPrice: "\$200.00",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final mutedSurfaceColor =
        theme.inputDecorationTheme.fillColor ?? colors.surfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: mutedSurfaceColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: colors.onSurfaceVariant, size: 28),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem({
    required BuildContext context,
    required String name,
    required String price,
    String? oldPrice,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final mutedSurfaceColor =
        theme.inputDecorationTheme.fillColor ?? colors.surfaceVariant;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: mutedSurfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: colors.onSurfaceVariant.withOpacity(0.55),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite_border,
                    color: colors.onSurface,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                price,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              if (oldPrice != null) ...[
                const SizedBox(width: 8),
                Text(
                  oldPrice,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
