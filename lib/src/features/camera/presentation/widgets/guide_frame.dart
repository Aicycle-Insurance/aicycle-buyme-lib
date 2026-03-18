import 'package:aicycle_buyme_plus/src/config/aicycle_config.dart';
import 'package:aicycle_buyme_plus/src/core/utils/orientation_utils.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/utils/screen_utils.dart';

class GuideFrame extends StatelessWidget {
  GuideFrame({
    super.key,
    required this.carCorner,
    this.orientation = NativeDeviceOrientation.portraitUp,
  });

  final AicycleCarAngle carCorner;
  final NativeDeviceOrientation orientation;

  String get imagePath {
    switch (carCorner) {
      case AicycleCarAngle.front:
        return Assets.images.front.imgFrameFront.path;
      case AicycleCarAngle.frontLeft:
        return Assets.images.frontLeft.imgFrameFrontLeft.path;
      case AicycleCarAngle.frontRight:
        return Assets.images.frontRight.imgFrameFrontRight.path;
      case AicycleCarAngle.rear:
        return Assets.images.rear.imgFrameRear.path;
      case AicycleCarAngle.rearLeft:
        return Assets.images.rearLeft.imgFrameRearLeft.path;
      case AicycleCarAngle.rearRight:
        return Assets.images.rearRight.imgFrameRearRight.path;
      case AicycleCarAngle.left:
        return '';
      case AicycleCarAngle.right:
        return '';
    }
  }

  final ValueNotifier<double> _scaleValue = ValueNotifier<double>(1);

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return const SizedBox.shrink();
    }

    final turns = OrientationUtils.getTurns(orientation);

    return AnimatedRotation(
      turns: turns,
      duration: const Duration(milliseconds: 300),
      child: ValueListenableBuilder(
        valueListenable: _scaleValue,
        builder: (context, value, child) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 16.h,
                  bottom: 16.h,
                  left: 16.h,
                  right: 122.h,
                ),
                child: Center(
                  child: Transform.scale(
                    scale: _scaleValue.value,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      package: AppStrings.package,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h, right: (60 + 122).h),
                  child: SizedBox(
                    height: 14.h,
                    width: 155.h,
                    child: Slider.adaptive(
                      min: 0.5,
                      max: 1,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white38,
                      value: _scaleValue.value,
                      onChanged: (value) {
                        _scaleValue.value = value;
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
