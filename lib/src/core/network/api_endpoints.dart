/// Centralized API endpoints for the AiCycle SDK.
class ApiEndpoints {
  ApiEndpoints._();

  /// Endpoint for creating and managing claim folders.
  static const String createClaimDocument = '/claimfolders';

  /// Endpoint for fetching directional images of a claim folder.
  static const String directionalImages = '/v2/claimfolders/directional-images';

  // Add more endpoints here as the SDK grows
  // static const String uploadImage = '/images/upload';
}
