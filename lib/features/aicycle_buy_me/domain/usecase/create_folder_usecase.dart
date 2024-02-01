import 'package:dartz/dartz.dart';

import '../../../../network/api_error.dart';
import '../../data/model/claim_folder_model.dart';
import '../repository/aicycle_buy_me_repository.dart';

class BuyMeCreateFolderUsecase {
  final AiCycleBuyMeRepository repository;
  BuyMeCreateFolderUsecase(this.repository);
  Future<Either<APIErrors, ClaimFolderModel>> call({
    required String externalClaimId,
    required String folderName,
    String? vehicleBrandId,
    String? parentId,
    String? vehicleLicensePlates,
    String? carColor,
    String? appUser,
    bool isClaim = true,
    bool? hasLicensePlate = true,
  }) {
    return repository.createFolder(
      externalClaimId: externalClaimId,
      folderName: folderName,
      appUser: appUser,
      carColor: carColor,
      hasLicensePlate: hasLicensePlate,
      isClaim: isClaim,
      parentId: parentId,
      vehicleBrandId: vehicleBrandId,
      vehicleLicensePlates: vehicleLicensePlates,
    );
  }
}
