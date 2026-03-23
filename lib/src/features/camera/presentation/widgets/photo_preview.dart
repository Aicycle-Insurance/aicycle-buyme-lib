import 'dart:io';

import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/extension/xx_file.dart';

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    super.key,
    required this.image,
    required this.onRetake,
    required this.onSave,
    this.isUploading = false,
  });

  final XXFile image;
  final VoidCallback onRetake;
  final VoidCallback onSave;
  final bool isUploading;

  int get turns {
    switch (image.orientation) {
      case NativeDeviceOrientation.landscapeLeft:
        return 1;
      case NativeDeviceOrientation.landscapeRight:
        return -1;
      case NativeDeviceOrientation.portraitDown:
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: RotatedBox(
              quarterTurns: turns,
              child: Image.file(File(image.path), fit: BoxFit.contain),
            ),
          ),
          if (!isUploading)
            Positioned(
              bottom: 24.h,
              left: 24.h,
              child: RotatedBox(
                quarterTurns: 1,
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Button Chụp lại
                      InkWell(
                        onTap: isUploading ? null : onRetake,
                        child: Container(
                          height: 40.h,
                          width: 115.h,
                          decoration: BoxDecoration(
                            color: isUploading ? Colors.grey : Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              AppStrings.btnRetake,
                              style: AppTextStyles.button.copyWith(
                                color: isUploading
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.r),

                      /// Button Lưu
                      InkWell(
                        onTap: isUploading ? null : onSave,
                        child: Container(
                          height: 40.h,
                          width: 115.h,
                          decoration: BoxDecoration(
                            color: isUploading
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: isUploading
                                ? SizedBox(
                                    width: 20.r,
                                    height: 20.r,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    AppStrings.btnSave,
                                    style: AppTextStyles.button,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: Container(
                  width: 300.h,
                  padding: EdgeInsets.all(16.r),
                  margin: EdgeInsets.all(40.r),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                        color: AppColors.black.withValues(alpha: 0.08),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.gif.loading.image(
                        height: 80.h,
                        fit: BoxFit.contain,
                        package: AppStrings.package,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppStrings.isProcessing,
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
