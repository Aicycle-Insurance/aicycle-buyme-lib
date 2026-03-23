import 'package:aicycle_buyme_plus/src/core/error/exceptions.dart';
import 'package:flutter/foundation.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../domain/use_cases/validate_vehicle_angle_use_case.dart';

enum ValidationType { initial, error, warning, success }

class ValidationVault extends ChangeNotifier {
  final ValidateVehicleAngleUseCase _validateVehicleAngleUseCase;
  AiCycleConfig get _config => AiCycleBuyMe.config;

  ValidationVault(this._validateVehicleAngleUseCase) {
    sl.vehicleImageVault.addListener(_onVaultChanged);
    _isHasImage = sl.vehicleImageVault.hasAnyImage;
    validateVehicleAngle();
  }

  String? _message;
  ValidationType _validationType = ValidationType.initial;
  bool _isHasImage = false;

  String? get message => _message;
  bool get isHasImage => _isHasImage;
  ValidationType get validationType => _validationType;

  bool get isSuccess => _validationType == ValidationType.success;
  bool get isError => _validationType == ValidationType.error;

  Future<void> validateVehicleAngle() async {
    _isHasImage = sl.vehicleImageVault.hasAnyImage;
    if (!_config.validationConfig.missingPartValidation || !isHasImage) {
      _message = null;
      _validationType = ValidationType.initial;
      notifyListeners();
      return;
    }
    try {
      final result = await _validateVehicleAngleUseCase(InternalCache.claimId);
      _message = result;
      _validationType = ValidationType.success;
      notifyListeners();
    } on ServerException catch (e) {
      _message = e.message;
      _validationType = ValidationType.error;
      notifyListeners();
    } catch (e) {
      _message = null;
      _validationType = ValidationType.initial;
      debugPrint(e.toString());
      notifyListeners();
    }
  }

  void _onVaultChanged() {
    validateVehicleAngle();
  }

  @override
  void dispose() {
    sl.vehicleImageVault.removeListener(_onVaultChanged);
    super.dispose();
  }

  void reset() {
    _message = null;
    _isHasImage = false;
    notifyListeners();
  }
}
