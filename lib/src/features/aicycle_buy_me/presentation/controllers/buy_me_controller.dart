import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extension/car_angle_ext.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../domain/entities/directional_image.dart';
import '../../domain/use_cases/create_buyme_folder_use_case.dart';
import '../../domain/use_cases/get_directional_image_use_case.dart';

/// Enum representing the different sections of the car capture process.
enum CarCaptureSectionType { regCert, regStamp, vinNumber, taplo, exterior }

/// Status of the BuyMe folder creation or initialization process.
enum BuyMeStatus { initial, loading, success, error }

/// Góc xe thuộc nhóm exterior (ngoại thất) — không thuộc các section đặc biệt.
const _exteriorAngles = {
  AicycleCarAngle.front,
  AicycleCarAngle.frontLeft,
  AicycleCarAngle.frontRight,
  AicycleCarAngle.rear,
  AicycleCarAngle.rearLeft,
  AicycleCarAngle.rearRight,
  AicycleCarAngle.left,
  AicycleCarAngle.right,
};

/// Main controller for the BuyMe flow.
/// Orchestrates folder creation, image management for all sections,
/// and synchronization with the backend.
class BuyMeController extends ChangeNotifier {
  final CreateBuyMeFolderUseCase _createBuyMeFolderUseCase;
  final GetDirectionalImagesUseCase _getDirectionalImagesUseCase;

  BuyMeController({
    CreateBuyMeFolderUseCase? createBuyMeFolderUseCase,
    GetDirectionalImagesUseCase? getDirectionalImagesUseCase,
  }) : _createBuyMeFolderUseCase =
           createBuyMeFolderUseCase ?? sl.createBuyMeFolderUseCase,
       _getDirectionalImagesUseCase =
           getDirectionalImagesUseCase ?? sl.getDirectionalImagesUseCase;

  BuyMeStatus _status = BuyMeStatus.initial;
  BuyMeStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ─── Internal image storage ───────────────────────────────────────────────

  final List<DirectionalImage> _regCertImages = [];
  final List<DirectionalImage> _regStampImages = [];
  final List<DirectionalImage> _vinNumberImages = [];
  final List<DirectionalImage> _taploImages = [];
  final Map<AicycleCarAngle, List<DirectionalImage>> _exteriorImages = {};

  // ─── Reactive notifier — cầu nối sang CarCaptureController ───────────────
  //
  // BuyMeController KHÔNG giữ reference CarCaptureController.
  // Thay vào đó nó publish dữ liệu qua ValueNotifier.
  // CarCaptureController tự subscribe và sync — hai bên độc lập nhau.

  /// Phát ra map URL ảnh exterior mỗi khi dữ liệu thay đổi.
  /// [CarCaptureController] subscribe notifier này để tự sync.
  final ValueNotifier<Map<AicycleCarAngle, List<String>>>
  exteriorImagesNotifier = ValueNotifier({});

  // ─── Entity getters ───────────────────────────────────────────────────────

  List<DirectionalImage> get regCertImages => List.unmodifiable(_regCertImages);
  List<DirectionalImage> get regStampImages =>
      List.unmodifiable(_regStampImages);
  List<DirectionalImage> get vinNumberImages =>
      List.unmodifiable(_vinNumberImages);
  List<DirectionalImage> get taploImages => List.unmodifiable(_taploImages);

  Map<AicycleCarAngle, List<DirectionalImage>> get exteriorImagesMap =>
      Map.unmodifiable(_exteriorImages);

  List<DirectionalImage> get exteriorImages =>
      _exteriorImages.values.expand((e) => e).toList();

  // ─── URL getters (widget/UI layer) ───────────────────────────────────────

  List<String> get regCertImageUrls =>
      _regCertImages.map((e) => e.imageUrl ?? '').toList();

  List<String> get regStampImageUrls =>
      _regStampImages.map((e) => e.imageUrl ?? '').toList();

  List<String> get vinNumberImageUrls =>
      _vinNumberImages.map((e) => e.imageUrl ?? '').toList();

  List<String> get taploImageUrls =>
      _taploImages.map((e) => e.imageUrl ?? '').toList();

  Map<AicycleCarAngle, List<String>> get exteriorImageUrlsMap =>
      _exteriorImages.map(
        (angle, imgs) =>
            MapEntry(angle, imgs.map((e) => e.imageUrl ?? '').toList()),
      );

  List<String> get exteriorImageUrls => _exteriorImages.values
      .expand((imgs) => imgs.map((e) => e.imageUrl ?? ''))
      .toList();

  // ─── Image management (local) ─────────────────────────────────────────────

