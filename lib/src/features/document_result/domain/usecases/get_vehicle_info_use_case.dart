import '../entities/vehicle_info.dart';
import '../repositories/document_result_repository.dart';

class GetVehicleInfoUseCase {
  final DocumentResultRepository _repository;
  GetVehicleInfoUseCase(this._repository);

  Future<VehicleInfo> call(String params) {
    return _repository.getVehicleInfo(params);
  }
}
