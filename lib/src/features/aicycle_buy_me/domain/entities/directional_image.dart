class DirectionalImage {
  final int? imageId;
  final String? imageUrl;

  DirectionalImage({this.imageId, this.imageUrl});

  DirectionalImage copyWith({int? imageId, String? imageUrl}) {
    return DirectionalImage(
      imageId: imageId ?? this.imageId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! DirectionalImage) return false;

    if (imageId != null && other.imageId != null) {
      return imageId == other.imageId;
    }

    return imageId == other.imageId && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => imageId?.hashCode ?? imageUrl.hashCode;
}
