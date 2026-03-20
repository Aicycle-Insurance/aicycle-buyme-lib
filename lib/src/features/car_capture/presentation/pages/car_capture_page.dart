import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/di/injection.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../controllers/car_capture_controller.dart';
import '../widgets/corner_button.dart';

/// Page displaying a 3D vehicle model with interactive hotspots (dots) for each capture angle.
/// Acts as the entry point for the exterior photo capture flow.
class CarCapturePage extends StatefulWidget {
  const CarCapturePage({super.key});

  @override
  State<CarCapturePage> createState() => _CarCapturePageState();
}

class _CarCapturePageState extends State<CarCapturePage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sl.vehicleImageVault,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            title: Text(
              AppStrings.photoExterior,
              style: AppTextStyles.heading2,
            ),
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
                    ...CarCaptureController.supportedAngle.map((angle) {
                      return Positioned(
                        left: CarCaptureController.getLeftPosition(angle).w,
                        top: CarCaptureController.getTopPosition(angle).h,
                        child: CornerButton(angle: angle),
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
                onPressed: () => Navigator.pop(context),
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
      },
    );
  }
}
