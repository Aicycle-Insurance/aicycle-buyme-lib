import '../repositories/buy_me_repository.dart';

class ValidateVehicleAngleUseCase {
  final BuyMeRepository _repository;

  ValidateVehicleAngleUseCase(this._repository);

  Future<String> call(String claimId) {
    return _repository.getValidationResult(claimId: claimId);
  }
}
