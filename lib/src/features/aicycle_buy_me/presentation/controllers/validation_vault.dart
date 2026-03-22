import 'package:aicycle_buyme_plus/src/core/error/exceptions.dart';
import 'package:flutter/foundation.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../domain/use_cases/validate_vehicle_angle_use_case.dart';

class ValidationVault extends ChangeNotifier {
  final ValidateVehicleAngleUseCase _validateVehicleAngleUseCase;
  AiCycleConfig get _config => AiCycleBuyMe.config;

  ValidationVault(this._validateVehicleAngleUseCase) {
    sl.vehicleImageVault.addListener(_onVaultChanged);
    _isHasImage = sl.vehicleImageVault.hasAnyImage;
    if (_config.validationConfig.missingPartValidation) {
      validateVehicleAngle();
    }
  }

  String? _errorMessage;
  bool _isHasImage = false;

  String? get errorMessage => _errorMessage;
  bool get isHasImage => _isHasImage;

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
    _isHasImage = sl.vehicleImageVault.hasAnyImage;
    if (_config.validationConfig.missingPartValidation) {
      validateVehicleAngle();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    if (_config.validationConfig.missingPartValidation) {
      sl.vehicleImageVault.removeListener(_onVaultChanged);
    }
    super.dispose();
  }

  void reset() {
    _errorMessage = null;
    _isHasImage = false;
    notifyListeners();
  }
}
