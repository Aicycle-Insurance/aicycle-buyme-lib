import 'package:aicycle_buyme_plus/src/core/error/exceptions.dart';
import 'package:flutter/foundation.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../domain/use_cases/validate_vehicle_angle_use_case.dart';

class ValidationVault extends ChangeNotifier {
  final ValidateVehicleAngleUseCase _validateVehicleAngleUseCase;
  final config = AiCycleBuyMe.config;

  ValidationVault(this._validateVehicleAngleUseCase) {
    if (config.validationConfig.missingPartValidation) {
      sl.vehicleImageVault.addListener(_onVaultChanged);
      validateVehicleAngle();
    }
  }

  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  bool get isHasImage => sl.vehicleImageVault.exteriorImages.isNotEmpty;

  Future<void> validateVehicleAngle() async {
    if (!isHasImage) {
      _errorMessage = null;
      notifyListeners();
      return;
    }
    try {
      final result = await _validateVehicleAngleUseCase(InternalCache.claimId);
      _errorMessage = result;
      notifyListeners();
    } on ServerException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = null;
      debugPrint(e.toString());
      notifyListeners();
    }
  }

  void _onVaultChanged() {
    validateVehicleAngle();
  }

  @override
  void dispose() {
    if (config.validationConfig.missingPartValidation) {
      sl.vehicleImageVault.removeListener(_onVaultChanged);
    }
    super.dispose();
  }
}
