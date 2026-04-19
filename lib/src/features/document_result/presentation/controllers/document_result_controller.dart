import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../domain/entities/segment_result.dart';
import '../../domain/entities/vehicle_info.dart';
import '../../domain/usecases/get_damage_statistics_use_case.dart';
import '../../domain/usecases/get_image_detail_use_case.dart';
import '../../domain/usecases/get_vehicle_info_use_case.dart';

class DocumentResultController extends ChangeNotifier {
  final GetVehicleInfoUseCase _getVehicleInfoUseCase;
  final GetDamageStatisticsUseCase _getDamageStatisticsUseCase;
  final GetImageDetailUseCase _getImageDetailUseCase;

  DocumentResultController(
    this._getVehicleInfoUseCase,
    this._getDamageStatisticsUseCase,
    this._getImageDetailUseCase,
  ) {
    refresh(true);
  }

  VehicleInfo? _vehicleInfo;
  bool _isLoading = false;
  List<SegmentResult>? _damageStatistics;

  bool get isLoading => _isLoading;
  VehicleInfo? get vehicleInfo => _vehicleInfo;
  List<SegmentResult>? get damageStatistics => _damageStatistics;

  Future<void> refresh(bool isFirstLoad) async {
    if (isFirstLoad) {
      _isLoading = true;
      notifyListeners();
    }
    await getVehicleInfo();
    await getDamageStatistics();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getVehicleInfo() async {
    final claimId = InternalCache.claimId;
    try {
      _vehicleInfo = await _getVehicleInfoUseCase(claimId);
    } catch (e) {
      debugPrint('Error getting vehicle info: $e');
    }
  }

  Future<void> getDamageStatistics() async {
    final claimId = InternalCache.claimId;
    try {
      _damageStatistics = await _getDamageStatisticsUseCase(claimId);
    } catch (e) {
      debugPrint('Error getting damage statistics: $e');
    }
  }

  Future<void> onSubmit(Function(Map<String, dynamic> data)? onComplete) async {
    try {
      _isLoading = true;
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
    } catch (e) {
      debugPrint('Error getting image detail: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
