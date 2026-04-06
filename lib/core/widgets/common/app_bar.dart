import 'package:clot_ecommerce_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleColor,
    this.elevation,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTitleColor = titleColor ?? theme.colorScheme.onSurface;
    final effectiveBackButtonColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;

    return SafeArea(
      child: PreferredSize(
        preferredSize: preferredSize,
        child: Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: Row(
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    margin: EdgeInsets.only(left: 16.w),
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: effectiveBackButtonColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AppAssets.backArrow,
                      width: 24.w,
                      height: 24.h,
                      color: effectiveTitleColor,
                    ),
                  ),
                ),
              SizedBox(width: showBackButton ? 16.w : 0),
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: effectiveTitleColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
    // AppBar(
    //   leading:
    //       leading ??
    //       (showBackButton
    //           ? IconButton(
    //               icon: const Icon(Icons.arrow_back_ios_new, size: 20),
    //               onPressed: () => Get.back(),
    //             )
    //           : null),
    //   title: title != null
    //       ? Text(
    //           title!,
    //           style: TextStyle(
    //             color: titleColor ?? AppColors.onBackgroundColor,
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         )
    //       : null,
    //   actions: actions,
    //   backgroundColor: backgroundColor ?? Colors.transparent,
    //   elevation: elevation ?? 0,
    //   centerTitle: true,
    //   bottom: bottom,
    // );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
