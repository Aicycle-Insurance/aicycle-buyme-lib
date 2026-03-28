import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';

class UploadVehicleInspection {
  final int? errorCodeFromEngine;
  final String? errorMessage;
  final int? imageId;
  final String? imgUrl;
  final AicycleCarAngle? angleFromEngine;

  UploadVehicleInspection({
    this.errorCodeFromEngine,
    this.errorMessage,
    this.imageId,
    this.imgUrl,
    this.angleFromEngine,
  });
}
