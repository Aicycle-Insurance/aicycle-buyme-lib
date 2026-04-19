import '../entities/vehicle_info.dart';
import '../repositories/document_result_repository.dart';

/// API: GET /v2/claimfolders/car-info
class GetVehicleInfoUseCase {
  final DocumentResultRepository _repository;
  GetVehicleInfoUseCase(this._repository);

  Future<VehicleInfo> call(String params) {
    return _repository.getVehicleInfo(params);
  }
}
