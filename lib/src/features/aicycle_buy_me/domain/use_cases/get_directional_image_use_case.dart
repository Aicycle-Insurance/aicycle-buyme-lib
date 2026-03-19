import '../entities/directional_image.dart';
import '../repositories/buy_me_repository.dart';

class GetDirectionalImagesParams {
  final String claimId;
  final String angleId;

  GetDirectionalImagesParams({required this.claimId, required this.angleId});
}

class GetDirectionalImagesUseCase {
  final BuyMeRepository _repository;

  GetDirectionalImagesUseCase(this._repository);

  Future<List<DirectionalImage>> call(GetDirectionalImagesParams params) {
    return _repository.getDirectionalImages(
      claimId: params.claimId,
      angleId: params.angleId,
    );
  }
}