  /// Thêm ảnh local (chụp mới) vào đúng section.
  /// Với exterior, bắt buộc truyền [vehicleAngle].
  void addImage(
    CarCaptureSectionType type,
    String path, {
    int index = 0,
    AicycleCarAngle? vehicleAngle,
  }) {
    final img = DirectionalImage(imageUrl: path);
    switch (type) {
      case CarCaptureSectionType.regCert:
        _upsertAt(_regCertImages, index, img);
        break;
      case CarCaptureSectionType.regStamp:
        _upsertAt(_regStampImages, index, img);
        break;
      case CarCaptureSectionType.vinNumber:
        _upsertAt(_vinNumberImages, index, img);
        break;
      case CarCaptureSectionType.taplo:
        _upsertAt(_taploImages, index, img);
        break;
      case CarCaptureSectionType.exterior:
        if (vehicleAngle != null) {
          final list = _exteriorImages[vehicleAngle] ?? [];
          if (!list.any((e) => e.imageUrl == path)) {
            list.add(img);
            _exteriorImages[vehicleAngle] = list;
            _publishExterior(); // cập nhật notifier
          }
        }
        break;
    }
    notifyListeners();
  }

  /// Xóa ảnh khỏi section.
  void removeImage(
    CarCaptureSectionType type, {
    int index = 0,
    AicycleCarAngle? vehicleAngle,
    String? path,
  }) {
    switch (type) {
      case CarCaptureSectionType.regCert:
        _clearAt(_regCertImages, index);
        break;
      case CarCaptureSectionType.regStamp:
        _clearAt(_regStampImages, index);
        break;
      case CarCaptureSectionType.vinNumber:
        _clearAt(_vinNumberImages, index);
        break;
      case CarCaptureSectionType.taplo:
        _clearAt(_taploImages, index);
        break;
      case CarCaptureSectionType.exterior:
        if (vehicleAngle != null) {
          if (path != null) {
            _exteriorImages[vehicleAngle]?.removeWhere(
              (e) => e.imageUrl == path,
            );
          } else {
            final list = _exteriorImages[vehicleAngle];
            if (list != null && list.length > index) list.removeAt(index);
          }
          _publishExterior();
        }
        break;
    }
    notifyListeners();
  }

  // ─── Backend sync ─────────────────────────────────────────────────────────

  /// Create new or get existing AiCycle document, then load all directional images.
  Future<void> init(AiCycleConfig config) async {
    try {
      _status = BuyMeStatus.loading;
      _errorMessage = '';
      notifyListeners();

      AiCycleBuyMe.configInternal = config;
      final carInfo = config.carInformation;

      await _createBuyMeFolderUseCase(
        CreateBuyMeFolderParams(
          externalClaimId: config.generalConfig.documentId,
          claimName:
              config.generalConfig.documentName ??
              config.generalConfig.documentId,
          vehicleBrandId: '5',
          priceTypeId: 10,
          isClaim: false,
          brand: carInfo.brand,
          model: carInfo.model,
          vehicleYear: carInfo.vehicleYear,
          vehicleSpec: carInfo.vehicleSpec,
          licensePlate: carInfo.licensePlate,
          vehicleType: carInfo.vehicleType ?? 'truck',
          hasLicensePlate: carInfo.licensePlate?.isNotEmpty == true,
        ),
      );

      await _loadAllDirectionalImages();

      _status = BuyMeStatus.success;
      notifyListeners();
    } catch (e) {
      _status = BuyMeStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Tải lại toàn bộ ảnh từ server.
  Future<void> refresh() async {
    await _loadAllDirectionalImages();
    notifyListeners();
  }

  void submit() {
    // TODO: implement submission logic
  }

  @override
  void dispose() {
    exteriorImagesNotifier.dispose();
    super.dispose();
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  /// Publish giá trị mới của exterior map lên notifier.
  void _publishExterior() {
    exteriorImagesNotifier.value = exteriorImageUrlsMap;
  }

  /// Fetch ảnh của tất cả các góc cùng lúc (parallel), rồi phân loại.
  Future<void> _loadAllDirectionalImages() async {
    final claimId = InternalCache.folderId ?? '';
    if (claimId.isEmpty) return;

    final results = await Future.wait(
      AicycleCarAngle.values.map(
        (angle) => _fetchAngle(claimId: claimId, angle: angle),
      ),
    );

    _regCertImages.clear();
    _regStampImages.clear();
    _vinNumberImages.clear();
    _taploImages.clear();
    _exteriorImages.clear();

    for (int i = 0; i < AicycleCarAngle.values.length; i++) {
      final angle = AicycleCarAngle.values[i];
      final images = results[i];

      if (images.isEmpty) continue;

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
        default:
          if (_exteriorAngles.contains(angle)) {
            _exteriorImages[angle] = images;
          }
      }
    }

    // Publish lên notifier — CarCaptureController tự nghe và sync
    _publishExterior();
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

  void _upsertAt(List<DirectionalImage> list, int index, DirectionalImage img) {
    if (index < list.length) {
      list[index] = img;
    } else {
      list.add(img);
    }
  }

  void _clearAt(List<DirectionalImage> list, int index) {
    if (index < list.length) list.removeAt(index);
  }
}
