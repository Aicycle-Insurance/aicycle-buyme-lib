class UploadVehicleInspectionResponse {
  final int? errorCodeFromEngine;
  final String? errorMessage;
  final int? claimId;
  final int? vehicleInspectionOcrId;
  final String? carCompany;
  final String? carModel;
  final int? imageId;
  final String? imgUrl;
  final String? imageDirection;
  final String? errorLevel;

  UploadVehicleInspectionResponse({
    this.errorCodeFromEngine,
    this.errorMessage,
    this.claimId,
    this.vehicleInspectionOcrId,
    this.carCompany,
    this.carModel,
    this.imageId,
    this.imgUrl,
    this.imageDirection,
    this.errorLevel,
  });

  factory UploadVehicleInspectionResponse.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as Map<String, dynamic>?;
    final extraInfor = result?['extraInfor'] as Map<String, dynamic>?;
    String? imgDirection = extraInfor?['imageDirection'] as String?;
    if (imgDirection == null) {
      if (json.containsKey('stampImageId')) {
        imgDirection = 'tem-dang-kiem-LC81Ar';
      } else if (json.containsKey('vehicleInspectionOcrId')) {
        imgDirection = 'dang-kiem-xe-82YjAa';
      } else if (json.containsKey('taploImageId')) {
        imgDirection = 'tap-lo-H4SHs1';
      } else if (json.containsKey('vinImageId')) {
        imgDirection = 'so-khung-qmqAsM';
      }
    }
    return UploadVehicleInspectionResponse(
      errorLevel: json['errorLevel'] as String?,
      errorCodeFromEngine: json['errorCodeFromEngine'] as int?,
      errorMessage: (json['errorMessage'] ?? json['message']) as String?,
      claimId: json['claimId'] as int?,
      vehicleInspectionOcrId: json['vehicleInspectionOcrId'] as int?,
      carCompany: json['carCompany'] as String?,
      carModel: json['carModel'] as String?,
      imageId: (json['imageId'] ??
              json['stampImageId'] ??
              json['vehicleInspectionOcrId'] ??
              json['taploImageId'] ??
              json['vinImageId'])
          as int?,
      imgUrl: result?['imgUrl'] as String?,
      imageDirection: imgDirection,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (errorLevel != null) 'errorLevel': errorLevel,
      if (errorCodeFromEngine != null)
        'errorCodeFromEngine': errorCodeFromEngine,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (claimId != null) 'claimId': claimId,
      if (vehicleInspectionOcrId != null)
        'vehicleInspectionOcrId': vehicleInspectionOcrId,
      if (carCompany != null) 'carCompany': carCompany,
      if (carModel != null) 'carModel': carModel,
      if (imageId != null) 'imageId': imageId,
      if (imgUrl != null) 'imgUrl': imgUrl,
      if (imageDirection != null) 'imageDirection': imageDirection,
    };
  }
}

class CertUploadResponse {
  final int? errorCodeFromEngine;
  final String? errorMessage;
  final int? claimId;
  final int? vehicleInspectionOcrId;
  final String? carCompany;
  final String? carModel;
  final int? imageId;
  final String? imgUrl;
  final String? imageDirection;
  final String? errorLevel;
  final PredictedCarInfo? predictedCarInfo;

  CertUploadResponse({
    this.errorCodeFromEngine,
    this.errorLevel,
    this.errorMessage,
    this.claimId,
    this.vehicleInspectionOcrId,
    this.carCompany,
    this.carModel,
    this.imageId,
    this.imgUrl,
    this.imageDirection,
    this.predictedCarInfo,
  });

  factory CertUploadResponse.fromJson(Map<String, dynamic> json) {
    final base = UploadVehicleInspectionResponse.fromJson(json);
    final result = json['result'] as Map<String, dynamic>?;
    final predictedCarInfoJson =
        result?['predictedCarInfo'] as Map<String, dynamic>?;

    return CertUploadResponse(
      errorCodeFromEngine: base.errorCodeFromEngine,
      errorLevel: base.errorLevel,
      errorMessage: base.errorMessage,
      claimId: base.claimId,
      vehicleInspectionOcrId: base.vehicleInspectionOcrId,
      carCompany: base.carCompany,
      carModel: base.carModel,
      imageId: base.imageId,
      imgUrl: base.imgUrl,
      imageDirection: base.imageDirection,
      predictedCarInfo: predictedCarInfoJson != null
          ? PredictedCarInfo.fromJson(predictedCarInfoJson)
          : null,
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
      if (imageId != null) 'imageId': imageId,
      if (imgUrl != null) 'imgUrl': imgUrl,
      if (imageDirection != null) 'imageDirection': imageDirection,
      if (errorLevel != null) 'errorLevel': errorLevel,
      if (predictedCarInfo != null)
        'predictedCarInfo': predictedCarInfo!.toJson(),
    };
  }
}

class PredictedCarInfo {
  final String? vehicleType;
  final List<String>? imageUrls;

  PredictedCarInfo({this.vehicleType, this.imageUrls});

  factory PredictedCarInfo.fromJson(Map<String, dynamic> json) {
    return PredictedCarInfo(
      vehicleType: json['vehicleType'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (imageUrls != null) 'imageUrls': imageUrls,
    };
  }
}

