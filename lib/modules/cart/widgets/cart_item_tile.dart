import 'dart:convert';
import 'dart:typed_data';

import 'package:clot_ecommerce_app/data/models/cart_model.dart' as cart_model;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../cart_controller.dart';

class CartItemTile extends GetView<CartController> {
  const CartItemTile({super.key, required this.item});

  final cart_model.CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark
        ? const Color(0xFF2D2F39)
        : const Color(0xFFF4F4F4);
    final sizeLabel = item.product.availableSizes.isNotEmpty
        ? item.product.availableSizes.first
        : '-';
    final colorLabel = item.product.availableColors.isNotEmpty
        ? item.product.availableColors.first
        : '-';
    final isBusy = controller.isItemBusy(item);

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImage(image: item.product.image),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
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
                      '\$${item.product.finalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 6.h,
                  children: [
                    _MetaText(label: 'Size', value: sizeLabel),
                    _MetaText(label: 'Color', value: colorLabel),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    RoundQuantityBtn(
                      iconPath: AppAssets.remove,
                      onTap: isBusy
                          ? null
                          : () => controller.updateQuantity(item, -1),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '${item.quantity}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    RoundQuantityBtn(
                      iconPath: AppAssets.add,
                      onTap: isBusy
                          ? null
                          : () => controller.updateQuantity(item, 1),
                    ),
                    const Spacer(),
                    if (isBusy)
                      SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                    SizedBox(width: 8.w),
                    TextButton(
                      onPressed: isBusy ? null : () => controller.removeItem(item),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        minimumSize: Size(0, 32.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label - ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final containerColor = isDark
        ? const Color(0xFF1E1F25)
        : const Color(0xFFE0E0E0);
    final value = image?.trim();
    final isNetwork =
        value != null &&
        (value.startsWith('http://') || value.startsWith('https://'));
    final bytes = value == null ? null : _decodeImage(value);

    return Container(
      width: 72.w,
      height: 72.h,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: () {
          if (isNetwork) {
            return Image.network(
              value,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _fallback(colorScheme),
            );
          }
          if (bytes != null) {
            return Image.memory(
              bytes,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _fallback(colorScheme),
            );
          }
          return _fallback(colorScheme);
        }(),
      ),
    );
  }

  Uint8List? _decodeImage(String raw) {
    try {
      final payload = raw.contains(',') ? raw.split(',').last : raw;
      return base64Decode(payload);
    } catch (_) {
      return null;
    }
  }

  Widget _fallback(ColorScheme colorScheme) {
    return Icon(
      Icons.image_not_supported_outlined,
      color: colorScheme.onSurfaceVariant,
    );
  }
}

class RoundQuantityBtn extends StatelessWidget {
  const RoundQuantityBtn({super.key, required this.iconPath, required this.onTap});

  final String iconPath;
  final VoidCallback? onTap;

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
            color: onTap == null
                ? colorScheme.primary.withValues(alpha: 0.35)
                : colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              color: colorScheme.onPrimary,
              width: 16.w,
            ),
          ),
        ),
      ),
    );
  }
}
