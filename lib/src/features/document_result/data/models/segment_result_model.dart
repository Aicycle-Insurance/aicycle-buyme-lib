class SegmentResultModel {
  final String? vehiclePartExcelId;
  final String? vehiclePartName;
  final double? paintPercentage;
  final String? dentedLevel;
  final List<DamageModel>? damages;
  final List<SegmentImageModel>? images;

  SegmentResultModel({
    this.vehiclePartExcelId,
    this.vehiclePartName,
    this.paintPercentage,
    this.dentedLevel,
    this.damages,
    this.images,
  });

  factory SegmentResultModel.fromJson(Map<String, dynamic> json) {
    return SegmentResultModel(
      vehiclePartExcelId: json['vehiclePartExcelId'],
      vehiclePartName: json['vehiclePartName'],
      paintPercentage: (json['paintPercentage'] as num?)?.toDouble(),
      dentedLevel: json['dentedLevel'],
      damages: (json['damages'] as List?)
          ?.map((e) => DamageModel.fromJson(e))
          .toList(),
      images: (json['images'] as List?)
          ?.map((e) => SegmentImageModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehiclePartExcelId': vehiclePartExcelId,
      'vehiclePartName': vehiclePartName,
      'paintPercentage': paintPercentage,
      'dentedLevel': dentedLevel,
      'damages': damages?.map((e) => e.toJson()).toList(),
      'images': images?.map((e) => e.toJson()).toList(),
    };
  }
}

class DamageModel {
  final String? damageTypeSlug;
  final String? damageTypeName;
  final double? damagePercentage;
  final String? damageTypeColor;

  DamageModel({
    this.damageTypeSlug,
    this.damageTypeName,
    this.damagePercentage,
    this.damageTypeColor,
  });

  factory DamageModel.fromJson(Map<String, dynamic> json) {
    return DamageModel(
      damageTypeSlug: json['damageTypeSlug'],
      damageTypeName: json['damageTypeName'],
      damagePercentage: (json['damagePercentage'] as num?)?.toDouble(),
      damageTypeColor: json['damageTypeColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'damageTypeSlug': damageTypeSlug,
      'damageTypeName': damageTypeName,
      'damagePercentage': damagePercentage,
      'damageTypeColor': damageTypeColor,
    };
  }
}

class SegmentImageModel {
  final int? imageId;
  final int? claimId;
  final List<int>? resolution;
  final String? filePath;
  final String? directionEngineSlug;
  final String? positionEngineSlug;
  final String? directionSlug;
  final String? positionSlug;
  final ExtraInfoModel? extraInfo;
  final String? errorType;
  final String? errorNote;
  final String? requestedTime;
  final String? uploadedTime;
  final String? uploadLocation;
  final double? timeProcess;
  final int? timeAppUpload;
  final String? location;
  final String? imageUrl;
  final String? imageDrawUrl;
  final String? traceId;
  final List<DamageImageInfoModel>? damageImageInfo;

  SegmentImageModel({
    this.imageId,
    this.claimId,
    this.resolution,
    this.filePath,
    this.directionEngineSlug,
    this.positionEngineSlug,
    this.directionSlug,
    this.positionSlug,
    this.extraInfo,
    this.errorType,
    this.errorNote,
    this.requestedTime,
    this.uploadedTime,
    this.uploadLocation,
    this.timeProcess,
    this.timeAppUpload,
    this.location,
    this.imageUrl,
    this.imageDrawUrl,
    this.damageImageInfo,
    this.traceId,
  });

  factory SegmentImageModel.fromJson(Map<String, dynamic> json) {
    return SegmentImageModel(
      imageId: json['imageId'],
      claimId: json['claimId'],
      resolution: (json['resolution'] as List?)?.map((e) => e as int).toList(),
      filePath: json['filePath'],
      directionEngineSlug: json['directionEngineSlug'],
      positionEngineSlug: json['positionEngineSlug'],
      directionSlug: json['directionSlug'],
      positionSlug: json['positionSlug'],
      extraInfo: json['extraInfo'] != null
          ? ExtraInfoModel.fromJson(json['extraInfo'])
          : null,
      errorType: json['errorType'],
      errorNote: json['errorNote'],
      requestedTime: json['requestedTime'],
      uploadedTime: json['uploadedTime'],
      uploadLocation: json['uploadLocation'],
      timeProcess: (json['timeProcess'] as num?)?.toDouble(),
      timeAppUpload: (json['timeAppUpload'] as num?)?.toInt(),
      location: json['location'],
      imageUrl: json['imageUrl'],
      imageDrawUrl: json['imageDrawUrl'],
      damageImageInfo: (json['damageImageInfo'] as List?)
          ?.map((e) => DamageImageInfoModel.fromJson(e))
          .toList(),
      traceId: json['traceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageId': imageId,
      'claimId': claimId,
      'resolution': resolution,
      'filePath': filePath,
      'directionEngineSlug': directionEngineSlug,
      'positionEngineSlug': positionEngineSlug,
      'directionSlug': directionSlug,
      'positionSlug': positionSlug,
      'extraInfo': extraInfo?.toJson(),
      'errorType': errorType,
      'errorNote': errorNote,
      'requestedTime': requestedTime,
      'uploadedTime': uploadedTime,
      'uploadLocation': uploadLocation,
      'timeProcess': timeProcess,
      'timeAppUpload': timeAppUpload,
      'location': location,
      'imageUrl': imageUrl,
      'imageDrawUrl': imageDrawUrl,
      'damageImageInfo': damageImageInfo?.map((e) => e.toJson()).toList(),
      'traceId': traceId,
    };
  }
}

class ExtraInfoModel {
  final String? carCompany;
  final String? carModel;
  final List<int>? carColor;
  final String? plateNumber;

  ExtraInfoModel({
    this.carCompany,
    this.carModel,
    this.carColor,
    this.plateNumber,
  });

  factory ExtraInfoModel.fromJson(Map<String, dynamic> json) {
    return ExtraInfoModel(
      carCompany: json['carCompany'],
      carModel: json['carModel'],
      carColor: (json['carColor'] as List?)?.map((e) => e as int).toList(),
      plateNumber: json['plateNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carCompany': carCompany,
      'carModel': carModel,
      'carColor': carColor,
      'plateNumber': plateNumber,
    };
  }
}

class DamageImageInfoModel {
  final String? maskUrl;
  final String? damageTypeSlug;
  final String? damageTypeName;
  final double? damagePercentage;
  final String? damageTypeColor;
  final List<double>? boxes;

  DamageImageInfoModel({
    this.maskUrl,
    this.damageTypeSlug,
    this.damageTypeName,
    this.damagePercentage,
    this.damageTypeColor,
    this.boxes,
  });

  factory DamageImageInfoModel.fromJson(Map<String, dynamic> json) {
    return DamageImageInfoModel(
      maskUrl: json['maskUrl'],
      damageTypeSlug: json['damageTypeSlug'],
      damageTypeName: json['damageTypeName'],
      damagePercentage: (json['damagePercentage'] as num?)?.toDouble(),
      damageTypeColor: json['damageTypeColor'],
      boxes: (json['boxes'] as List?)?.map((e) => e as double).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maskUrl': maskUrl,
      'damageTypeSlug': damageTypeSlug,
      'damageTypeName': damageTypeName,
      'damagePercentage': damagePercentage,
      'damageTypeColor': damageTypeColor,
      'boxes': boxes,
    };
  }
}
