/// Centralized API endpoints for the AiCycle SDK.
class ApiEndpoints {
  ApiEndpoints._();

  /// Endpoint for creating and managing claim folders.
  static const String createClaimDocument = '/claimfolders';

  /// Endpoint for fetching directional images of a claim folder.
  static const String directionalImages = '/v2/claimfolders/directional-images';

  /// Endpoint for uploading vehicle inspection (đăng kiểm) images.
  static const String uploadVehicleInspection =
      '/v2/buy-me/vehicle-inspection/upload';

  ///  === Combo api for upload image (Các góc khác ngoài đăng kiểm) ===
  /// Endpoint for getting url for upload image.
  static const String getImageUploadURL = '/images/url';

  /// Endpoint for validate uploaded image.
  static const String validateUploadImage = '/claimimages/validate';

  /// Endpoint for process uploaded image.
  static const String processImage = '/v2/buy-me/process';
  // === End Combo api for upload image ===

  /// Endpoint for delete image by id.
  static String deleteImageById(String imageId) => '/claimimages/$imageId';

  /// Endpoint for get validation result.
  static const String getValidationResult =
      '/v2/claimfolders/directional-images/validate';

  /// Endpoint for get vehicle info.
  static const String getVehicleInfo = '/v2/claimfolders/car-info';

  /// Endpoint for get segment result.
  static String getSegmentResult(String claimId) =>
      '/v2/claimfolders/$claimId/segment-classify-result';

  /// Endpoint for get image result.
  static String getImageResult(String claimId) =>
      '/v2/claimfolders/$claimId/image-result';

  /// Endpoint for get image details.
  static String getImageDetails(int imageId) => '/insurance/images/$imageId';
}
