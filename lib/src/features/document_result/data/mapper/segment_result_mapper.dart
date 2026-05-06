import 'package:aicycle_buyme_plus/src/features/document_result/data/models/segment_result_model.dart';
import 'package:aicycle_buyme_plus/src/features/document_result/domain/entities/segment_result.dart';

extension SegmentResultMapper on SegmentResultModel {
  SegmentResult toEntity() {
    return SegmentResult(
      vehiclePartName: vehiclePartName,
      paintPercentage: paintPercentage,
      dentedLevel: dentedLevel,
      damages: damages?.map((e) => e.toEntity()).toList(),
      images: images?.map((e) => e.toEntity()).toList(),
      fullJsonData: toJson(),
    );
  }
}

extension DamageMapper on DamageModel {
  DamageEntity toEntity() {
    return DamageEntity(
      damageTypeName: damageTypeName,
      damagePercentage: damagePercentage,
      damageTypeColor: damageTypeColor,
    );
  }
}

extension ImageMapper on SegmentImageModel {
  ImageEntity toEntity() {
    return ImageEntity(
      imageId: imageId,
      resolution: resolution,
      filePath: filePath,
      damagesInImage: damageImageInfo
          ?.map(
            (e) => DamageEntity(
              damageTypeId: e.damageTypeSlug,
              damageTypeName: e.damageTypeName,
              damagePercentage: e.damagePercentage,
              damageTypeColor: e.damageTypeColor,
              maskUrl: e.maskUrl,
              boxes: e.boxes,
            ),
          )
          .toList(),
    );
  }
}
