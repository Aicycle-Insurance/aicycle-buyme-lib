import '../features/document_result/domain/entities/segment_result.dart';

class ParseOutput {
  static Map<String, dynamic> parseDamageStatistics(
    List<SegmentResult> damageStatistics,
  ) {
    final Map<String, dynamic> result = {};
    final List<Map<String, dynamic>?> listFullJson = [];
    for (SegmentResult item in damageStatistics) {
      listFullJson.add(item.fullJsonData);
    }
    result['damageStatistics'] = listFullJson;
    return result;
  }
}
