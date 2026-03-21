import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';

/// Controller for managing car image capture state.
/// Handles image storage, selection, and UI state for different vehicle angles.
class CarCaptureController extends ChangeNotifier {
  CarCaptureController();

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

  static double getLeftPosition(AicycleCarAngle angle) {
    switch (angle) {
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

  static double getRotateAngle(AicycleCarAngle angle) {
    double degrees = 0;
    switch (angle) {
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
}
