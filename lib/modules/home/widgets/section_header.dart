import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
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
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
