class BuyMeFolderModel {
  final int? claimId;
  final bool? resultsAvailable;

  BuyMeFolderModel({this.claimId, this.resultsAvailable});

  factory BuyMeFolderModel.fromJson(Map<String, dynamic> json) {
    return BuyMeFolderModel(
      claimId: int.tryParse(json['claimId']?.toString() ?? ''),
      resultsAvailable: json['resultsAvailable']?.toString().contains('true'),
    );
  }

  /// Parses a response that might be a List or a Map, or wrapped in a 'data' field.
  factory BuyMeFolderModel.fromDynamic(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final innerData = data['data'];
      if (innerData is List && innerData.isNotEmpty) {
        return BuyMeFolderModel.fromJson(innerData[0] as Map<String, dynamic>);
      }
      return BuyMeFolderModel.fromJson(innerData as Map<String, dynamic>);
    }

    if (data is List && data.isNotEmpty) {
      return BuyMeFolderModel.fromJson(data[0] as Map<String, dynamic>);
    } else if (data is Map<String, dynamic>) {
      return BuyMeFolderModel.fromJson(data);
    }
    return BuyMeFolderModel();
  }
}
