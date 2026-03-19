import '../entities/upload_vehicle_inspection.dart';
import '../repositories/image_respository.dart';

class UploadVehicleInspectionParams {
  final String imagePath;
  final String claimId;

  UploadVehicleInspectionParams({
    required this.imagePath,
    required this.claimId,
  });
}

class UploadVehicleInspectionUseCase {
  final ImageRepository _repository;

  UploadVehicleInspectionUseCase(this._repository);

  Future<UploadVehicleInspection> call(UploadVehicleInspectionParams params) {
    return _repository.uploadVehicleInspection(
      imagePath: params.imagePath,
      claimId: params.claimId,
    );
  }
}
