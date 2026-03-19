class UploadVehicleInspectionResponse {
  final int? errorCodeFromEngine;
  final String? errorMessage;
  final int? claimId;
  final int? vehicleInspectionOcrId;
  final String? carCompany;
  final String? carModel;

  UploadVehicleInspectionResponse({
    this.errorCodeFromEngine,
    this.errorMessage,
    this.claimId,
    this.vehicleInspectionOcrId,
    this.carCompany,
    this.carModel,
  });

  factory UploadVehicleInspectionResponse.fromJson(Map<String, dynamic> json) {
    return UploadVehicleInspectionResponse(
      errorCodeFromEngine: json['errorCodeFromEngine'] as int?,
      errorMessage: json['errorMessage'] as String?,
      claimId: json['claimId'] as int?,
      vehicleInspectionOcrId: json['vehicleInspectionOcrId'] as int?,
      carCompany: json['carCompany'] as String?,
      carModel: json['carModel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (errorCodeFromEngine != null)
        'errorCodeFromEngine': errorCodeFromEngine,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (claimId != null) 'claimId': claimId,
      if (vehicleInspectionOcrId != null)
        'vehicleInspectionOcrId': vehicleInspectionOcrId,
      if (carCompany != null) 'carCompany': carCompany,
      if (carModel != null) 'carModel': carModel,
    };
  }
}
