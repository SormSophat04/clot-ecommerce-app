import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../cart_controller.dart';

class CartItemTile extends GetView<CartController> {
  const CartItemTile({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF2D2F39) : const Color(0xFFF4F4F4);

    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Box
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1F25) : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                item.assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      'Size - ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                         color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      item.size,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                         color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Color - ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                         color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      item.color,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                         color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    // Quantity adjustments
                    Row(
                      children: [
                        RoundQuantityBtn(
                          iconPath: AppAssets.add,
                          onTap: () => controller.updateQuantity(item.id, 1),
                        ),
                        SizedBox(width: 8.w),
                         RoundQuantityBtn(
                          iconPath: AppAssets.remove,
                          onTap: () => controller.updateQuantity(item.id, -1),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundQuantityBtn extends StatelessWidget {
  const RoundQuantityBtn({super.key, required this.iconPath, required this.onTap});

  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(iconPath, color: colorScheme.onPrimary, width: 16.w),
          ),
        ),
      ),
    );
  }
}
