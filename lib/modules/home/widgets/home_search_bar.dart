import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_assets.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.surfaceMuted, required this.colors});
  final Color surfaceMuted;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        style: TextStyle(fontSize: 14.sp, color: colors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 14.sp, color: colors.onSurfaceVariant),
          prefixIcon: Padding(
            padding: EdgeInsets.all(13.r),
            child: Image.asset(
              AppAssets.search,
              width: 20.w,
              height: 20.h,
              color: colors.onSurfaceVariant,
            ),
          ),
          filled: true,
          fillColor: surfaceMuted,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.r),
            borderSide: BorderSide(
              color: colors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
