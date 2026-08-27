import '../../features/aicycle_buy_me/domain/entities/directional_image.dart';

extension DirectionalImageExt on DirectionalImage {
  String? get cacheKey {
    final path = imageUrl?.split('?').first;
    if (imageId != null && path != null) return '${imageId}_$path';
    return imageId?.toString() ?? path;
  }
}
