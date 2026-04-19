import '../../domain/entities/segment_result.dart';
import '../../domain/entities/vehicle_info.dart';
import '../../domain/repositories/document_result_repository.dart';
import '../data_source/document_result_remote_data_source.dart';
import '../mapper/segment_result_mapper.dart';
import '../mapper/vehicle_info_mapper.dart';

class DocumentResultRepositoryImpl implements DocumentResultRepository {
  final DocumentResultRemoteDataSource _remoteDataSource;

  DocumentResultRepositoryImpl(this._remoteDataSource);

  @override
  Future<VehicleInfo> getVehicleInfo(String claimId) async {
    final response = await _remoteDataSource.getVehicleInfo(claimId);
    return response.toEntity();
  }

  @override
  Future<List<SegmentResult>> getDamageStatistics(String claimId) async {
    final response = await _remoteDataSource.getDamageStatistics(claimId);
    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Map<String, dynamic>> getImageDetails(int imageId) async {
    final response = await _remoteDataSource.getImageDetails(imageId);
    return response;
  }
}
