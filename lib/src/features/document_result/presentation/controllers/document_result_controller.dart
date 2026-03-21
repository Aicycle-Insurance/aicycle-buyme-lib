import 'package:aicycle_buyme_plus/src/core/utils/internal_cache.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/segment_result.dart';
import '../../domain/entities/vehicle_info.dart';
import '../../domain/usecases/get_damage_statistics_use_case.dart';
import '../../domain/usecases/get_vehicle_info_use_case.dart';

class DocumentResultController extends ChangeNotifier {
  final GetVehicleInfoUseCase _getVehicleInfoUseCase;
  final GetDamageStatisticsUseCase _getDamageStatisticsUseCase;

  DocumentResultController(
    this._getVehicleInfoUseCase,
    this._getDamageStatisticsUseCase,
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
}
