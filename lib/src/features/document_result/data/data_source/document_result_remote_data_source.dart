import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/segment_result_model.dart';
import '../models/vehicle_info_model.dart';

abstract class DocumentResultRemoteDataSource {
  Future<VehicleInfoModel> getVehicleInfo(String claimId);
  Future<List<SegmentResultModel>> getDamageStatistics(String claimId);
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
}
