import 'package:flutter/foundation.dart';
import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/extension/car_angle_ext.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../../camera/domain/usecases/delete_image_use_case.dart';
import '../../domain/entities/directional_image.dart';
import '../../domain/use_cases/get_directional_image_use_case.dart';

/// Central store for managing all car capture images.
/// Shared across different pages (BuyMePage, CameraPage, CarCapturePage...)
/// via `sl.vehicleImageVault`.
class VehicleImageVault extends ChangeNotifier {
  final DeleteImageUseCase _deleteImageUseCase;
  final GetDirectionalImagesUseCase _getDirectionalImagesUseCase;

  VehicleImageVault(
    this._deleteImageUseCase,
    this._getDirectionalImagesUseCase,
  );

  /// Ảnh các góc cụ thể
  final Set<DirectionalImage> _regCertImages = {};
  final Set<DirectionalImage> _regStampImages = {};
  final Set<DirectionalImage> _vinNumberImages = {};
  final Set<DirectionalImage> _taploImages = {};
  final Set<DirectionalImage> _frontImages = {};
  final Set<DirectionalImage> _frontLeftImages = {};
  final Set<DirectionalImage> _frontRightImages = {};
  final Set<DirectionalImage> _rearImages = {};
  final Set<DirectionalImage> _rearLeftImages = {};
  final Set<DirectionalImage> _rearRightImages = {};
  final Set<DirectionalImage> _leftImages = {};
  final Set<DirectionalImage> _rightImages = {};

  /// Góc ngoại thất nói chung dùng cho trường hợp không có các góc cụ thể
  final Set<DirectionalImage> _exteriorImages = {};

  /// The list of image IDs currently selected for actions (e.g., deletion).
  final List<int> _selectedImageIds = [];

  bool _isDeleting = false;

  /// getters
  List<DirectionalImage> get regCertImages => _regCertImages.toList();
  List<DirectionalImage> get regStampImages => _regStampImages.toList();
  List<DirectionalImage> get vinNumberImages => _vinNumberImages.toList();
  List<DirectionalImage> get taploImages => _taploImages.toList();
  List<DirectionalImage> get frontImages => _frontImages.toList();
  List<DirectionalImage> get frontLeftImages => _frontLeftImages.toList();
  List<DirectionalImage> get frontRightImages => _frontRightImages.toList();
  List<DirectionalImage> get rearImages => _rearImages.toList();
  List<DirectionalImage> get rearLeftImages => _rearLeftImages.toList();
  List<DirectionalImage> get rearRightImages => _rearRightImages.toList();
  List<DirectionalImage> get leftImages => _leftImages.toList();
  List<DirectionalImage> get rightImages => _rightImages.toList();
  List<DirectionalImage> get exteriorImages => _exteriorImages.toList();

  List<int> get selectedImageIds => List.unmodifiable(_selectedImageIds);
  bool get isDeleting => _isDeleting;

  bool get hasAnyImage => _exteriorImages.isNotEmpty;

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
        return _regCertImages.toList();
      case AicycleCarAngle.regStamp:
        return _regStampImages.toList();
      case AicycleCarAngle.vinNumber:
        return _vinNumberImages.toList();
      case AicycleCarAngle.taplo:
        return _taploImages.toList();
      case AicycleCarAngle.front:
        return _frontImages.toList();
      case AicycleCarAngle.frontLeft:
        return _frontLeftImages.toList();
      case AicycleCarAngle.frontRight:
        return _frontRightImages.toList();
      case AicycleCarAngle.rear:
        return _rearImages.toList();
      case AicycleCarAngle.rearLeft:
        return _rearLeftImages.toList();
      case AicycleCarAngle.rearRight:
        return _rearRightImages.toList();
      case AicycleCarAngle.left:
        return _leftImages.toList();
      case AicycleCarAngle.right:
        return _rightImages.toList();
      default:
        return _exteriorImages.toList();
    }
  }

  /// Checks if an image ID is currently selected.
  bool isSelected(int? imageId) {
    if (imageId == null) return false;
    return _selectedImageIds.contains(imageId);
  }

  /// Toggles the selection state of a given image URL.
  void toggleImageSelection(int? imageId) {
    if (imageId == null) return;
    if (_selectedImageIds.contains(imageId)) {
      _selectedImageIds.remove(imageId);
    } else {
      _selectedImageIds.add(imageId);
    }
    notifyListeners();
  }

  /// Clears the current image selection.
  void clearSelection() {
    _selectedImageIds.clear();
    notifyListeners();
  }

  /// Deletes all locally selected images from their respective angle lists.
  Future<void> deleteSelectedImages(AicycleCarAngle angle) async {
    if (_selectedImageIds.isEmpty) return;

    _isDeleting = true;
    notifyListeners();
    try {
      // Delete from server
      await _deleteImageUseCase(
        DeleteImageUseCaseParams(
          imageIds: List<int>.from(_selectedImageIds),
          vehicleAngleId: angle == AicycleCarAngle.exterior ? null : angle.id,
        ),
      );

      // Remove from all specific lists
      _regCertImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _regStampImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _vinNumberImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _taploImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _frontImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _frontLeftImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _frontRightImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _rearImages.removeWhere((img) => _selectedImageIds.contains(img.imageId));
      _rearLeftImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _rearRightImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );
      _leftImages.removeWhere((img) => _selectedImageIds.contains(img.imageId));
      _rightImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );

      // Also remove from general exterior images list
      _exteriorImages.removeWhere(
        (img) => _selectedImageIds.contains(img.imageId),
      );

      _selectedImageIds.clear();
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
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
    _selectedImageIds.clear();
    notifyListeners();
  }

  /// Fetch ảnh của tất cả các góc cùng lúc (parallel), rồi phân loại.
  Future<void> loadAllDirectionalImages() async {
    final claimId = InternalCache.claimId;
    if (claimId.isEmpty) return;

    final results = await Future.wait(
      AicycleCarAngle.values.map(
        (angle) => _fetchAngle(claimId: claimId, angle: angle),
      ),
    );

    for (int i = 0; i < AicycleCarAngle.values.length; i++) {
      final angle = AicycleCarAngle.values[i];
      final images = results[i];

      if (images.isNotEmpty) {
        resetImagesByAngle(angle);
        addImagesFromServer(angle, images);
      }
    }
  }

  /// Fetch ảnh của một góc, trả về list rỗng nếu lỗi.
  Future<List<DirectionalImage>> _fetchAngle({
    required String claimId,
    required AicycleCarAngle angle,
  }) async {
    try {
      return await _getDirectionalImagesUseCase(
        GetDirectionalImagesParams(claimId: claimId, angleId: angle.id),
      );
    } catch (_) {
      return [];
    }
  }
}
