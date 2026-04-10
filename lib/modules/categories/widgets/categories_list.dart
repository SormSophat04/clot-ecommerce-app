import 'dart:convert';
import 'dart:typed_data';

import 'package:clot_ecommerce_app/modules/categories/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.controller,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
  });

  final CategoriesController controller;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: controller.categories.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final category = controller.categories[index];

          return Material(
            color: mutedSurface,
            borderRadius: BorderRadius.circular(22.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(22.r),
              onTap: () => controller.openCategory(category),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Row(
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: _categoryAccentColor(colors, index),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: _CategoryImage(
                        image: category.image,
                        fallbackIcon: _iconForCategory(category.name),
                        iconColor: colors.primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        category.name,
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class _CategoryImage extends StatelessWidget {
  const _CategoryImage({
    required this.image,
    required this.fallbackIcon,
    required this.iconColor,
  });

  final String? image;
  final IconData fallbackIcon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final parsedImage = image?.trim();
    final imageBytes = parsedImage == null ? null : _decodeImage(parsedImage);
    final isNetworkImage =
        parsedImage != null &&
        (parsedImage.startsWith('http://') ||
            parsedImage.startsWith('https://'));

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Builder(
        builder: (_) {
          if (isNetworkImage) {
            return Image.network(
              parsedImage,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildFallback(),
            );
          }

          if (imageBytes != null) {
            return Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildFallback(),
            );
          }

          return _buildFallback();
        },
      ),
    );
  }

  Widget _buildFallback() {
    return Center(child: Icon(fallbackIcon, size: 24.sp, color: iconColor));
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

Color _categoryAccentColor(ColorScheme colors, int index) {
  final accents = <Color>[
    colors.primaryContainer,
    colors.secondaryContainer,
    colors.tertiaryContainer,
    colors.primaryContainer.withValues(alpha: 0.7),
    colors.secondaryContainer.withValues(alpha: 0.7),
  ];
  return accents[index % accents.length];
}

IconData _iconForCategory(String name) {
  final normalized = name.trim().toLowerCase();
  if (normalized.contains('hoodie') || normalized.contains('jacket')) {
    return Icons.checkroom_rounded;
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
