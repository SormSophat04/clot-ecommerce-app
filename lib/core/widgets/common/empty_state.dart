import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;
  final String? imagePath;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null) ...[
              Image.asset(imagePath!, width: 150.w, height: 150.h),
              SizedBox(height: 24.h),
            ] else if (icon != null) ...[
              Icon(icon, size: 80.sp, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(height: 24.h),
            ],
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[SizedBox(height: 24.h), action!],
          ],
        ),
      ),
    );
  }
}
