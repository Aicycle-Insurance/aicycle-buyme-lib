import '../entities/segment_result.dart';
import '../repositories/document_result_repository.dart';

/// API: GET /v2/claimfolders/$claimId/segment-classify-result
class GetDamageStatisticsUseCase {
  final DocumentResultRepository _repository;

  GetDamageStatisticsUseCase(this._repository);

  Future<List<SegmentResult>> call(String claimId) {
    return _repository.getDamageStatistics(claimId);
  }
}
