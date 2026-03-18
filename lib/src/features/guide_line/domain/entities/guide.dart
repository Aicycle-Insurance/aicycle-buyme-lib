/// Represents a rich text segment
sealed class RichTextSegment {
  const RichTextSegment();
}

/// A standard paragraph of text
class TextParagraph extends RichTextSegment {
  final String text;

  const TextParagraph(this.text);
}

/// A list of bullet points, some of which may have bold prefixes
class BulletGroup extends RichTextSegment {
  final List<BulletPoint> bullets;

  const BulletGroup(this.bullets);
}

/// An individual bullet point
class BulletPoint {
  final String? prefix; // e.g., "Xe thông thường:"
  final String content; // e.g., " Cụm đồng hồ hiển thị..."
  final bool isPrefixBold;

  const BulletPoint({
    this.prefix,
    required this.content,
    this.isPrefixBold = true,
  });
}

/// The main Guide entity representing the guide screen content
class Guide {
  final List<RichTextSegment> position;
  final List<RichTextSegment> requirement;
  final List<String> samplePhotoUrls; // URL or local asset path
  final List<String> capturePhotoUrls; // URL or local asset path

  const Guide({
    required this.position,
    required this.requirement,
    required this.samplePhotoUrls,
    required this.capturePhotoUrls,
  });
}
