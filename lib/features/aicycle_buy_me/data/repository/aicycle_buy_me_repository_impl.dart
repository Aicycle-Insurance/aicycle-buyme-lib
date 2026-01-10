import 'package:dartz/dartz.dart';

import '../../../../network/api_error.dart';
import '../../domain/repository/aicycle_buy_me_repository.dart';
import '../model/claim_folder_model.dart';
import '../remote_data/aicycle_buyme_api.dart';

class AicycleBuyMeRepositoryImpl implements AiCycleBuyMeRepository {
  @override
  Future<Either<APIErrors, ClaimFolderModel>> createFolder({
    required String externalClaimId,
    required String folderName,
    String? vehicleBrandId,
    String? parentId,
    String? vehicleLicensePlates,
    String? carColor,
    String? appUser,
    bool isClaim = true,
    bool? hasLicensePlate = true,
  }) async {
    try {
      final res = await AicycleBuyMeApi.createFolder(
        externalClaimId: externalClaimId,
        folderName: folderName,
        appUser: appUser,
        carColor: carColor,
        hasLicensePlate: hasLicensePlate,
        isClaim: isClaim,
        parentId: parentId,
        vehicleBrandId: vehicleBrandId,
        vehicleLicensePlates: vehicleLicensePlates,
      ).request();
      if (res is List) {
        return Right(ClaimFolderModel.fromJson(res[0]));
      }
      return Right(ClaimFolderModel.fromJson(res));
    } catch (e) {
      if (e is APIErrors) {
        return Left(e);
      } else {
        return Left(FetchDataError(e.toString()));
      }
    }
  }

  @override
  Future<Either<APIErrors, ClaimFolderModel>> getDuplicateFolder({
    required String externalClaimId,
  }) async {
    try {
      final res = await AicycleBuyMeApi.getDuplicateFolder(
        externalClaimId: externalClaimId,
      ).request();
      return Right(ClaimFolderModel.fromJson(res[0]));
    } catch (e) {
      if (e is APIErrors) {
        return Left(e);
      } else {
        return Left(FetchDataError(e.toString()));
      }
    }
  }
}
