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

  double getLeftPosition(AicycleCarCorner corner) {
    switch (corner) {
      case AicycleCarCorner.front:
      case AicycleCarCorner.rear:
        return 142; // Center (324/2 - 20)
      case AicycleCarCorner.left:
      case AicycleCarCorner.frontLeft:
      case AicycleCarCorner.rearLeft:
        return 15;
      case AicycleCarCorner.right:
      case AicycleCarCorner.frontRight:
      case AicycleCarCorner.rearRight:
        return 270;
    }
  }

  double getTopPosition(AicycleCarCorner corner) {
    switch (corner) {
      case AicycleCarCorner.front:
        return 0;
      case AicycleCarCorner.frontLeft:
      case AicycleCarCorner.frontRight:
        return 50;
      case AicycleCarCorner.rear:
        return 460;
      case AicycleCarCorner.rearLeft:
      case AicycleCarCorner.rearRight:
        return 410;
      case AicycleCarCorner.left:
      case AicycleCarCorner.right:
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
                ...AicycleCarCorner.values.map((corner) {
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
