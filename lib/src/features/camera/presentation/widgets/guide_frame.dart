import 'package:aicycle_buyme_plus/src/config/aicycle_config.dart';
import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/utils/screen_utils.dart';

class GuideFrame extends StatelessWidget {
  GuideFrame({super.key, required this.carCorner});

  final AicycleCarAngle carCorner;

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
      case AicycleCarAngle.right:
        return Assets.images.right.imgFrameRight.path;
      case AicycleCarAngle.left:
        return Assets.images.left.imgFrameLeft.path;
      default:
        return '';
    }
  }

  final ValueNotifier<double> _scaleValue = ValueNotifier<double>(1);

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return const SizedBox.shrink();
    }

    return RotatedBox(
      quarterTurns: 1,
      child: ValueListenableBuilder(
        valueListenable: _scaleValue,
        builder: (context, value, child) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 40.h,
                  bottom: 40.h,
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
                  padding: EdgeInsets.only(top: 40.h, right: (24 + 122).h),
                  child: SizedBox(
                    height: 14.h,
                    width: 155.h,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6.h,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 12.h,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 16.h,
                        ),
                      ),
                      child: Slider(
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
              ),
            ],
          );
        },
      ),
    );
  }
}
