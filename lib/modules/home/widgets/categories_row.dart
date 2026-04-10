import 'dart:convert';
import 'dart:typed_data';

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

  @override
  Widget build(BuildContext context) {
    final image = category.image?.trim();
    final imageBytes = image == null ? null : _decodeImage(image);
    final isNetworkImage =
        image != null &&
        (image.startsWith('http://') || image.startsWith('https://'));

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70.w,
        child: Column(
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: mutedSurface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: colors.surfaceContainerHighest,
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Builder(
                  builder: (_) {
                    if (isNetworkImage) {
                      return Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildFallbackIcon(),
                      );
                    }

                    if (imageBytes != null) {
                      return Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildFallbackIcon(),
                      );
                    }

                    return _buildFallbackIcon();
                  },
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

  IconData _iconForCategory(String label) {
    final normalized = label.trim().toLowerCase();
    if (normalized.contains('hoodie') || normalized.contains('jacket')) {
      return Icons.style_rounded;
    }
    if (normalized.contains('short')) {
      return Icons.dry_cleaning_rounded;
    }
    if (normalized.contains('shoe') || normalized.contains('sneaker')) {
      return Icons.directions_walk_rounded;
    }
    if (normalized.contains('bag') || normalized.contains('backpack')) {
      return Icons.shopping_bag_rounded;
    }
    if (normalized.contains('accessor') || normalized.contains('watch')) {
      return Icons.watch_rounded;
    }
    return Icons.category_rounded;
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: Icon(
        _iconForCategory(category.label),
        size: 24.sp,
        color: colors.primary,
      ),
    );
  }

  Uint8List? _decodeImage(String raw) {
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return null;
    }

    try {
      final normalized = raw.startsWith('data:')
          ? raw.substring(raw.indexOf(',') + 1)
          : raw;
      if (normalized.isEmpty) {
        return null;
      }
      return base64Decode(normalized);
    } catch (_) {
      return null;
    }
  }
}
