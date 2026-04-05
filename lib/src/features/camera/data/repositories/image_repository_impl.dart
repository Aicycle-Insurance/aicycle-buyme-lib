import '../../domain/entities/cert_upload_entity.dart';
import '../../domain/entities/upload_vehicle_inspection.dart';
import '../../domain/repositories/image_respository.dart';
import '../data_source/image_remote_data_source.dart';
import '../mapper/upload_vehicle_inspection_mapper.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource _remoteDataSource;
  ImageRepositoryImpl(this._remoteDataSource);

  @override
  Future<CertUploadEntity> uploadVehicleInspection({
    required List<String> imagePaths,
    required String claimId,
  }) async {
    final response = await _remoteDataSource.uploadVehicleInspection(
      imagePaths: imagePaths,
      claimId: claimId,
    );
    return response.toEntity();
  }

  @override
  Future<UploadVehicleInspection> uploadImage({
    required String imagePath,
    required String claimId,
    String? angleId,
    bool isFramedPhoto = false,
  }) async {
    final response = await _remoteDataSource.uploadImage(
      imagePath: imagePath,
      claimId: claimId,
      angleId: angleId,
      isFramedPhoto: isFramedPhoto,
    );
    return response.toEntity();
  }

  @override
  Future<void> deleteImageById({
    required List<int> imageIds,
    String? vehicleAngleId,
  }) async {
    await _remoteDataSource.deleteImageById(imageIds, vehicleAngleId);
  }
}
