import '../../domain/entities/upload_vehicle_inspection.dart';
import '../../domain/repositories/image_respository.dart';
import '../data_source/image_remote_data_source.dart';
import '../mapper/upload_vehicle_inspection_mapper.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource _remoteDataSource;
  ImageRepositoryImpl(this._remoteDataSource);

  @override
  Future<UploadVehicleInspection> uploadVehicleInspection({
    required String imagePath,
    required String claimId,
  }) async {
    final response = await _remoteDataSource.uploadVehicleInspection(
      imagePath: imagePath,
      claimId: claimId,
    );
    return response.toEntity();
  }
}
