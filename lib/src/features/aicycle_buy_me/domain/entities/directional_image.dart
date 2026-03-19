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
}
