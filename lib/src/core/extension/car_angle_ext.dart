import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:aicycle_buyme_plus/gen/assets.gen.dart';

import '../../../aicycle_buyme_plus.dart';

extension CarAngleExt on AicycleCarAngle {
  String get id {
    switch (this) {
      case AicycleCarAngle.front:
        return 'truoc-sT9qgX';
      case AicycleCarAngle.frontLeft:
        return '45-trai-truoc-C1xM02';
      case AicycleCarAngle.frontRight:
        return '45-phai-truoc-UoYzs6';
      case AicycleCarAngle.rear:
        return 'sau-htBwjB';
      case AicycleCarAngle.rearLeft:
        return '45-trai-sau-1q3G3J';
      case AicycleCarAngle.rearRight:
        return '45-phai-sau-fRzY3r';
      case AicycleCarAngle.left:
        return 'trai-MyuVUE';
      case AicycleCarAngle.right:
        return 'phai-4wif2Z';
      case AicycleCarAngle.regStamp:
        return 'tem-dang-kiem-LC81Ar';
      case AicycleCarAngle.vinNumber:
        return 'so-khung-qmqAsM';
      case AicycleCarAngle.taplo:
        return 'tap-lo-H4SHs1';
      case AicycleCarAngle.regCert:
        return 'dang-kiem-xe-82YjAa';
      case AicycleCarAngle.exterior:
        return '45-trai-truoc-C1xM02';
    }
  }

  String get title {
    final config = AiCycleBuyMe.config;
    final displayName =
        config.displayConfig.carAnglesWithDisplayName[this]?.toLowerCase() ??
        AppStrings.noDisplayName.toLowerCase();

    switch (this) {
      case AicycleCarAngle.front:
        return AppStrings.frontCaptureTitle(displayName);
      case AicycleCarAngle.frontLeft:
        return AppStrings.frontLeftCaptureTitle(displayName);
      case AicycleCarAngle.frontRight:
        return AppStrings.frontRightCaptureTitle(displayName);
      case AicycleCarAngle.rear:
        return AppStrings.rearCaptureTitle(displayName);
      case AicycleCarAngle.rearLeft:
        return AppStrings.rearLeftCaptureTitle(displayName);
      case AicycleCarAngle.rearRight:
        return AppStrings.rearRightCaptureTitle(displayName);
      case AicycleCarAngle.left:
        return AppStrings.leftCaptureTitle(displayName);
      case AicycleCarAngle.right:
        return AppStrings.rightCaptureTitle(displayName);
      default:
        return displayName;
    }
  }

  String get description {
    switch (this) {
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
    switch (this) {
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
