import 'package:equatable/equatable.dart';

class BuyMeImage extends Equatable {
  final num? imageId;
  final dynamic location;
  final dynamic requestedTime;
  final String? uploadedTime;
  final String? uploadLocation;
  final String? imageUrl;
  final String? resizeImageUrl;
  final String? directionSlug;
  final List<num?>? imageSize;
  final String? traceId;
  final num? timeAppUpload;
  final num? timeProcess;
  final String? directionName;
  final String? engineCorner;

  const BuyMeImage({
    this.imageId,
    this.location,
    this.requestedTime,
    this.uploadedTime,
    this.uploadLocation,
    this.imageUrl,
    this.resizeImageUrl,
    this.directionSlug,
    this.imageSize,
    this.traceId,
    this.timeAppUpload,
    this.timeProcess,
    this.directionName,
    this.engineCorner,
  });

  factory BuyMeImage.fromJson(Map<String, dynamic> json) {
    return BuyMeImage(
      imageId: num.tryParse(json['imageId'].toString()),
      location: json['location'],
      requestedTime: json['requestedTime'],
      uploadedTime: json['uploadedTime']?.toString(),
      uploadLocation: json['uploadLocation']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      resizeImageUrl: json['resizeImageUrl']?.toString(),
      directionSlug: json['directionSlug']?.toString(),
      imageSize: json['imageSize'] is List
          ? json['imageSize']
              .map<num?>((e) => num.tryParse(e.toString()))
              .toList()
          : null,
      traceId: json['traceId']?.toString(),
      timeAppUpload: num.tryParse(json['timeAppUpload'].toString()),
      timeProcess: num.tryParse(json['timeProcess'].toString()),
      directionName: json['directionName']?.toString(),
      engineCorner: json['engineCorner']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (imageId != null) 'imageId': imageId,
        if (location != null) 'location': location,
        if (requestedTime != null) 'requestedTime': requestedTime,
        if (uploadedTime != null) 'uploadedTime': uploadedTime,
        if (uploadLocation != null) 'uploadLocation': uploadLocation,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (resizeImageUrl != null) 'resizeImageUrl': resizeImageUrl,
        if (directionSlug != null) 'directionSlug': directionSlug,
        if (imageSize != null) 'imageSize': imageSize,
        if (traceId != null) 'traceId': traceId,
        if (timeAppUpload != null) 'timeAppUpload': timeAppUpload,
        if (timeProcess != null) 'timeProcess': timeProcess,
        if (directionName != null) 'directionName': directionName,
        if (engineCorner != null) 'engineCorner': engineCorner,
      };

  BuyMeImage copyWith({
    num? imageId,
    dynamic location,
    dynamic requestedTime,
    String? uploadedTime,
    String? uploadLocation,
    String? imageUrl,
    String? resizeImageUrl,
    String? directionSlug,
    List<num?>? imageSize,
    String? traceId,
    num? timeAppUpload,
    num? timeProcess,
    String? directionName,
    String? engineCorner,
  }) {
    return BuyMeImage(
      imageId: imageId ?? this.imageId,
      location: location ?? this.location,
      requestedTime: requestedTime ?? this.requestedTime,
      uploadedTime: uploadedTime ?? this.uploadedTime,
      uploadLocation: uploadLocation ?? this.uploadLocation,
      imageUrl: imageUrl ?? this.imageUrl,
      resizeImageUrl: resizeImageUrl ?? this.resizeImageUrl,
      directionSlug: directionSlug ?? this.directionSlug,
      imageSize: imageSize ?? this.imageSize,
      traceId: traceId ?? this.traceId,
      timeAppUpload: timeAppUpload ?? this.timeAppUpload,
      timeProcess: timeProcess ?? this.timeProcess,
      directionName: directionName ?? this.directionName,
      engineCorner: engineCorner ?? this.engineCorner,
    );
  }

  @override
  List<Object?> get props {
    return [
      imageId,
      location,
      requestedTime,
      uploadedTime,
      uploadLocation,
      imageUrl,
      resizeImageUrl,
      directionSlug,
      imageSize,
      traceId,
      timeAppUpload,
      timeProcess,
      directionName,
      engineCorner,
    ];
  }
}

class BuyMeImageResponse extends Equatable {
  final List<BuyMeImage>? images;

  const BuyMeImageResponse({
    this.images,
  });

  factory BuyMeImageResponse.fromJson(Map<String, dynamic> json) {
    return BuyMeImageResponse(
      images: json['images'] is List
          ? json['images']
              .map<BuyMeImage>((e) => BuyMeImage.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (images != null) 'images': images,
      };

  BuyMeImageResponse copyWith({
    List<BuyMeImage>? images,
  }) {
    return BuyMeImageResponse(
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props {
    return [
      images,
    ];
  }
}
