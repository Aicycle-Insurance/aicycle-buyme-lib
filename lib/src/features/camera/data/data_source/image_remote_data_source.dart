import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/upload_vehicle_inspection_response.dart';

abstract class ImageRemoteDataSource {
  Future<UploadVehicleInspectionResponse> uploadVehicleInspection({
    required String imagePath,
    required String claimId,
  });
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final DioClient _dioClient;
  ImageRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UploadVehicleInspectionResponse> uploadVehicleInspection({
    required String imagePath,
    required String claimId,
  }) async {
    final formData = await _dioClient.createFormData({
      'img': await _dioClient.createMultipartFile(imagePath),
      'claimId': claimId,
    });

    final response = await _dioClient.post<dynamic>(
      ApiEndpoints.uploadVehicleInspection,
      data: formData,
    );
    return UploadVehicleInspectionResponse.fromJson(response);
  }
}
