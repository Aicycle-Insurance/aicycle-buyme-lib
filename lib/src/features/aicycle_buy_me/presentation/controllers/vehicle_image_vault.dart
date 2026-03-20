import 'package:flutter/foundation.dart';
import '../../../../../aicycle_buyme_plus.dart';
import '../../domain/entities/directional_image.dart';

/// Góc xe thuộc nhóm exterior (ngoại thất) — không thuộc các section đặc biệt.
// const _exteriorAngles = {
//   AicycleCarAngle.front,
//   AicycleCarAngle.frontLeft,
//   AicycleCarAngle.frontRight,
//   AicycleCarAngle.rear,
//   AicycleCarAngle.rearLeft,
//   AicycleCarAngle.rearRight,
//   AicycleCarAngle.left,
//   AicycleCarAngle.right,
// };

/// Central store for managing all car capture images.
/// Shared across different pages (BuyMePage, CameraPage, CarCapturePage...)
/// via `sl.vehicleImageVault`.
class VehicleImageVault extends ChangeNotifier {
  /// Ảnh các góc cụ thể
  final List<DirectionalImage> _regCertImages = [];
  final List<DirectionalImage> _regStampImages = [];
  final List<DirectionalImage> _vinNumberImages = [];
  final List<DirectionalImage> _taploImages = [];
  final List<DirectionalImage> _frontImages = [];
  final List<DirectionalImage> _frontLeftImages = [];
  final List<DirectionalImage> _frontRightImages = [];
  final List<DirectionalImage> _rearImages = [];
  final List<DirectionalImage> _rearLeftImages = [];
  final List<DirectionalImage> _rearRightImages = [];
  final List<DirectionalImage> _leftImages = [];
  final List<DirectionalImage> _rightImages = [];

  /// Góc ngoại thất nói chung dùng cho trường hợp không có các góc cụ thể
  /// Giám định viên đã có kinh nghiệm và muốn chụp liên tiếp
  final List<DirectionalImage> _exteriorImages = [];

  /// The list of image URLs currently selected for actions (e.g., deletion).
  final List<String> _selectedImages = [];

  /// getters
  List<DirectionalImage> get regCertImages => List.unmodifiable(_regCertImages);
  List<DirectionalImage> get regStampImages =>
      List.unmodifiable(_regStampImages);
  List<DirectionalImage> get vinNumberImages =>
      List.unmodifiable(_vinNumberImages);
  List<DirectionalImage> get taploImages => List.unmodifiable(_taploImages);
  List<DirectionalImage> get frontImages => List.unmodifiable(_frontImages);
  List<DirectionalImage> get frontLeftImages =>
      List.unmodifiable(_frontLeftImages);
  List<DirectionalImage> get frontRightImages =>
      List.unmodifiable(_frontRightImages);
  List<DirectionalImage> get rearImages => List.unmodifiable(_rearImages);
  List<DirectionalImage> get rearLeftImages =>
      List.unmodifiable(_rearLeftImages);
  List<DirectionalImage> get rearRightImages =>
      List.unmodifiable(_rearRightImages);
  List<DirectionalImage> get leftImages => List.unmodifiable(_leftImages);
  List<DirectionalImage> get rightImages => List.unmodifiable(_rightImages);
  List<DirectionalImage> get exteriorImages =>
      List.unmodifiable(_exteriorImages);

  List<String> get selectedImages => List.unmodifiable(_selectedImages);

  /// Thêm ảnh từ server
  void addImagesFromServer(
    AicycleCarAngle angle,
    List<DirectionalImage> images,
  ) {
    switch (angle) {
      case AicycleCarAngle.regCert:
        _regCertImages.addAll(images);
        break;
      case AicycleCarAngle.regStamp:
        _regStampImages.addAll(images);
        break;
      case AicycleCarAngle.vinNumber:
        _vinNumberImages.addAll(images);
        break;
      case AicycleCarAngle.taplo:
        _taploImages.addAll(images);
        break;
      case AicycleCarAngle.front:
        _frontImages.addAll(images);
        _exteriorImages.addAll(images);
        break;
      case AicycleCarAngle.frontLeft:
        _frontLeftImages.addAll(images);
        _exteriorImages.addAll(images);
        break;
      case AicycleCarAngle.frontRight:
        _frontRightImages.addAll(images);
        _exteriorImages.addAll(images);
        break;
      case AicycleCarAngle.rear:
        _rearImages.addAll(images);
        _exteriorImages.addAll(images);
        break;
      case AicycleCarAngle.rearLeft:
        _rearLeftImages.addAll(images);
        _exteriorImages.addAll(images);
        break;
      case AicycleCarAngle.rearRight:
        _rearRightImages.addAll(images);
        _exteriorImages.addAll(images);
        break;
      case AicycleCarAngle.left:
        _leftImages.addAll(images);
        _exteriorImages.addAll(images);
        break;
      case AicycleCarAngle.right:
        _rightImages.addAll(images);
        _exteriorImages.addAll(images);
        break;
      default:
        _exteriorImages.addAll(images);
        break;
    }
    notifyListeners();
  }

