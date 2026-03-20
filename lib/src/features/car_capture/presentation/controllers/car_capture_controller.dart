import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';

/// Controller for managing car image capture state.
/// Handles image storage, selection, and UI state for different vehicle angles.
class CarCaptureController extends ChangeNotifier {
  CarCaptureController(AicycleCarAngle angle) : _angle = angle;

  /// The currently active vehicle angle being captured or viewed.
  AicycleCarAngle _angle;

  static const List<AicycleCarAngle> supportedAngle = [
    AicycleCarAngle.front,
    AicycleCarAngle.frontLeft,
    AicycleCarAngle.frontRight,
    AicycleCarAngle.rear,
    AicycleCarAngle.rearLeft,
    AicycleCarAngle.rearRight,
    AicycleCarAngle.left,
    AicycleCarAngle.right,
  ];

  static double getLeftPosition(AicycleCarAngle corner) {
    switch (corner) {
      case AicycleCarAngle.front:
      case AicycleCarAngle.rear:
        return 142; // Center (324/2 - 20)
      case AicycleCarAngle.left:
      case AicycleCarAngle.frontLeft:
      case AicycleCarAngle.rearLeft:
        return 15;
      case AicycleCarAngle.right:
      case AicycleCarAngle.frontRight:
      case AicycleCarAngle.rearRight:
        return 270;
      default:
        return 0;
    }
  }

  static double getTopPosition(AicycleCarAngle corner) {
    switch (corner) {
      case AicycleCarAngle.front:
        return 0;
      case AicycleCarAngle.frontLeft:
      case AicycleCarAngle.frontRight:
        return 50;
      case AicycleCarAngle.rear:
        return 460;
      case AicycleCarAngle.rearLeft:
      case AicycleCarAngle.rearRight:
        return 410;
      case AicycleCarAngle.left:
      case AicycleCarAngle.right:
        return 230;
      default:
        return 0;
    }
  }

  static double getRotateAngle(AicycleCarAngle corner) {
    double degrees = 0;
    switch (corner) {
      case AicycleCarAngle.front:
        degrees = 90;
        break;
      case AicycleCarAngle.frontLeft:
        degrees = 45;
        break;
      case AicycleCarAngle.frontRight:
        degrees = 135;
        break;
      case AicycleCarAngle.rear:
        degrees = -90;
        break;
      case AicycleCarAngle.rearLeft:
        degrees = -45;
        break;
      case AicycleCarAngle.rearRight:
        degrees = -135;
        break;
      case AicycleCarAngle.left:
        degrees = 0;
        break;
      case AicycleCarAngle.right:
        degrees = 180;
        break;
      default:
        degrees = 0;
        break;
    }
    return degrees * pi / 180;
  }

  void setAngle(AicycleCarAngle angle) {
    _angle = angle;
    notifyListeners();
  }

  String get title {
    switch (_angle) {
      case AicycleCarAngle.front:
        return AppStrings.frontCaptureTitle;
      case AicycleCarAngle.frontLeft:
        return AppStrings.frontLeftCaptureTitle;
      case AicycleCarAngle.frontRight:
        return AppStrings.frontRightCaptureTitle;
      case AicycleCarAngle.rear:
        return AppStrings.rearCaptureTitle;
      case AicycleCarAngle.rearLeft:
        return AppStrings.rearLeftCaptureTitle;
      case AicycleCarAngle.rearRight:
        return AppStrings.rearRightCaptureTitle;
      case AicycleCarAngle.left:
        return AppStrings.leftCaptureTitle;
      case AicycleCarAngle.right:
        return AppStrings.rightCaptureTitle;
      default:
        return '';
    }
  }

  String get description {
    switch (_angle) {
      case AicycleCarAngle.front:
        return AppStrings.frontCaptureDescription;
      case AicycleCarAngle.frontLeft:
        return AppStrings.frontLeftCaptureDescription;
      case AicycleCarAngle.frontRight:
        return AppStrings.frontRightCaptureDescription;
      case AicycleCarAngle.rear:
        return AppStrings.rearCaptureDescription;
      case AicycleCarAngle.rearLeft:
        return AppStrings.rearLeftCaptureDescription;
      case AicycleCarAngle.rearRight:
        return AppStrings.rearRightCaptureDescription;
      case AicycleCarAngle.left:
        return AppStrings.leftCaptureDescription;
      case AicycleCarAngle.right:
        return AppStrings.rightCaptureDescription;
      default:
        return '';
    }
  }

  List<String> get sampleImages {
    switch (_angle) {
      case AicycleCarAngle.front:
        return [Assets.images.front.imgFront.path];
      case AicycleCarAngle.frontLeft:
        return [
          Assets.images.frontLeft.imgFrontLeft1.path,
          Assets.images.frontLeft.imgFrontLeft2.path,
          Assets.images.frontLeft.imgFrontLeft3.path,
          Assets.images.frontLeft.imgFrontLeft4.path,
        ];
      case AicycleCarAngle.frontRight:
        return [
          Assets.images.frontRight.imgFrontRight1.path,
          Assets.images.frontRight.imgFrontRight2.path,
          Assets.images.frontRight.imgFrontRight3.path,
          Assets.images.frontRight.imgFrontRight4.path,
        ];
      case AicycleCarAngle.rear:
        return [Assets.images.rear.imgRear.path];
      case AicycleCarAngle.rearLeft:
        return [
          Assets.images.rearLeft.imgRearLeft1.path,
          Assets.images.rearLeft.imgRearLeft2.path,
          Assets.images.rearLeft.imgRearLeft3.path,
        ];
      case AicycleCarAngle.rearRight:
        return [
          Assets.images.rearRight.imgRearRight1.path,
          Assets.images.rearRight.imgRearRight2.path,
          Assets.images.rearRight.imgRearRight3.path,
        ];
      case AicycleCarAngle.left:
        return [Assets.images.left.imgLeft.path];
      case AicycleCarAngle.right:
        return [Assets.images.right.imgRight.path];
      default:
        return [];
    }
  }
}
