class DirectionalImageModel {
  final int? imageId;
  final String? imageUrl;

  DirectionalImageModel({this.imageId, this.imageUrl});

  factory DirectionalImageModel.fromJson(Map<String, dynamic> json) {
    return DirectionalImageModel(
      imageId: json['imageId'] as int?,
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'imageId': imageId, 'imageUrl': imageUrl};
  }
}

class DirectionalImagesResponse {
  final List<DirectionalImageModel>? directionalImages;

  DirectionalImagesResponse({this.directionalImages});

  /// Convenience getter — trả về list rỗng nếu null.
  List<DirectionalImageModel> get images => directionalImages ?? [];

  factory DirectionalImagesResponse.fromJson(Map<String, dynamic> json) {
    return DirectionalImagesResponse(
      directionalImages: (json['directionalImages'] as List?)
          ?.map(
            (e) => DirectionalImageModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'directionalImages': directionalImages?.map((e) => e.toJson()).toList(),
    };
  }
}
