import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/utils/screen_utils.dart';
import '../controllers/camera_controller.dart';
import '../pages/camera_page.dart';

class CameraBottomBar extends StatelessWidget {
  const CameraBottomBar({
    super.key,
    required this.controller,
    required this.orientation,
    required this.turns,
    required this.args,
    required this.supportGuide,
  });

  final XCameraController controller;
  final NativeDeviceOrientation orientation;
  final double turns;
  final CameraArgs args;
  final bool supportGuide;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Visibility(
        visible: controller.capturedImage == null,
        child: Container(
          height: 100.h,
          color: Colors.black54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// Gallery Button
              InkWell(
                onTap: () => controller.pickImageFromGallery(orientation),
                child: Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderGray, width: 1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                      size: 24.r,
                    ),
                  ),
                ),
              ),

              // Capture Button
              GestureDetector(
                onTap: () => controller.takePicture(orientation),
                child: Container(
                  width: 58.r,
                  height: 58.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 24.r,
                    ),
                  ),
                ),
              ),

              // Frame Button
              if (supportGuide)
                InkWell(
                  onTap: controller.toggleFrame,
                  child: SizedBox(
                    width: 48.r,
                    height: 48.r,
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
                )
              else
                SizedBox(width: 48.r, height: 48.r),
            ],
          ),
        ),
      ),
    );
  }
}
