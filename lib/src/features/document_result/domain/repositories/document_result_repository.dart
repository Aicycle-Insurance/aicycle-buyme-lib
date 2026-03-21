import '../entities/segment_result.dart';
import '../entities/vehicle_info.dart';

abstract class DocumentResultRepository {
  Future<VehicleInfo> getVehicleInfo(String claimId);
  Future<List<SegmentResult>> getDamageStatistics(String claimId);
}
