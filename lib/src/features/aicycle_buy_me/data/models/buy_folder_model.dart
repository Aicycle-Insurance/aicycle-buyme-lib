class BuyFolderModel {
  final String? id;
  final String? buyFolderId;
  final String? claimId;

  BuyFolderModel({
    this.id,
    this.buyFolderId,
    this.claimId,
  });

  factory BuyFolderModel.fromJson(Map<String, dynamic> json) {
    return BuyFolderModel(
      id: json['id']?.toString(),
      buyFolderId: json['buyFolderId']?.toString(),
      claimId: json['claimId']?.toString(),
    );
  }

  /// Parses a response that might be a List or a Map
  factory BuyFolderModel.fromDynamic(dynamic data) {
    if (data is List && data.isNotEmpty) {
      return BuyFolderModel.fromJson(data[0]);
    } else if (data is Map<String, dynamic>) {
      return BuyFolderModel.fromJson(data);
    }
    return BuyFolderModel();
  }
}
