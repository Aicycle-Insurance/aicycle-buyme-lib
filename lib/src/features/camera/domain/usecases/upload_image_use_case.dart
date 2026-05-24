import '../entities/upload_vehicle_inspection.dart';
import '../repositories/image_respository.dart';

class UploadImageParams {
  final String imagePath;
  final String claimId;
  final String? angleId;
  final bool isFramedPhoto;
  // địa diểm chụp ảnh hoặc lấy từ metadata ảnh
  final String? locationName;
  // địa điểm upload
  final String? uploadLocation;
  // thời gian chụp ảnh (lấy từ metadata ảnh)
  final String? utcTimeCreated;

  UploadImageParams({
    required this.imagePath,
    required this.claimId,
    this.angleId,
    this.isFramedPhoto = false,
    this.locationName,
    this.uploadLocation,
    this.utcTimeCreated,
  });
}

class UploadImageUseCase {
  final ImageRepository _repository;

  UploadImageUseCase(this._repository);

  Future<UploadVehicleInspection> call(UploadImageParams params) {
    return _repository.uploadImage(
      imagePath: params.imagePath,
      claimId: params.claimId,
      angleId: params.angleId,
      isFramedPhoto: params.isFramedPhoto,
      locationName: params.locationName,
      uploadLocation: params.uploadLocation,
      utcTimeCreated: params.utcTimeCreated,
    );
  }
}
