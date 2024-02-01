import 'package:dartz/dartz.dart';

import '../../../../network/api_error.dart';
import '../../data/models/check_car_model.dart';
import '../repository/folder_detail_repository.dart';

class BuyMeCheckIsOneCarUsecase {
  final FolderDetailRepository repository;
  BuyMeCheckIsOneCarUsecase(this.repository);

  Future<Either<APIErrors, CheckCarModel>> call(String claimId) {
    return repository.checkIsOneCar(claimId);
  }
}
