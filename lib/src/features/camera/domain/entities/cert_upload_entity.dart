import 'upload_vehicle_inspection.dart';

class CertUploadEntity {
  final String? errorMessage;
  final int? errorCodeFromEngine;
  final ErrorLevel? errorLevel;
  final int? imageId;
  final List<String>? imgUrls;

  CertUploadEntity({
    this.errorMessage,
    this.errorCodeFromEngine,
    this.errorLevel,
    this.imageId,
    this.imgUrls,
  });
}
