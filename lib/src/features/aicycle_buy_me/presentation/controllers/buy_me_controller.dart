import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/parse_output.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../../document_result/domain/usecases/get_damage_statistics_use_case.dart';
import '../../domain/use_cases/create_buyme_folder_use_case.dart';

/// Status of the BuyMe folder creation or initialization process.
enum BuyMeStatus { initial, loading, success, error }

/// Main controller for the BuyMe flow.
/// Orchestrates folder creation, image management for all sections,
/// and synchronization with the backend.
class BuyMeController extends ChangeNotifier {
  final CreateBuyMeFolderUseCase _createBuyMeFolderUseCase;
  final GetDamageStatisticsUseCase _getDamageStatisticsUseCase;

  BuyMeController({
    CreateBuyMeFolderUseCase? createBuyMeFolderUseCase,
    GetDamageStatisticsUseCase? getDamageStatisticsUseCase,
  }) : _createBuyMeFolderUseCase =
           createBuyMeFolderUseCase ?? sl.createBuyMeFolderUseCase,
       _getDamageStatisticsUseCase =
           getDamageStatisticsUseCase ?? sl.getDamageStatisticsUseCase;
  bool _isDisposed = false;

  BuyMeStatus _status = BuyMeStatus.initial;
  BuyMeStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Create new or get existing AiCycle document, then load all directional images.
  Future<void> init(AiCycleConfig config) async {
    try {
      _status = BuyMeStatus.loading;
      _errorMessage = '';
      if (!_isDisposed) notifyListeners();

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
          brand: carInfo?.carCompanyId,
          model: carInfo?.carModelId,
          vehicleYear: carInfo?.manufacturingYear,
          vehicleSpec: carInfo?.vehicleSpec,
          licensePlate: carInfo?.licensePlate,
          vehicleType: carInfo?.vehicleType ?? 'truck',
          hasLicensePlate: carInfo?.licensePlate?.isNotEmpty == true,
        ),
      );

      await sl.vehicleImageVault.loadAllDirectionalImages();
      await sl.validationVault.validateVehicleAngle();

      _status = BuyMeStatus.success;
      if (!_isDisposed) notifyListeners();
    } catch (e) {
      _status = BuyMeStatus.error;
      _errorMessage = e.toString();
      if (!_isDisposed) notifyListeners();
      rethrow;
    }
  }

  /// Tải lại toàn bộ ảnh từ server.
  Future<void> refresh() async {
    await sl.vehicleImageVault.loadAllDirectionalImages();
    await sl.validationVault.validateVehicleAngle();
    if (!_isDisposed) notifyListeners();
  }

  Future<void> submit(Function(dynamic data)? onComplete) async {
    final claimId = InternalCache.claimId;
    try {
      final damageStatistics = await _getDamageStatisticsUseCase(claimId);
      final data = ParseOutput.parseDamageStatistics(damageStatistics);
      onComplete?.call(data);
    } catch (e) {
      debugPrint('Error getting damage statistics: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    InternalCache.resetAll();
    sl.vehicleImageVault.reset();
    sl.validationVault.reset();
    AiCycleBuyMe.configInternal = null;
    super.dispose();
  }
}
