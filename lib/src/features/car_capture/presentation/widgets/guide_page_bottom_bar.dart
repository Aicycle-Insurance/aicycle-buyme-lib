import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/car_capture_guide_controller.dart';

class GuidePageBottomBar extends StatelessWidget {
  const GuidePageBottomBar({super.key, required this.controller});

  final CarCaptureGuideController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: controller.images.isEmpty
            ? ElevatedButton.icon(
                onPressed: controller.goToCameraPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 40.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  elevation: 0,
                ),
                icon: Icon(Icons.camera_alt_outlined, size: 20.r),
                label: Text(
                  AppStrings.captureCarPhoto,
                  style: AppTextStyles.button,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.goToCameraPage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.borderGray),
                            minimumSize: Size(double.infinity, 40.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          icon: Image.asset(
                            Assets.images.icCameraPlus.path,
                            package: AppStrings.package,
                            color: AppColors.iconGray,
                            height: 20.h,
                            width: 20.h,
                          ),
                          label: Text(
                            AppStrings.btnCaptureMore,
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.borderGray),
                            minimumSize: Size(double.infinity, 40.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          icon: Image.asset(
                            Assets.images.icColors.path,
                            package: AppStrings.package,
                            color: AppColors.iconGray,
                            height: 20.h,
                            width: 20.h,
                          ),
                          label: Text(
                            AppStrings.btnOtherAngle,
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
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
                    child: Text(
                      AppStrings.btnDone,
                      style: AppTextStyles.button,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
