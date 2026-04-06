import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../cart_controller.dart';

class OrderSummary extends GetView<CartController> {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF2D2F39) : const Color(0xFFF4F4F4);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => SummaryRow(label: 'Subtotal', value: '\$${controller.subtotal.toStringAsFixed(2)}')),
          SizedBox(height: 12.h),
          Obx(() => SummaryRow(label: 'Shipping Cost', value: '\$${controller.shippingCost.value.toStringAsFixed(2)}')),
          SizedBox(height: 12.h),
          Obx(() => SummaryRow(label: 'Tax', value: '\$${controller.tax.toStringAsFixed(2)}')),
          SizedBox(height: 16.h),
          Obx(() => SummaryRow(
            label: 'Total', 
            value: '\$${controller.total.toStringAsFixed(2)}', 
            isTotal: true
          )),
          SizedBox(height: 24.h),
          
          // Coupon Input
          Container(
            padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 4.h, bottom: 4.h),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(30.r)
            ),
            child: Row(
              children: [
                Image.asset(
                  AppAssets.discount, 
                  color: colorScheme.onSurfaceVariant,
                  width: 24.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Coupon Code',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                         color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(AppAssets.arrowRight, color: colorScheme.onPrimary, width: 16.w),
                  ),
                )
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.h),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.label, required this.value, this.isTotal = false});

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal 
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            fontSize: isTotal ? 16.sp : 15.sp,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            color: colorScheme.onSurface,
            fontSize: isTotal ? 18.sp : 15.sp,
          ),
        ),
      ],
    );
  }
}
