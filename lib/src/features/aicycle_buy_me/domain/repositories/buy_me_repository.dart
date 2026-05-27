import '../entities/directional_image.dart';

abstract class BuyMeRepository {
  Future<String> createNewAiCycleDocument({
    required String externalClaimId,
    String? claimName,
    String? vehicleBrandId,
    int? priceTypeId,
    bool? isClaim,
    String? brand,
    String? model,
    int? vehicleYear,
    String? vehicleSpec,
    String? licensePlate,
    String? vehicleType,
    bool? hasLicensePlate,
  });

  Future<List<DirectionalImage>> getDirectionalImages({
    required String claimId,
    required String angleId,
  });

  Future<String> getValidationResult({required String claimId});

  Future<void> getClaimFolderById(String claimId);
}
