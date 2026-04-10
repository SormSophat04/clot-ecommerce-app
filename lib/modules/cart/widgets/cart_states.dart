import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../cart_controller.dart';
import 'cart_header.dart';
import 'cart_item_tile.dart';
import 'order_summary.dart';

class EmptyCartState extends StatelessWidget {
  const EmptyCartState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      children: [
        const CartHeader(title: ''),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minimal placeholder for the bag icon if not using the exact image
                Image.asset(
                  AppAssets.cart, // Ideally a larger bag image if available
                  height: 100.h,
                  width: 100.w,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.shopping_bag_outlined,
                    size: 100.sp,
                    color: Colors.orangeAccent,
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'Your Cart is Empty',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to categories/home
                    Get.back(); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                  ),
                  child: Text(
                    'Explore Categories',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                  ),
                ),
                // Push content up slightly from true center
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CartErrorState extends StatelessWidget {
  const CartErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const CartHeader(title: 'Cart'),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: colorScheme.error,
                    size: 52.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 18.h),
                  ElevatedButton(
                    onPressed: () => onRetry(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PopulatedCartState extends GetView<CartController> {
  const PopulatedCartState({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // CartHeader(
        //   title: 'Cart',
        //   trailing: Obx(
        //     () => TextButton(
        //       onPressed: controller.isClearing.value
        //           ? null
        //           : () => controller.removeAll(),
        //       child: Text(
        //         controller.isClearing.value ? 'Removing...' : 'Remove All',
        //         style: theme.textTheme.titleMedium?.copyWith(
        //           fontWeight: FontWeight.w600,
        //           color: theme.colorScheme.onSurface,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Expanded(
          child: Obx(
            () => RefreshIndicator(
              onRefresh: controller.refreshCart,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, _) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return CartItemTile(item: controller.cartItems[index]);
                },
              ),
            ),
          ),
        ),
        const OrderSummary(),
      ],
    );
  }
}
