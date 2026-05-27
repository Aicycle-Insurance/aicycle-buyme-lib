import '../repositories/buy_me_repository.dart';

class GetFolderDetailUsecase {
  final BuyMeRepository _repository;

  GetFolderDetailUsecase(this._repository);

  Future<void> call(String claimId) async {
    await _repository.getClaimFolderById(claimId);
  }
}
