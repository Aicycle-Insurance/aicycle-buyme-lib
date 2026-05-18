import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/utils/screen_utils.dart';
import '../controllers/camera_controller.dart';

class CameraTopBar extends StatelessWidget {
  const CameraTopBar({
    super.key,
    required this.turns,
    required this.controller,
    required this.onBack,
    this.showGuidleFrameButton = true,
  });

  final double turns;
  final XCameraController controller;
  final Function() onBack;
  final bool showGuidleFrameButton;

  IconData _getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.torch:
        return Icons.highlight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 16.r,
          left: 16.r,
          child: SafeArea(
            child: InkWell(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: AnimatedRotation(
                  turns: turns,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.r,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16.r,
          right: 16.r,
          child: SafeArea(
            child: Column(
              children: [
                InkWell(
                  onTap: controller.toggleFlash,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedRotation(
                      turns: turns,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _getFlashIcon(controller.flashMode),
                        color: Colors.white,
                        size: 24.r,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                if (showGuidleFrameButton)
                  InkWell(
                    onTap: controller.toggleFrame,
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: AnimatedRotation(
                        turns: turns,
                        duration: const Duration(milliseconds: 300),
                        child: Image.asset(
                          controller.showFrame
                              ? Assets.images.icFrameOn.path
                              : Assets.images.icFrameOff.path,
                          package: AppStrings.package,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
