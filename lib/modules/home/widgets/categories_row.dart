import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home_controller.dart';

class CategoriesRow extends StatelessWidget {
  const CategoriesRow({
    super.key,
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
      height: 112.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, i) => CategoryTile(
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

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
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
        width: 86.w,
        child: Column(
          children: [
            Container(
              width: 86.w,
              height: 72.h,
              decoration: BoxDecoration(
                color: mutedSurface,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: category.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _icons[category.label] ?? Icons.category_rounded,
                      size: 24.sp,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              category.label,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
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
