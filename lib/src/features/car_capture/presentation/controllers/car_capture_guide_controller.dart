import 'package:flutter/material.dart';
import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';

class CarCaptureGuideController extends ChangeNotifier {
  CarCaptureGuideController({
    required this.corner,
    List<String> initialImages = const [],
  }) : _images = initialImages;

  final AicycleCarAngle corner;
  final List<String> _images;
  final List<String> _selectedImages = [];

  List<String> get images => _images;
  List<String> get selectedImages => List.unmodifiable(_selectedImages);
  bool get showDeleteButton => _selectedImages.isNotEmpty;

  String get title {
    switch (corner) {
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
    }
  }

  String get description {
    switch (corner) {
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
    }
  }

  List<String> get sampleImages {
    switch (corner) {
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
    }
  }

  void toggleImageSelection(String url) {
    if (_selectedImages.contains(url)) {
      _selectedImages.remove(url);
    } else {
      _selectedImages.add(url);
    }
    notifyListeners();
  }

  bool isSelected(String url) => _selectedImages.contains(url);

  void goToCameraPage() {
    // TODO: implement navigation logic if needed within controller or via callback
  }

  void deleteSelectedImages() {
    _images.removeWhere((image) => _selectedImages.contains(image));
    _selectedImages.clear();
    notifyListeners();
  }
}
