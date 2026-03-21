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
  final String? filePath;

  ImageEntity({this.imageId, this.resolution, this.filePath});
}

class DamageEntity {
  final String? damageTypeName;
  final double? damagePercentage;
  final String? damageTypeColor;

  DamageEntity({
    this.damageTypeName,
    this.damagePercentage,
    this.damageTypeColor,
  });
}
