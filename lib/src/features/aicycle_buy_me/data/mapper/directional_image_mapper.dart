import '../models/directional_image_model.dart';
import '../../domain/entities/directional_image.dart';

extension DirectionalImageMapper on DirectionalImageModel {
  DirectionalImage toEntity() {
    return DirectionalImage(imageId: imageId, imageUrl: imageUrl);
  }
}
