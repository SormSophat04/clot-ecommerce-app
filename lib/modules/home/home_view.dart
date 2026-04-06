import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:clot_ecommerce_app/core/constants/app_colors.dart';
import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        theme.inputDecorationTheme.fillColor ?? AppColors.backgroundColor2;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, controller, surfaceMuted, colors),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── Search bar ──────────────────────────────────────────────
            _SearchBar(surfaceMuted: surfaceMuted, colors: colors),
            const SizedBox(height: 24),

            // ── Categories ──────────────────────────────────────────────
            _SectionHeader(
              title: 'Categories',
              textTheme: textTheme,
              colors: colors,
              onSeeAll: () => Get.toNamed(Routes.categories),
            ),
            const SizedBox(height: 16),
            _CategoriesRow(
              categories: controller.categories,
              textTheme: textTheme,
              colors: colors,
              mutedSurface: surfaceMuted,
              onCategoryTap: (category) =>
                  Get.toNamed(Routes.categories, arguments: category.label),
            ),
            const SizedBox(height: 28),

            // ── Top Selling ─────────────────────────────────────────────
            _SectionHeader(
              title: 'Top Selling',
              textTheme: textTheme,
              colors: colors,
              onSeeAll: () => Get.toNamed(Routes.product),
            ),
            const SizedBox(height: 16),
            _ProductList(
              products: controller.topSelling,
              controller: controller,
              textTheme: textTheme,
              colors: colors,
              mutedSurface: surfaceMuted,
            ),
            const SizedBox(height: 28),

            // ── New In ───────────────────────────────────────────────────
            _SectionHeader(
              title: 'New In',
              textTheme: textTheme,
              colors: colors,
              titleColor: AppColors.primaryColor,
              onSeeAll: () => Get.toNamed(Routes.product),
            ),
            const SizedBox(height: 16),
            _ProductList(
              products: controller.newIn,
              controller: controller,
              textTheme: textTheme,
              colors: colors,
              mutedSurface: surfaceMuted,
            ),
            const SizedBox(height: 24),
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
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _AvatarButton(surfaceMuted: surfaceMuted, colors: colors),
      ),
      title: Obx(
        () => _GenderDropdown(
          selectedGender: controller.selectedGender.value,
          surfaceMuted: surfaceMuted,
          colors: colors,
          onTap: () {},
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: _CartButton(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AppBar sub-widgets
// ---------------------------------------------------------------------------

class _AvatarButton extends StatelessWidget {
  const _AvatarButton({required this.surfaceMuted, required this.colors});
  final Color surfaceMuted;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.profile),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: surfaceMuted, shape: BoxShape.circle),
        child: Center(
          child: Image.asset(
            AppAssets.profile,
            width: 22,
            height: 22,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  const _GenderDropdown({
    required this.selectedGender,
    required this.surfaceMuted,
    required this.colors,
    required this.onTap,
  });
  final String selectedGender;
  final Color surfaceMuted;
  final ColorScheme colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: surfaceMuted,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedGender,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: colors.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.cart),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            AppAssets.cart,
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search Bar
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.surfaceMuted, required this.colors});
  final Color surfaceMuted;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        style: TextStyle(fontSize: 14, color: colors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Image.asset(
              AppAssets.search,
              width: 20,
              height: 20,
              color: colors.onSurfaceVariant,
            ),
          ),
          filled: true,
          fillColor: surfaceMuted,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.textTheme,
    required this.colors,
    this.titleColor,
    this.onSeeAll,
  });

  final String title;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color? titleColor;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: titleColor ?? colors.onSurface,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              foregroundColor: colors.onSurface,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'See All',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Categories horizontal row
// ---------------------------------------------------------------------------

class _CategoriesRow extends StatelessWidget {
  const _CategoriesRow({
    required this.categories,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
    required this.onCategoryTap,
  });
  final List<CategoryItem> categories;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;
  final ValueChanged<CategoryItem> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _CategoryTile(
          category: categories[i],
          textTheme: textTheme,
          colors: colors,
          mutedSurface: mutedSurface,
          onTap: () => onCategoryTap(categories[i]),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
    required this.onTap,
  });
  final CategoryItem category;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;
  final VoidCallback onTap;

  static const Map<String, IconData> _icons = {
    'Hoodies': Icons.style_rounded,
    'Shorts': Icons.dry_cleaning_rounded,
    'Shoes': Icons.directions_walk_rounded,
    'Bag': Icons.shopping_bag_rounded,
    'Accessories': Icons.watch_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 86,
        child: Column(
          children: [
            Container(
              width: 86,
              height: 72,
              decoration: BoxDecoration(
                color: mutedSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: category.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _icons[category.label] ?? Icons.category_rounded,
                      size: 24,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.label,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Product horizontal list
// ---------------------------------------------------------------------------

class _ProductList extends StatelessWidget {
  const _ProductList({
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
      height: 294,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) => _ProductCard(
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({
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
        width: 170,
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: mutedSurface,
          borderRadius: BorderRadius.circular(22),
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
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_rounded,
                        size: 46,
                        color: Color.fromRGBO(255, 255, 255, 0.75),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => controller.toggleWishlist(product.name),
                        child: Container(
                          width: 32,
                          height: 32,
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
                              width: 16,
                              height: 16,
                              color: controller.isWishlisted(product.name)
                                  ? AppColors.primaryColor
                                  : const Color(0xFFAAAAAA),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  product.price,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                if (product.oldPrice != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    product.oldPrice!,
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
      ),
    );
  }
}
