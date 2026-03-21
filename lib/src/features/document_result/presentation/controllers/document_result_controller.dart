import 'package:aicycle_buyme_plus/src/core/utils/internal_cache.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/vehicle_info.dart';
import '../../domain/usecases/get_vehicle_info_use_case.dart';

class DocumentResultController extends ChangeNotifier {
  final GetVehicleInfoUseCase _getVehicleInfoUseCase;
  DocumentResultController(this._getVehicleInfoUseCase) {
    getVehicleInfo();
  }

  VehicleInfo? _vehicleInfo;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  VehicleInfo? get vehicleInfo => _vehicleInfo;

  Future<void> getVehicleInfo() async {
    final claimId = InternalCache.claimId;
    try {
      _isLoading = true;
      notifyListeners();
      _vehicleInfo = await _getVehicleInfoUseCase(claimId);
    } catch (e) {
      debugPrint('Error getting vehicle info: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
