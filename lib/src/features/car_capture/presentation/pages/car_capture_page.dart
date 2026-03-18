import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../widgets/corner_button.dart';

class CarCapturePage extends StatelessWidget {
  const CarCapturePage({super.key});

  double getLeftPosition(AicycleCarAngle corner) {
    switch (corner) {
      case AicycleCarAngle.front:
      case AicycleCarAngle.rear:
        return 142; // Center (324/2 - 20)
      case AicycleCarAngle.left:
      case AicycleCarAngle.frontLeft:
      case AicycleCarAngle.rearLeft:
        return 15;
      case AicycleCarAngle.right:
      case AicycleCarAngle.frontRight:
      case AicycleCarAngle.rearRight:
        return 270;
    }
  }

  double getTopPosition(AicycleCarAngle corner) {
    switch (corner) {
      case AicycleCarAngle.front:
        return 0;
      case AicycleCarAngle.frontLeft:
      case AicycleCarAngle.frontRight:
        return 50;
      case AicycleCarAngle.rear:
        return 460;
      case AicycleCarAngle.rearLeft:
      case AicycleCarAngle.rearRight:
        return 410;
      case AicycleCarAngle.left:
      case AicycleCarAngle.right:
        return 230;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(AppStrings.photoExterior, style: AppTextStyles.heading2),
      ),
      body: SizedBox.expand(
        child: Center(
          child: SizedBox(
            height: 500.h,
            width: 324.w,
            child: Stack(
              children: [
                Center(
                  child: Assets.images.imgCar.image(
                    package: AppStrings.package,
                    width: 200.w,
                  ),
                ),
                ...AicycleCarAngle.values.map((corner) {
                  return Positioned(
                    left: getLeftPosition(corner).w,
                    top: getTopPosition(corner).h,
                    child: CornerButton(corner: corner),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              elevation: 0,
            ),
            child: Text(AppStrings.btnDone, style: AppTextStyles.button),
          ),
        ),
      ),
    );
  }
}
