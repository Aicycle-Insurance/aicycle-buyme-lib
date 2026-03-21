import '../entities/vehicle_info.dart';

abstract class DocumentResultRepository {
  Future<VehicleInfo> getVehicleInfo(String claimId);
}
