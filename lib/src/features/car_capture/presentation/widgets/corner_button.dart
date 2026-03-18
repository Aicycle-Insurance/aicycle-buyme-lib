import 'dart:math';

import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_strings.dart';
import '../pages/car_capture_guide_page.dart';

class CornerButton extends StatelessWidget {
  const CornerButton({super.key, required this.corner, this.images = const []});

  final AicycleCarCorner corner;
  final List<String> images;

  double get rotateAngle {
    double degrees = 0;
    switch (corner) {
      case AicycleCarCorner.front:
        degrees = 90;
        break;
      case AicycleCarCorner.frontLeft:
        degrees = 45;
        break;
      case AicycleCarCorner.frontRight:
        degrees = 135;
        break;
      case AicycleCarCorner.rear:
        degrees = -90;
        break;
      case AicycleCarCorner.rearLeft:
        degrees = -45;
        break;
      case AicycleCarCorner.rearRight:
        degrees = -135;
        break;
      case AicycleCarCorner.left:
        degrees = 0;
        break;
      case AicycleCarCorner.right:
        degrees = 180;
        break;
    }
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarCaptureGuidePage(corner: corner),
          ),
        );
      },
      child: Transform.rotate(
        angle: rotateAngle,
        child: Assets.images.icArrowRight.image(
          package: AppStrings.package,
          height: 40.h,
          width: 40.h,
        ),
      ),
    );
  }
}
