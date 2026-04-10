import 'dart:convert';
import 'dart:typed_data';

import 'package:clot_ecommerce_app/core/constants/app_colors.dart';
import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:clot_ecommerce_app/core/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  Future<void> _showSizePicker(BuildContext context) async {
    final selectedSize = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Obx(
          () => _PickerSheet(
            title: 'Size',
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: controller.sizes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final size = controller.sizes[index];
                return _PickerOptionTile(
                  label: size,
                  selected: size == controller.selectedSize.value,
                  onTap: () => Navigator.of(context).pop(size),
                );
              },
            ),
            onClose: () => Navigator.of(context).pop(),
          ),
        );
      },
    );

    if (selectedSize != null) {
      controller.selectSize(selectedSize);
    }
  }

  Future<void> _showColorPicker(BuildContext context) async {
    final selectedColorIndex = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Obx(
          () => _PickerSheet(
            title: 'Color',
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: controller.colorOptions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final option = controller.colorOptions[index];
                final isSelected = controller.selectedColorIndex.value == index;
                return _PickerOptionTile(
                  label: option.name,
                  selected: isSelected,
                  onTap: () => Navigator.of(context).pop(index),
                  trailing: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: option.color,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
            onClose: () => Navigator.of(context).pop(),
          ),
        );
      },
    );

    if (selectedColorIndex != null) {
      controller.selectColor(selectedColorIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final shellBackground = isDark
        ? const Color(0xFF16171D)
        : AppColors.backgroundColor;
    final mutedSurface = isDark
        ? const Color(0xFF2D2F39)
        : const Color(0xFFECECEE);
    final mutedText = isDark
        ? colorScheme.onSurfaceVariant
        : const Color(0xFF8B8B90);
    final buttonGradient = <Color>[
      colorScheme.primary,
      isDark
          ? colorScheme.primary.withValues(alpha: 0.8)
          : const Color(0xFF7A5ADE),
    ];

    return Scaffold(
      backgroundColor: shellBackground,
      body: SafeArea(
        child: Obx(() {
          final isLoading =
              controller.isLoading.value && controller.product.value == null;
          final errorText = controller.errorMessage.value;
          final hasFatalError =
              errorText.isNotEmpty && controller.product.value == null;

          if (isLoading) {
            return const Center(child: LoadingIndicator());
          }

          if (hasFatalError) {
            return _ErrorState(
              message: errorText,
              onRetry: controller.retry,
              colorScheme: colorScheme,
            );
          }

          final galleryImages = controller.displayGalleryImages;
          final colorOptions = controller.colorOptions;
          final safeColorIndex = colorOptions.isEmpty
              ? 0
              : controller.selectedColorIndex.value.clamp(
                  0,
                  colorOptions.length - 1,
                );
          final selectedColor = colorOptions.isEmpty
              ? null
              : colorOptions[safeColorIndex];

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    _RoundIconAction(
                      onTap: Get.back,
                      backgroundColor: mutedSurface,
                      icon: Image.asset(
                        AppAssets.backArrow,
                        width: 18.w,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    _RoundIconAction(
                      onTap: controller.toggleWishlist,
                      backgroundColor: mutedSurface,
                      icon: Image.asset(
                        AppAssets.heart,
                        width: 18.w,
                        color: controller.isWishlisted.value
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 380.h,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: galleryImages.isEmpty
                              ? ProductDetailsController
                                    .fallbackGalleryColors
                                    .length
                              : galleryImages.length,
                          separatorBuilder: (_, _) => SizedBox(width: 10.w),
                          itemBuilder: (context, index) {
                            final tint =
                                ProductDetailsController
                                    .fallbackGalleryColors[index %
                                    ProductDetailsController
                                        .fallbackGalleryColors
                                        .length];
                            final image = galleryImages.isEmpty
                                ? null
                                : galleryImages[index];
                            return _GalleryCard(image: image, tint: tint);
                          },
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          controller.productName,
                          style: textTheme.titleLarge?.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Text(
                              controller.priceLabel,
                              style: textTheme.headlineSmall?.copyWith(
                                color: colorScheme.primary,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (controller.oldPriceLabel != null) ...[
                              SizedBox(width: 10.w),
                              Text(
                                controller.oldPriceLabel!,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _OptionTile(
                        label: 'Size',
                        backgroundColor: mutedSurface,
                        trailing: InkWell(
                          onTap: () => _showSizePicker(context),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.selectedSize.value,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: colorScheme.onSurface,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _OptionTile(
                        label: 'Color',
                        backgroundColor: mutedSurface,
                        trailing: InkWell(
                          onTap: () => _showColorPicker(context),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedColor?.name ?? '-',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                if (selectedColor != null)
                                  Container(
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedColor.color,
                                      border: Border.all(
                                        color: colorScheme.outline.withValues(
                                          alpha: 0.35,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 10.w),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: colorScheme.onSurface,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _OptionTile(
                        label: 'Quantity',
                        backgroundColor: mutedSurface,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QuantityAction(
                              icon: Icons.remove,
                              onTap: () => controller.updateQuantity(-1),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              '${controller.quantity.value}',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            _QuantityAction(
                              icon: Icons.add,
                              onTap: () => controller.updateQuantity(1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          controller.description,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 15.sp,
                            color: mutedText,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
              _AddToBagButton(
                priceLabel: controller.priceLabel,
                gradient: buttonGradient,
                isLoading: controller.isAddingToBag.value,
                onTap: controller.addToBag,
              ),
              SizedBox(height: 14.h),
            ],
          );
        }),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.colorScheme,
  });

  final String message;
  final VoidCallback onRetry;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 48.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 14.h),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.child,
    required this.onClose,
  });

  final String title;
  final Widget child;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF20222B) : const Color(0xFFF7F7F7);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClose,
                      customBorder: const CircleBorder(),
                      child: Ink(
                        width: 40.w,
                        height: 40.h,
                        child: Icon(
                          Icons.close_rounded,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerOptionTile extends StatelessWidget {
  const _PickerOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final trailingWidget = trailing;
    final unselectedColor = isDark
        ? const Color(0xFF2D2F39)
        : const Color(0xFFECECEE);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Ink(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: selected ? null : unselectedColor,
            gradient: selected
                ? LinearGradient(
                    colors: <Color>[
                      colorScheme.primary,
                      isDark
                          ? colorScheme.primary.withValues(alpha: 0.8)
                          : const Color(0xFF7A5ADE),
                    ],
                  )
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              ...?(trailingWidget != null ? <Widget>[trailingWidget] : null),
              if (selected) ...[
                ...?(trailingWidget != null
                    ? <Widget>[SizedBox(width: 14.w)]
                    : null),
                Icon(
                  Icons.check_rounded,
                  color: colorScheme.onPrimary,
                  size: 24.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconAction extends StatelessWidget {
  const _RoundIconAction({
    required this.onTap,
    required this.backgroundColor,
    required this.icon,
  });

  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 42.w,
          height: 42.h,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.tint, this.image});

  final Color tint;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final parsed = image?.trim();
    final imageBytes = parsed == null ? null : _decodeImage(parsed);
    final isNetworkImage =
        parsed != null &&
        (parsed.startsWith('http://') || parsed.startsWith('https://'));

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: 260.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tint.withValues(alpha: 0.93),
              tint.withValues(alpha: 0.78),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: -54.h,
              left: -30.w,
              right: -30.w,
              child: Container(
                height: 170.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.26),
                ),
              ),
            ),
            Positioned(
              top: 14.h,
              right: 12.w,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.92),
                  BlendMode.srcIn,
                ),
                child: Image.asset(AppAssets.logo, width: 23.w, height: 23.h),
              ),
            ),
            if (isNetworkImage)
              Image.network(
                parsed,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackIcon(),
              )
            else if (imageBytes != null)
              Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackIcon(),
              )
            else
              _fallbackIcon(),
          ],
        ),
      ),
    );
  }

  Uint8List? _decodeImage(String raw) {
    try {
      final base64Payload = raw.contains(',') ? raw.split(',').last : raw;
      return base64Decode(base64Payload);
    } catch (_) {
      return null;
    }
  }

  Widget _fallbackIcon() {
    return Center(
      child: Icon(
        Icons.checkroom_rounded,
        size: 86.sp,
        color: Colors.white.withValues(alpha: 0.82),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.backgroundColor,
    required this.trailing,
  });

  final String label;
  final Color backgroundColor;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: onSurface,
            ),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

class _QuantityAction extends StatelessWidget {
  const _QuantityAction({required this.icon, required this.onTap});

  final IconData icon;
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
          width: 42.w,
          height: 42.h,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.onPrimary, size: 20.sp),
        ),
      ),
    );
  }
}

class _AddToBagButton extends StatelessWidget {
  const _AddToBagButton({
    required this.priceLabel,
    required this.gradient,
    required this.isLoading,
    required this.onTap,
  });

  final String priceLabel;
  final List<Color> gradient;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onTap,
            borderRadius: BorderRadius.circular(30.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
              child: Row(
                children: [
                  Text(
                    priceLabel,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (isLoading)
                    SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  if (isLoading) SizedBox(width: 10.w),
                  Text(
                    isLoading ? 'Adding...' : 'Add to Bag',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
