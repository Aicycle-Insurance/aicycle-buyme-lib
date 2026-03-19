import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';

/// Controller for managing car image capture state.
/// Handles image storage, selection, and UI state for different vehicle angles.
class CarCaptureController extends ChangeNotifier {
  CarCaptureController({
    AicycleCarAngle? angle,
    Map<AicycleCarAngle, List<String>> initialImages = const {},
    this.onImageAdded,
    this.onImageDeleted,
    this.serverImagesNotifier,
  }) : _imagesMap = Map.from(
         initialImages,
       ).map((key, value) => MapEntry(key, List<String>.from(value))),
       _angle = angle {
    // Subscribe ngay khi khởi tạo nếu có notifier
    serverImagesNotifier?.addListener(_onServerImagesUpdated);
    // Sync giá trị hiện tại ngay lập tức (nếu data đã sẵn)
    if (serverImagesNotifier?.value.isNotEmpty == true) {
      syncImages(serverImagesNotifier!.value);
    }
  }

  /// Notifier từ [BuyMeController] — CarCaptureController không biết
  /// BuyMeController là ai, chỉ biết nó sẽ nhận Map ảnh từ notifier này.
  final ValueNotifier<Map<AicycleCarAngle, List<String>>>? serverImagesNotifier;

  /// The currently active vehicle angle being captured or viewed.
  AicycleCarAngle? _angle;
  AicycleCarAngle? get angle => _angle;

  /// Internal storage for images categorized by vehicle angle.
  final Map<AicycleCarAngle, List<String>> _imagesMap;

  /// Temporary storage for image selection in the guide page.
  final List<String> _selectedImages = [];

  /// Callback triggered when a new image is added to a specific angle.
  final Function(AicycleCarAngle, String)? onImageAdded;

  /// Callback triggered when an image is deleted from a specific angle.
  final Function(AicycleCarAngle, String)? onImageDeleted;

  /// Returns the list of images for the currently active angle.
  List<String> get images => _angle != null ? (_imagesMap[_angle] ?? []) : [];

  /// Returns the list of selected image paths for deletion.
  List<String> get selectedImages => List.unmodifiable(_selectedImages);

  /// Whether to show the delete button in the UI.
  bool get showDeleteButton => _selectedImages.isNotEmpty;

  /// Retrieves the list of images for a specific vehicle angle.
  List<String> getImagesForAngle(AicycleCarAngle angle) =>
      _imagesMap[angle] ?? [];

  /// Sync ảnh từ server vào map nội bộ.
  /// Với mỗi góc, nếu url server chưa có trong list thì prepend vào đầu
  /// (ảnh local mới chụp vẫn giữ nguyên ở cuối).
  void syncImages(Map<AicycleCarAngle, List<String>> serverImages) {
    for (final entry in serverImages.entries) {
      final angle = entry.key;
      final serverUrls = entry.value;
      final existing = _imagesMap[angle] ?? [];
      // Thêm url server chưa có trong existing (tránh duplicate)
      final toAdd = serverUrls.where((u) => !existing.contains(u)).toList();
      if (toAdd.isNotEmpty) {
        _imagesMap[angle] = [...toAdd, ...existing];
      }
    }
    notifyListeners();
  }

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
    return degrees * 3.1415926535897932 / 180;
  }

  void setAngle(AicycleCarAngle angle) {
    _angle = angle;
    notifyListeners();
  }

  String get title {
    if (_angle == null) return '';
    switch (_angle!) {
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
    if (_angle == null) return '';
    switch (_angle!) {
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
    if (_angle == null) return [];
    switch (_angle!) {
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

  void addImage(XFile? file) {
    if (file == null || _angle == null) return;
    final path = file.path;
    final list = _imagesMap[_angle!] ?? [];
    if (!list.contains(path)) {
      list.add(path);
      _imagesMap[_angle!] = list;
      onImageAdded?.call(_angle!, path);
      notifyListeners();
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

  void deleteSelectedImages() {
    if (_angle == null) return;
    final list = _imagesMap[_angle!] ?? [];
    for (final url in _selectedImages) {
      list.remove(url);
      onImageDeleted?.call(_angle!, url);
    }
    _imagesMap[_angle!] = list;
    _selectedImages.clear();
    notifyListeners();
  }

  void _onServerImagesUpdated() {
    final data = serverImagesNotifier?.value;
    if (data != null && data.isNotEmpty) syncImages(data);
  }

  @override
  void dispose() {
    serverImagesNotifier?.removeListener(_onServerImagesUpdated);
    super.dispose();
  }
}
