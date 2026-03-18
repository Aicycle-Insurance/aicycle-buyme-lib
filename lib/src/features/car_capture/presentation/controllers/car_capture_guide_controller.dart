import 'package:flutter/material.dart';
import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';

class CarCaptureGuideController extends ChangeNotifier {
  CarCaptureGuideController({
    required this.corner,
    List<String> initialImages = const [],
  }) : _images = initialImages;

  final AicycleCarCorner corner;
  final List<String> _images;
  final List<String> _selectedImages = [];

  List<String> get images => _images;
  List<String> get selectedImages => List.unmodifiable(_selectedImages);
  bool get showDeleteButton => _selectedImages.isNotEmpty;

  String get title {
    switch (corner) {
      case AicycleCarCorner.front:
        return AppStrings.frontCaptureTitle;
      case AicycleCarCorner.frontLeft:
        return AppStrings.frontLeftCaptureTitle;
      case AicycleCarCorner.frontRight:
        return AppStrings.frontRightCaptureTitle;
      case AicycleCarCorner.rear:
        return AppStrings.rearCaptureTitle;
      case AicycleCarCorner.rearLeft:
        return AppStrings.rearLeftCaptureTitle;
      case AicycleCarCorner.rearRight:
        return AppStrings.rearRightCaptureTitle;
      case AicycleCarCorner.left:
        return AppStrings.leftCaptureTitle;
      case AicycleCarCorner.right:
        return AppStrings.rightCaptureTitle;
    }
  }

  String get description {
    switch (corner) {
      case AicycleCarCorner.front:
        return AppStrings.frontCaptureDescription;
      case AicycleCarCorner.frontLeft:
        return AppStrings.frontLeftCaptureDescription;
      case AicycleCarCorner.frontRight:
        return AppStrings.frontRightCaptureDescription;
      case AicycleCarCorner.rear:
        return AppStrings.rearCaptureDescription;
      case AicycleCarCorner.rearLeft:
        return AppStrings.rearLeftCaptureDescription;
      case AicycleCarCorner.rearRight:
        return AppStrings.rearRightCaptureDescription;
      case AicycleCarCorner.left:
        return AppStrings.leftCaptureDescription;
      case AicycleCarCorner.right:
        return AppStrings.rightCaptureDescription;
    }
  }

  List<String> get sampleImages {
    switch (corner) {
      case AicycleCarCorner.front:
        return [Assets.images.front.imgFront.path];
      case AicycleCarCorner.frontLeft:
        return [
          Assets.images.frontLeft.imgFrontLeft1.path,
          Assets.images.frontLeft.imgFrontLeft2.path,
          Assets.images.frontLeft.imgFrontLeft3.path,
          Assets.images.frontLeft.imgFrontLeft4.path,
        ];
      case AicycleCarCorner.frontRight:
        return [
          Assets.images.frontRight.imgFrontRight1.path,
          Assets.images.frontRight.imgFrontRight2.path,
          Assets.images.frontRight.imgFrontRight3.path,
          Assets.images.frontRight.imgFrontRight4.path,
        ];
      case AicycleCarCorner.rear:
        return [Assets.images.rear.imgRear.path];
      case AicycleCarCorner.rearLeft:
        return [
          Assets.images.rearLeft.imgRearLeft1.path,
          Assets.images.rearLeft.imgRearLeft2.path,
          Assets.images.rearLeft.imgRearLeft3.path,
        ];
      case AicycleCarCorner.rearRight:
        return [
          Assets.images.rearRight.imgRearRight1.path,
          Assets.images.rearRight.imgRearRight2.path,
          Assets.images.rearRight.imgRearRight3.path,
        ];
      case AicycleCarCorner.left:
        return [Assets.images.left.imgLeft.path];
      case AicycleCarCorner.right:
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
