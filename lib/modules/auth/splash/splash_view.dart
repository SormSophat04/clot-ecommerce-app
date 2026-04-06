import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputFillColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Tell us About yourself',
                style: TextStyle(
                  fontSize: 27.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            SizedBox(height: 48.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Who do you shop for ?',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.setGender('Men'),
                      child: Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: controller.selectedGender.value == 'Men'
                              ? colorScheme.primary
                              : inputFillColor,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Men',
                          style: TextStyle(
                            color: controller.selectedGender.value == 'Men'
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.setGender('Women'),
                      child: Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: controller.selectedGender.value == 'Women'
                              ? colorScheme.primary
                              : inputFillColor,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Women',
                          style: TextStyle(
                            color: controller.selectedGender.value == 'Women'
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
            SizedBox(height: 48.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'How Old are you ?',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Drag Handle
                            Container(
                              width: 40.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: colorScheme.outline.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'How Old are you ?',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Obx(() => Column(
                              children: controller.ageRanges.map((age) => GestureDetector(
                                onTap: () {
                                  controller.setAgeRange(age);
                                  Get.back();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  decoration: BoxDecoration(
                                    color: controller.selectedAgeRange.value == age
                                        ? colorScheme.primary
                                        : inputFillColor,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    age,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedAgeRange.value == age
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              )).toList(),
                            )),
                          ],
                        ),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  );
                },
                child: Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: inputFillColor,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                        controller.selectedAgeRange.value,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: controller.selectedAgeRange.value == 'Age Range'
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                        ),
                      )),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 24.h,
                bottom: 32.h,
              ),
              decoration: BoxDecoration(
                color: inputFillColor,
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/main-layout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Finish',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
