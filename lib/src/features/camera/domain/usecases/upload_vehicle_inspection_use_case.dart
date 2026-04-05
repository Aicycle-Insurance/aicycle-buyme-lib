import '../entities/cert_upload_entity.dart';
import '../repositories/image_respository.dart';

class UploadVehicleInspectionParams {
  final List<String> imagePaths;
  final String claimId;

  UploadVehicleInspectionParams({
    required this.imagePaths,
    required this.claimId,
  });
}

class UploadVehicleInspectionUseCase {
  final ImageRepository _repository;

  UploadVehicleInspectionUseCase(this._repository);

  Future<CertUploadEntity> call(UploadVehicleInspectionParams params) {
    return _repository.uploadVehicleInspection(
      imagePaths: params.imagePaths,
      claimId: params.claimId,
    );
  }
}
