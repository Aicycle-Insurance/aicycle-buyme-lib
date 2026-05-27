class SegmentResult {
  final String? vehiclePartName;
  final double? paintPercentage;
  final String? dentedLevel;
  final List<DamageEntity>? damages;
  final List<ImageEntity>? images;
  final Map<String, dynamic>? fullJsonData;

  SegmentResult({
    this.vehiclePartName,
    this.paintPercentage,
    this.dentedLevel,
    this.damages,
    this.images,
    this.fullJsonData,
  });
}

class ImageEntity {
  final int? imageId;
  final List<int>? resolution;
  final String? imageUrl;
  final List<DamageEntity>? damagesInImage;
  // Thời gian tải lên ảnh
  final double? uploadingTime;
  // Thời gian xử lý ảnh
  final double? processingTime;
  // Thời điểm chụp ảnh
  final DateTime? capturedDate;
  // Vị trí chụp ảnh
  final String? capturedLocation;
  // Thời gian tải lên
  final DateTime? uploadedDate;
  // Địa điểm tải lên
  final String? uploadedLocation;
  // Mã xử lý
  final String? traceId;
  // Id của folder aicycle
  final String? aicycleFolderId;

  ImageEntity({
    this.imageId,
    this.resolution,
    this.imageUrl,
    this.damagesInImage,
    this.uploadingTime,
    this.processingTime,
    this.capturedDate,
    this.capturedLocation,
    this.uploadedDate,
    this.uploadedLocation,
    this.traceId,
    this.aicycleFolderId,
  });
}

class DamageEntity {
  final String? damageTypeId;
  final String? damageTypeName;
  final double? damagePercentage;
  final String? damageTypeColor;
  final String? maskUrl;
  final List<double>? boxes;

  DamageEntity({
    this.damageTypeId,
    this.damageTypeName,
    this.damagePercentage,
    this.damageTypeColor,
    this.maskUrl,
    this.boxes,
  });
}
