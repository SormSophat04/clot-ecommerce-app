import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/widgets/common/empty_state.dart';
import '../../core/widgets/custom_buttons/primary_button.dart';
import 'receipt_controller.dart';

class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReceiptController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isEmpty.value) {
          return Center(
            child: EmptyState(
              title: 'No Orders yet',
              icon: Icons.shopping_cart_checkout,
              action: SizedBox(
                width: 200.w,
                child: PrimaryButton(
                  text: 'Explore Categories',
                  onPressed: controller.exploreCategories,
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            SizedBox(height: 16.h),
            // Status Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: OrderStatus.values.map((status) {
                  return Obx(() {
                    final isSelected = controller.selectedFilter.value == status;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ActionChip(
                        label: Text(
                          controller.statusString(status),
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        backgroundColor: isSelected
                            ? colorScheme.primary
                            : (theme.inputDecorationTheme.fillColor ??
                                colorScheme.surfaceContainerHighest),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r)),
                        onPressed: () => controller.setFilter(status),
                      ),
                    );
                  });
                }).toList(),
              ),
            ),
            SizedBox(height: 16.h),
            // Orders List
            Expanded(
              child: Obx(() {
                final orders = controller.filteredOrders;
                if (orders.isEmpty) {
                  return Center(
                    child: Text(
                      'No orders found',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderCard(
                      order: order,
                      onTap: () => Get.to(() => ReceiptDetailView(order: order)),
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/receipt1.png',
              width: 24.w,
              height: 24.h,
              color: colorScheme.onSurface,
              errorBuilder: (_, __, ___) => Icon(Icons.receipt_long,
                  size: 24.sp, color: colorScheme.onSurface),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.id}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${order.itemCount} items',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class ReceiptDetailView extends StatelessWidget {
  final OrderModel order;

  const ReceiptDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cardColor,
            ),
            child: Icon(Icons.chevron_left,
                size: 20.sp, color: colorScheme.onSurface),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Order ${order.id}',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeline(theme),
            SizedBox(height: 32.h),
            Text('Order Items',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                )),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/receipt1.png',
                    width: 24.w,
                    height: 24.h,
                    color: colorScheme.onSurface,
                    errorBuilder: (_, __, ___) => Icon(Icons.receipt_long,
                        size: 24.sp, color: colorScheme.onSurface),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      '${order.itemCount} items',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Text('Shipping details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                )),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.address,
                    style:
                        TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    order.phone,
                    style:
                        TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(ThemeData theme) {
    final monthStr = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][order.date.month];
    final dateStr = '${order.date.day.toString().padLeft(2, '0')} $monthStr';

    return Column(
      children: [
        _buildTimelineItem(theme, 'Delivered', dateStr,
            isCompleted: false, isFirst: true),
        _buildTimelineItem(theme, 'Shipped', dateStr, isCompleted: true),
        _buildTimelineItem(theme, 'Order Confirmed', dateStr, isCompleted: true),
        _buildTimelineItem(theme, 'Order Placed', dateStr,
            isCompleted: true, isLast: true),
      ],
    );
  }

  Widget _buildTimelineItem(ThemeData theme, String title, String date,
      {bool isCompleted = false, bool isFirst = false, bool isLast = false}) {
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                  width: 2.w,
                  height: 24.h,
                  color: isCompleted
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant.withOpacity(0.2))
            else
              SizedBox(height: 24.h),
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withOpacity(0.2),
              ),
              child: isCompleted
                  ? Icon(Icons.check, size: 14.sp, color: colorScheme.onPrimary)
                  : null,
            ),
            if (!isLast)
              Container(
                  width: 2.w,
                  height: 24.h,
                  color: isCompleted
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant.withOpacity(0.2))
            else
              SizedBox(height: 24.h),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight:
                        isCompleted ? FontWeight.normal : FontWeight.w500,
                    color: isCompleted
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}