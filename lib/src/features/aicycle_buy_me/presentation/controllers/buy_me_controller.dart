import 'package:flutter/material.dart';
import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../../document_result/domain/usecases/get_image_detail_use_case.dart';
import '../../domain/use_cases/create_buyme_folder_use_case.dart';

/// Status of the BuyMe folder creation or initialization process.
enum BuyMeStatus { initial, loading, success, error }

/// Main controller for the BuyMe flow.
/// Orchestrates folder creation, image management for all sections,
/// and synchronization with the backend.
class BuyMeController extends ChangeNotifier {
  final CreateBuyMeFolderUseCase _createBuyMeFolderUseCase;
  final GetImageDetailUseCase _getImageDetailUseCase;

  BuyMeController({
    CreateBuyMeFolderUseCase? createBuyMeFolderUseCase,
    GetImageDetailUseCase? getImageDetailUseCase,
  }) : _createBuyMeFolderUseCase =
           createBuyMeFolderUseCase ?? sl.createBuyMeFolderUseCase,
       _getImageDetailUseCase =
           getImageDetailUseCase ?? sl.getImageDetailUseCase;
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

      if (config.generalConfig.organization == AiCycleOrg.aicycle) {
        InternalCache.claimId = config.generalConfig.documentId;
      } else {
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
      }

      await sl.vehicleImageVault.loadAllDirectionalImages();
      await sl.validationVault.validateVehicleAngle();
      await sl.getFolderDetailUsecase.call(InternalCache.claimId);
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

  Future<void> submit(Function(Map<String, dynamic> data)? onComplete) async {
    try {
      _status = BuyMeStatus.loading;
      notifyListeners();
      final imageIds = sl.vehicleImageVault.exteriorImages
          .map((e) => e.imageId)
          .toList();
      List<Map<String, dynamic>> imageDetails = [];
      for (int? id in imageIds) {
        if (id != null) {
          final imageDetail = await _getImageDetailUseCase(id);
          imageDetails.add(imageDetail);
        }
      }
      final Map<String, dynamic> sentData = {
        'regCertImages': sl.vehicleImageVault.regCertImages
            .map((e) => e.imageUrl)
            .toList(),
        'regStampImages': sl.vehicleImageVault.regStampImages
            .map((e) => e.imageUrl)
            .toList(),
        'vinNumberImages': sl.vehicleImageVault.vinNumberImages
            .map((e) => e.imageUrl)
            .toList(),
        'taploImages': sl.vehicleImageVault.taploImages
            .map((e) => e.imageUrl)
            .toList(),
        'results': imageDetails,
        'itemsCount': imageDetails.length,
      };
      onComplete?.call(sentData);
      await sl.getFolderDetailUsecase.call(InternalCache.claimId);
    } catch (e) {
      debugPrint('Error getting image detail: $e');
    } finally {
      _status = BuyMeStatus.success;
      notifyListeners();
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
