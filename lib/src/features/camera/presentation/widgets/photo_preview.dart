import 'dart:io';

import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../core/theme/app_strings.dart';
import '../../../../core/extension/xx_file.dart';

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    super.key,
    required this.image,
    required this.onRetake,
    required this.onSave,
  });

  final XXFile image;
  final VoidCallback onRetake;
  final VoidCallback onSave;

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
                      onTap: onRetake,
                      child: Container(
                        height: 40.h,
                        width: 115.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            AppStrings.btnRetake,
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.r),

                    /// Button Lưu
                    InkWell(
                      onTap: onSave,
                      child: Container(
                        height: 40.h,
                        width: 115.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
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
          ),
        ],
      ),
    );
  }
}
