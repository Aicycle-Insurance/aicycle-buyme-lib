import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/segment_result_model.dart';
import '../models/vehicle_info_model.dart';

abstract class DocumentResultRemoteDataSource {
  /// API: GET /v2/claimfolders/car-info
  Future<VehicleInfoModel> getVehicleInfo(String claimId);

  /// API: GET /v2/claimfolders/$claimId/segment-classify-result
  Future<List<SegmentResultModel>> getDamageStatistics(String claimId);

  /// API: GET /insurance/images/{imageId}
  Future<Map<String, dynamic>> getImageDetails(int imageId);
}

class DocumentResultRemoteDataSourceImpl
    implements DocumentResultRemoteDataSource {
  final DioClient _dioClient;

  DocumentResultRemoteDataSourceImpl(this._dioClient);

  @override
  Future<VehicleInfoModel> getVehicleInfo(String claimId) async {
    final response = await _dioClient.get<dynamic>(
      ApiEndpoints.getVehicleInfo,
      queryParameters: {'claimId': claimId},
    );
    return VehicleInfoModel.fromJson(response);
  }

  @override
  Future<List<SegmentResultModel>> getDamageStatistics(String claimId) async {
    final response = await _dioClient.get<List<dynamic>>(
      ApiEndpoints.getSegmentResult(claimId),
    );
    return response.map((e) => SegmentResultModel.fromJson(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> getImageDetails(int imageId) async {
    final response = await _dioClient.get<dynamic>(
      ApiEndpoints.getImageDetails(imageId),
    );
    if (response is! Map<String, dynamic>) {
      return {'error': 'Fail to get image details'};
    }
    if (response.containsKey('results')) {
      return response['results'];
    }
    return response;
  }
}
