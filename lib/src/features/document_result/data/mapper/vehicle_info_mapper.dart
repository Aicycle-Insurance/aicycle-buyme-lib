import '../../domain/entities/vehicle_info.dart';
import '../models/vehicle_info_model.dart';

extension VehicleInfoMapper on VehicleInfoModel {
  VehicleInfo toEntity() {
    return VehicleInfo(
      carCompany: carCompany,
      carModel: carModel,
      carColor: carColor,
      plateNumber: plateNumber,
      vinNumber: vinNumber,
      odo: odo?.floorToDouble(),
    );
  }
}
