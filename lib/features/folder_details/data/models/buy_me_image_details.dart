import 'package:equatable/equatable.dart';

class GeneralInfo extends Equatable {
  final String? carCompany;
  final String? carModel;
  final List<num?>? carColor;
  final String? plateNumber;
  final String? carCornerEngine;
  final String? carCornerRequest;
  final bool? photoValid;
  final String? imageId;
  final String? carType;
  final String? directionEngineSlug;
  final String? directionRequestSlug;

  const GeneralInfo({
    this.carCompany,
    this.carModel,
    this.carColor,
    this.plateNumber,
    this.carCornerEngine,
    this.carCornerRequest,
    this.photoValid,
    this.imageId,
    this.carType,
    this.directionEngineSlug,
    this.directionRequestSlug,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) {
    return GeneralInfo(
      carCompany: json['carCompany']?.toString(),
      carModel: json['carModel']?.toString(),
      carColor: json['carColor'] is List
          ? json['carColor']
              .map<num?>((e) => num.tryParse(e.toString()))
              .toList()
          : null,
      plateNumber: json['plateNumber']?.toString(),
      carCornerEngine: json['carCornerEngine']?.toString(),
      carCornerRequest: json['carCornerRequest']?.toString(),
      photoValid: json['photoValid'].toString().contains('true'),
      imageId: json['imageId']?.toString(),
      carType: json['carType']?.toString(),
      directionEngineSlug: json['directionEngineSlug']?.toString(),
      directionRequestSlug: json['directionRequestSlug']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (carCompany != null) 'carCompany': carCompany,
        if (carModel != null) 'carModel': carModel,
        if (carColor != null) 'carColor': carColor,
        if (plateNumber != null) 'plateNumber': plateNumber,
        if (carCornerEngine != null) 'carCornerEngine': carCornerEngine,
        if (carCornerRequest != null) 'carCornerRequest': carCornerRequest,
        if (photoValid != null) 'photoValid': photoValid,
        if (imageId != null) 'imageId': imageId,
        if (carType != null) 'carType': carType,
        if (directionEngineSlug != null)
          'directionEngineSlug': directionEngineSlug,
        if (directionRequestSlug != null)
          'directionRequestSlug': directionRequestSlug,
      };

  GeneralInfo copyWith({
    String? carCompany,
    String? carModel,
    List<num?>? carColor,
    String? plateNumber,
    String? carCornerEngine,
    String? carCornerRequest,
    bool? photoValid,
    String? imageId,
    String? carType,
    String? directionEngineSlug,
    String? directionRequestSlug,
  }) {
    return GeneralInfo(
      carCompany: carCompany ?? this.carCompany,
      carModel: carModel ?? this.carModel,
      carColor: carColor ?? this.carColor,
      plateNumber: plateNumber ?? this.plateNumber,
      carCornerEngine: carCornerEngine ?? this.carCornerEngine,
      carCornerRequest: carCornerRequest ?? this.carCornerRequest,
      photoValid: photoValid ?? this.photoValid,
      imageId: imageId ?? this.imageId,
      carType: carType ?? this.carType,
      directionEngineSlug: directionEngineSlug ?? this.directionEngineSlug,
      directionRequestSlug: directionRequestSlug ?? this.directionRequestSlug,
    );
  }

  @override
  List<Object?> get props {
    return [
      carCompany,
      carModel,
      carColor,
      plateNumber,
      carCornerEngine,
      carCornerRequest,
      photoValid,
      imageId,
      carType,
      directionEngineSlug,
      directionRequestSlug,
    ];
  }
}

class Segments extends Equatable {
  final String? vehiclePartName;
  final String? masksPath;
  final String? masksUrl;
  final String? vehicleColor;
  final List<num?>? boxes;

  const Segments({
    this.vehiclePartName,
    this.masksPath,
    this.masksUrl,
    this.vehicleColor,
    this.boxes,
  });

  factory Segments.fromJson(Map<String, dynamic> json) {
    return Segments(
      vehiclePartName: json['vehiclePartName']?.toString(),
      masksPath: json['masksPath']?.toString(),
      masksUrl: json['masksUrl']?.toString(),
      vehicleColor: json['vehicleColor']?.toString(),
      boxes: json['boxes'] is List
          ? json['boxes'].map<num?>((e) => num.tryParse(e.toString())).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (vehiclePartName != null) 'vehiclePartName': vehiclePartName,
        if (masksPath != null) 'masksPath': masksPath,
        if (masksUrl != null) 'masksUrl': masksUrl,
        if (vehicleColor != null) 'vehicleColor': vehicleColor,
        if (boxes != null) 'boxes': boxes,
      };

  Segments copyWith({
    String? vehiclePartName,
    String? masksPath,
    String? masksUrl,
    String? vehicleColor,
    List<num?>? boxes,
  }) {
    return Segments(
      vehiclePartName: vehiclePartName ?? this.vehiclePartName,
      masksPath: masksPath ?? this.masksPath,
      masksUrl: masksUrl ?? this.masksUrl,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      boxes: boxes ?? this.boxes,
    );
  }

  @override
  List<Object?> get props {
    return [
      vehiclePartName,
      masksPath,
      masksUrl,
      vehicleColor,
      boxes,
    ];
  }
}

class DamagesDetail extends Equatable {
  final String? damageName;
  final num? damagePercentage;
  final String? damageColor;
  final String? masksPath;
  final List<num?>? boxes;

  const DamagesDetail({
    this.damageName,
    this.damagePercentage,
    this.damageColor,
    this.masksPath,
    this.boxes,
  });

  factory DamagesDetail.fromJson(Map<String, dynamic> json) {
    return DamagesDetail(
      damageName: json['damageName']?.toString(),
      damagePercentage: num.tryParse(json['damagePercentage'].toString()),
      damageColor: json['damageColor']?.toString(),
      masksPath: json['masksPath']?.toString(),
      boxes: json['boxes'] is List
          ? json['boxes'].map<num?>((e) => num.tryParse(e.toString())).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (damageName != null) 'damageName': damageName,
        if (damagePercentage != null) 'damagePercentage': damagePercentage,
        if (damageColor != null) 'damageColor': damageColor,
        if (masksPath != null) 'masksPath': masksPath,
        if (boxes != null) 'boxes': boxes,
      };

  DamagesDetail copyWith({
    String? damageName,
    num? damagePercentage,
    String? damageColor,
    String? masksPath,
    List<num?>? boxes,
  }) {
    return DamagesDetail(
      damageName: damageName ?? this.damageName,
      damagePercentage: damagePercentage ?? this.damagePercentage,
      damageColor: damageColor ?? this.damageColor,
      masksPath: masksPath ?? this.masksPath,
      boxes: boxes ?? this.boxes,
    );
  }

  @override
  List<Object?> get props {
    return [
      damageName,
      damagePercentage,
      damageColor,
      masksPath,
      boxes,
    ];
  }
}

class Damages extends Equatable {
  final List<DamagesDetail>? damagesDetail;
  final String? vehiclePartName;

  const Damages({
    this.damagesDetail,
    this.vehiclePartName,
  });

  factory Damages.fromJson(Map<String, dynamic> json) {
    return Damages(
      damagesDetail: json['damagesDetail'] is List
          ? json['damagesDetail']
              .map<DamagesDetail>((e) => DamagesDetail.fromJson(e))
              .toList()
          : null,
      vehiclePartName: json['vehiclePartName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (damagesDetail != null) 'damagesDetail': damagesDetail,
        if (vehiclePartName != null) 'vehiclePartName': vehiclePartName,
      };

  Damages copyWith({
    List<DamagesDetail>? damagesDetail,
    String? vehiclePartName,
  }) {
    return Damages(
      damagesDetail: damagesDetail ?? this.damagesDetail,
      vehiclePartName: vehiclePartName ?? this.vehiclePartName,
    );
  }

  @override
  List<Object?> get props {
    return [
      damagesDetail,
      vehiclePartName,
    ];
  }
}

class BuyMeImageDetails extends Equatable {
  final GeneralInfo? generalInfo;
  final List<Segments>? segments;
  final List<Damages>? damages;
  final dynamic errorType;
  final dynamic errorNote;
  final String? filePath;
  final dynamic location;
  final dynamic requestedTime;
  final String? uploadedTime;
  final String? uploadLocation;
  final String? traceId;
  final num? timeProcess;
  final num? timeAppUpload;

  const BuyMeImageDetails({
    this.generalInfo,
    this.segments,
    this.damages,
    this.errorType,
    this.errorNote,
    this.filePath,
    this.location,
    this.requestedTime,
    this.uploadedTime,
    this.uploadLocation,
    this.traceId,
    this.timeProcess,
    this.timeAppUpload,
  });

  factory BuyMeImageDetails.fromJson(Map<String, dynamic> json) {
    return BuyMeImageDetails(
      generalInfo: json['generalInfo'] == null
          ? null
          : GeneralInfo.fromJson(
              Map<String, dynamic>.from(json['generalInfo'])),
      segments: json['segments'] is List
          ? json['segments'].map<Segments>((e) => Segments.fromJson(e)).toList()
          : null,
      damages: json['damages'] is List
          ? json['damages'].map<Damages>((e) => Damages.fromJson(e)).toList()
          : null,
      errorType: json['errorType'],
      errorNote: json['errorNote'],
      filePath: json['filePath']?.toString(),
      location: json['location'],
      requestedTime: json['requestedTime'],
      uploadedTime: json['uploadedTime']?.toString(),
      uploadLocation: json['uploadLocation']?.toString(),
      traceId: json['traceId']?.toString(),
      timeProcess: num.tryParse(json['timeProcess'].toString()),
      timeAppUpload: num.tryParse(json['timeAppUpload'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (generalInfo != null) 'generalInfo': generalInfo,
        if (segments != null) 'segments': segments,
        if (damages != null) 'damages': damages,
        if (errorType != null) 'errorType': errorType,
        if (errorNote != null) 'errorNote': errorNote,
        if (filePath != null) 'filePath': filePath,
        if (location != null) 'location': location,
        if (requestedTime != null) 'requestedTime': requestedTime,
        if (uploadedTime != null) 'uploadedTime': uploadedTime,
        if (uploadLocation != null) 'uploadLocation': uploadLocation,
        if (traceId != null) 'traceId': traceId,
        if (timeProcess != null) 'timeProcess': timeProcess,
        if (timeAppUpload != null) 'timeAppUpload': timeAppUpload,
      };

  BuyMeImageDetails copyWith({
    GeneralInfo? generalInfo,
    List<Segments>? segments,
    List<Damages>? damages,
    dynamic errorType,
    dynamic errorNote,
    String? filePath,
    dynamic location,
    dynamic requestedTime,
    String? uploadedTime,
    String? uploadLocation,
    String? traceId,
    num? timeProcess,
    num? timeAppUpload,
  }) {
    return BuyMeImageDetails(
      generalInfo: generalInfo ?? this.generalInfo,
      segments: segments ?? this.segments,
      damages: damages ?? this.damages,
      errorType: errorType ?? this.errorType,
      errorNote: errorNote ?? this.errorNote,
      filePath: filePath ?? this.filePath,
      location: location ?? this.location,
      requestedTime: requestedTime ?? this.requestedTime,
      uploadedTime: uploadedTime ?? this.uploadedTime,
      uploadLocation: uploadLocation ?? this.uploadLocation,
      traceId: traceId ?? this.traceId,
      timeProcess: timeProcess ?? this.timeProcess,
      timeAppUpload: timeAppUpload ?? this.timeAppUpload,
    );
  }

  @override
  List<Object?> get props {
    return [
      generalInfo,
      segments,
      damages,
      errorType,
      errorNote,
      filePath,
      location,
      requestedTime,
      uploadedTime,
      uploadLocation,
      traceId,
      timeProcess,
      timeAppUpload,
    ];
  }
}
