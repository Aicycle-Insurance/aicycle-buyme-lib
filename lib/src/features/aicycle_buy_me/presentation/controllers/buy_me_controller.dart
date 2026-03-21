import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extension/car_angle_ext.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../domain/entities/directional_image.dart';
import '../../domain/use_cases/create_buyme_folder_use_case.dart';
import '../../domain/use_cases/get_directional_image_use_case.dart';

/// Status of the BuyMe folder creation or initialization process.
enum BuyMeStatus { initial, loading, success, error }

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
          brand: carInfo.carCompanyId,
          model: carInfo.model,
          vehicleYear: carInfo.manufacturingYear,
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

  // ─── Private helpers ──────────────────────────────────────────────────────

  /// Fetch ảnh của tất cả các góc cùng lúc (parallel), rồi phân loại.
  Future<void> _loadAllDirectionalImages() async {
    final claimId = InternalCache.claimId ?? '';
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
        sl.vehicleImageVault.resetImagesByAngle(angle);
        sl.vehicleImageVault.addImagesFromServer(angle, images);
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
