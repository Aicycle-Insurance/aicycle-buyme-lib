import '../entities/segment_result.dart';
import '../repositories/document_result_repository.dart';

class GetDamageStatisticsUseCase {
  final DocumentResultRepository _repository;

  GetDamageStatisticsUseCase(this._repository);

  Future<List<SegmentResult>> call(String claimId) {
    return _repository.getDamageStatistics(claimId);
  }
}
