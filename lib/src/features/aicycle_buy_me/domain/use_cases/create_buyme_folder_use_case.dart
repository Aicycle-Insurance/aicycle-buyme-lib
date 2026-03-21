import '../repositories/buy_me_repository.dart';

class CreateBuyMeFolderParams {
  final String externalClaimId;
  final String? claimName;
  final String? vehicleBrandId;
  final int? priceTypeId;
  final bool? isClaim;
  final String? brand;
  final String? model;
  final int? vehicleYear;
  final String? vehicleSpec;
  final String? licensePlate;
  final String? vehicleType;
  final bool? hasLicensePlate;

  CreateBuyMeFolderParams({
    required this.externalClaimId,
    this.claimName,
    this.vehicleBrandId,
    this.priceTypeId,
    this.isClaim,
    this.brand,
    this.model,
    this.vehicleYear,
    this.vehicleSpec,
    this.licensePlate,
    this.vehicleType,
    this.hasLicensePlate,
  });
}

class CreateBuyMeFolderUseCase {
  final BuyMeRepository _repository;

  CreateBuyMeFolderUseCase(this._repository);

  Future<String> call(CreateBuyMeFolderParams params) async {
    return _repository.createNewAiCycleDocument(
      externalClaimId: params.externalClaimId,
      claimName: params.claimName,
      vehicleBrandId: params.vehicleBrandId,
      priceTypeId: params.priceTypeId,
      isClaim: params.isClaim,
      brand: params.brand,
      model: params.model,
      vehicleYear: params.vehicleYear,
      vehicleSpec: params.vehicleSpec,
      licensePlate: params.licensePlate,
      vehicleType: params.vehicleType,
      hasLicensePlate: params.hasLicensePlate,
    );
  }
}
