import '../../domain/entities/upload_vehicle_inspection.dart';
import '../models/upload_vehicle_inspection_response.dart';

extension UploadVehicleInspectionMapper on UploadVehicleInspectionResponse {
  UploadVehicleInspection toEntity() {
    return UploadVehicleInspection(
      errorCodeFromEngine: errorCodeFromEngine,
      errorMessage: errorMessage,
      imageId: imageId,
      imgUrl: imgUrl,
    );
  }
}
