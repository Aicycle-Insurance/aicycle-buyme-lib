import 'package:aicycle_buyme_lib/features/folder_details/data/models/buy_me_image_details.dart';
import 'package:aicycle_buyme_lib/features/folder_details/data/models/check_car_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../network/api_error.dart';
import '../../domain/repository/folder_detail_repository.dart';
import '../models/buy_me_image_model.dart';
import '../remote_data/folder_detail_api.dart';

class BuyMeFolderDetailRepositoryImpl implements FolderDetailRepository {
  @override
  Future<Either<APIErrors, BuyMeImageResponse>> getImageInfo(
      String claimId) async {
    try {
      final res = await FolderDetailApi.getImageInfo(claimId).request();
      return Right(BuyMeImageResponse.fromJson(res));
    } catch (e) {
      if (e is APIErrors) {
        return Left(e);
      } else {
        return Left(FetchDataError(e.toString()));
      }
    }
  }

  @override
  Future<Either<APIErrors, bool>> deleteImageById(String imageId) async {
    try {
      await FolderDetailApi.deleteImageById(imageId).request();
      return const Right(true);
    } catch (e) {
      if (e is APIErrors) {
        return Left(e);
      } else {
        return Left(FetchDataError('Delete image failed.'));
      }
    }
  }

  @override
  Future<Either<APIErrors, CheckCarModel>> checkIsOneCar(String claimId) async {
    try {
      final res = await FolderDetailApi.checkIsOneCar(claimId).request();
      return Right(CheckCarModel.fromJson(res));
    } catch (e) {
      if (e is APIErrors) {
        return Left(e);
      } else {
        return Left(FetchDataError(e.toString()));
      }
    }
  }

  @override
  Future<Either<APIErrors, BuyMeImageDetails>> getImageDetails(
      String imageId) async {
    try {
      final res = await FolderDetailApi.getImageDetails(imageId).request();
      return Right(BuyMeImageDetails.fromJson(res));
    } catch (e) {
      if (e is APIErrors) {
        return Left(e);
      } else {
        return Left(FetchDataError(e.toString()));
      }
    }
  }
}
