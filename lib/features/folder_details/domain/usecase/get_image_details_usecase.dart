import 'package:dartz/dartz.dart';

import '../../../../network/api_error.dart';
import '../../data/models/buy_me_image_details.dart';
import '../repository/folder_detail_repository.dart';

class BuyMeGetImageDetailsUsecase {
  final FolderDetailRepository repository;
  BuyMeGetImageDetailsUsecase(this.repository);

  Future<Either<APIErrors, BuyMeImageDetails>> call(
    String imageId,
  ) {
    return repository.getImageDetails(imageId);
  }
}
