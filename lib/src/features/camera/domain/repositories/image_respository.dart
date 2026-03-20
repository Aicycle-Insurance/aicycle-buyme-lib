import '../entities/upload_vehicle_inspection.dart';

abstract class ImageRepository {
  Future<UploadVehicleInspection> uploadVehicleInspection({
    required String imagePath,
    required String claimId,
  });

  Future<UploadVehicleInspection> uploadImage({
    required String imagePath,
    required String claimId,
    String? angleId,
    bool isFramedPhoto = false,
  });
}
