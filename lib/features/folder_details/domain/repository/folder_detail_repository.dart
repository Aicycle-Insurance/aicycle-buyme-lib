import 'package:dartz/dartz.dart';

import '../../../../network/api_error.dart';
import '../../data/models/buy_me_image_details.dart';
import '../../data/models/buy_me_image_model.dart';
import '../../data/models/check_car_model.dart';

abstract class FolderDetailRepository {
  Future<Either<APIErrors, BuyMeImageResponse>> getImageInfo(String claimId);
  Future<Either<APIErrors, BuyMeImageDetails>> getImageDetails(String imageId);
  Future<Either<APIErrors, bool>> deleteImageById(String imageId);
  Future<Either<APIErrors, CheckCarModel>> checkIsOneCar(String claimId);
}
