import '../entities/cert_upload_entity.dart';
import '../entities/upload_vehicle_inspection.dart';

abstract class ImageRepository {
  Future<CertUploadEntity> uploadVehicleInspection({
    required List<String> imagePaths,
    required String claimId,
  });

  Future<UploadVehicleInspection> uploadImage({
    required String imagePath,
    required String claimId,
    String? angleId,
    bool isFramedPhoto = false,
  });

  Future<void> deleteImageById({
    required List<int> imageIds,
    String? vehicleAngleId,
  });
}