  void resetImagesByAngle(AicycleCarAngle angle) {
    switch (angle) {
      case AicycleCarAngle.regCert:
        _regCertImages.clear();
        break;
      case AicycleCarAngle.regStamp:
        _regStampImages.clear();
        break;
      case AicycleCarAngle.vinNumber:
        _vinNumberImages.clear();
        break;
      case AicycleCarAngle.taplo:
        _taploImages.clear();
        break;
      case AicycleCarAngle.front:
        _exteriorImages.removeWhere((image) => _frontImages.contains(image));
        _frontImages.clear();
        break;
      case AicycleCarAngle.frontLeft:
        _exteriorImages.removeWhere(
          (image) => _frontLeftImages.contains(image),
        );
        _frontLeftImages.clear();
        break;
      case AicycleCarAngle.frontRight:
        _exteriorImages.removeWhere(
          (image) => _frontRightImages.contains(image),
        );
        _frontRightImages.clear();
        break;
      case AicycleCarAngle.rear:
        _exteriorImages.removeWhere((image) => _rearImages.contains(image));
        _rearImages.clear();
        break;
      case AicycleCarAngle.rearLeft:
        _exteriorImages.removeWhere((image) => _rearLeftImages.contains(image));
        _rearLeftImages.clear();
        break;
      case AicycleCarAngle.rearRight:
        _exteriorImages.removeWhere(
          (image) => _rearRightImages.contains(image),
        );
        _rearRightImages.clear();
        break;
      case AicycleCarAngle.left:
        _exteriorImages.removeWhere((image) => _leftImages.contains(image));
        _leftImages.clear();
        break;
      case AicycleCarAngle.right:
        _exteriorImages.removeWhere((image) => _rightImages.contains(image));
        _rightImages.clear();
        break;
      default:
        break;
    }
    notifyListeners();
  }

  /// Lấy ảnh theo góc
  List<DirectionalImage> getImagesForAngle(AicycleCarAngle angle) {
    switch (angle) {
      case AicycleCarAngle.regCert:
        return _regCertImages;
      case AicycleCarAngle.regStamp:
        return _regStampImages;
      case AicycleCarAngle.vinNumber:
        return _vinNumberImages;
      case AicycleCarAngle.taplo:
        return _taploImages;
      case AicycleCarAngle.front:
        return _frontImages;
      case AicycleCarAngle.frontLeft:
        return _frontLeftImages;
      case AicycleCarAngle.frontRight:
        return _frontRightImages;
      case AicycleCarAngle.rear:
        return _rearImages;
      case AicycleCarAngle.rearLeft:
        return _rearLeftImages;
      case AicycleCarAngle.rearRight:
        return _rearRightImages;
      case AicycleCarAngle.left:
        return _leftImages;
      case AicycleCarAngle.right:
        return _rightImages;
      default:
        return _exteriorImages;
    }
  }

  /// Checks if an image URL is currently selected.
  bool isSelected(String? imageUrl) {
    if (imageUrl == null) return false;
    return _selectedImages.contains(imageUrl);
  }

  /// Toggles the selection state of a given image URL.
  void toggleImageSelection(String? imageUrl) {
    if (imageUrl == null) return;
    if (_selectedImages.contains(imageUrl)) {
      _selectedImages.remove(imageUrl);
    } else {
      _selectedImages.add(imageUrl);
    }
    notifyListeners();
  }

  /// Clears the current image selection.
  void clearSelection() {
    _selectedImages.clear();
    notifyListeners();
  }

  /// Deletes all locally selected images from their respective angle lists.
  void deleteSelectedImages() {
    if (_selectedImages.isEmpty) return;

    // Remove from all specific lists
    _regCertImages.removeWhere((img) => _selectedImages.contains(img.imageUrl));
    _regStampImages.removeWhere(
      (img) => _selectedImages.contains(img.imageUrl),
    );
    _vinNumberImages.removeWhere(
      (img) => _selectedImages.contains(img.imageUrl),
    );
    _taploImages.removeWhere((img) => _selectedImages.contains(img.imageUrl));
    _frontImages.removeWhere((img) => _selectedImages.contains(img.imageUrl));
    _frontLeftImages.removeWhere(
      (img) => _selectedImages.contains(img.imageUrl),
    );
    _frontRightImages.removeWhere(
      (img) => _selectedImages.contains(img.imageUrl),
    );
    _rearImages.removeWhere((img) => _selectedImages.contains(img.imageUrl));
    _rearLeftImages.removeWhere(
      (img) => _selectedImages.contains(img.imageUrl),
    );
    _rearRightImages.removeWhere(
      (img) => _selectedImages.contains(img.imageUrl),
    );
    _leftImages.removeWhere((img) => _selectedImages.contains(img.imageUrl));
    _rightImages.removeWhere((img) => _selectedImages.contains(img.imageUrl));

    // Also remove from general exterior images list
    _exteriorImages.removeWhere(
      (img) => _selectedImages.contains(img.imageUrl),
    );

    _selectedImages.clear();
    notifyListeners();
  }

  /// Clears all stored images (e.g., when the SDK initializes a new flow).
  void reset() {
    _regCertImages.clear();
    _regStampImages.clear();
    _vinNumberImages.clear();
    _taploImages.clear();
    _exteriorImages.clear();
    _frontImages.clear();
    _frontLeftImages.clear();
    _frontRightImages.clear();
    _rearImages.clear();
    _rearLeftImages.clear();
    _rearRightImages.clear();
    _leftImages.clear();
    _rightImages.clear();
    _selectedImages.clear();
    notifyListeners();
  }
}
