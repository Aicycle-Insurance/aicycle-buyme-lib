import '../entities/segment_result.dart';
import '../entities/vehicle_info.dart';

abstract class DocumentResultRepository {
  /// API: GET /v2/claimfolders/car-info
  Future<VehicleInfo> getVehicleInfo(String claimId);

  /// API: GET /v2/claimfolders/$claimId/segment-classify-result
  Future<List<SegmentResult>> getDamageStatistics(String claimId);

  /// API: GET /insurance/images/{imageId}
  Future<Map<String, dynamic>> getImageDetails(int imageId);
}
