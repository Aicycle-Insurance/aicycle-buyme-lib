import 'package:dartz/dartz.dart';

import '../../../../network/api_error.dart';
import '../repository/folder_detail_repository.dart';

class BuyMeDeleteImageByIdUsecase {
  final FolderDetailRepository repository;

  BuyMeDeleteImageByIdUsecase(this.repository);

  Future<Either<APIErrors, bool>> call(String imageId) {
    return repository.deleteImageById(imageId);
  }
}
