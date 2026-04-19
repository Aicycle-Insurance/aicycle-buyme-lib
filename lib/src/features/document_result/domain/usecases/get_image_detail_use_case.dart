import '../repositories/document_result_repository.dart';

/// API: GET /insurance/images/{imageId}
class GetImageDetailUseCase {
  final DocumentResultRepository _repository;

  GetImageDetailUseCase(this._repository);

  Future<Map<String, dynamic>> call(int imageId) {
    return _repository.getImageDetails(imageId);
  }
}
