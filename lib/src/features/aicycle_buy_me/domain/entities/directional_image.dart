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

    return other is DirectionalImage &&
        other.imageId == imageId &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => Object.hash(imageId, imageUrl);
}
