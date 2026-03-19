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

  // Add more endpoints here as the SDK grows
  // static const String uploadImage = '/images/upload';
}
