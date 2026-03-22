import 'package:aicycle_buyme_plus/src/config/aicycle_config.dart';
import 'package:aicycle_buyme_plus/src/core/extension/car_angle_ext.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';

class FirstGuidePopup extends StatelessWidget {
  const FirstGuidePopup({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black54,
        alignment: Alignment.center,
        child: RotatedBox(
          quarterTurns: 1,
          child: Container(
            width: 416.h,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppStrings.startCapture} ${AicycleCarAngle.exterior.title}',
                        style: AppTextStyles.bodySemibold,
                      ),
                      SizedBox(height: 4.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppStrings.firstGuide1,
                              style: AppTextStyles.bodyRegular,
                            ),
                            TextSpan(
                              text: AppStrings.firstGuide2,
                              style: AppTextStyles.bodySemibold,
                            ),
                            TextSpan(
                              text: AppStrings.firstGuide3,
                              style: AppTextStyles.bodyRegular,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Assets.images.imgXguide.image(
                        package: AppStrings.package,
                        height: 112.w,
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColors.borderGray, height: 1),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: ElevatedButton.icon(
                    onPressed: onTap,
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
                      AppStrings.openCamera,
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
