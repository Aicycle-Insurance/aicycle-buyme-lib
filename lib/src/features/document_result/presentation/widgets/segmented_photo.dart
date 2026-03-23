import 'package:aicycle_buyme_plus/src/core/extension/color_ext.dart';
import 'package:aicycle_buyme_plus/src/features/document_result/domain/entities/segment_result.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const double maskOpacity = 0.4;

/// Widget to display a photo with overlapping damage masks.
/// It uses [InteractiveViewer] to allow zooming and panning.
class SegmentedPhoto extends StatelessWidget {
  /// Creates a [SegmentedPhoto] widget.
  /// [imageEntity] contains the image URL and the list of associated damage masks.
  /// [size] defines the initial display dimensions of the photo container.
  const SegmentedPhoto({
    super.key,
    required this.imageEntity,
    this.size = const Size(double.maxFinite, 220),
  });

  final ImageEntity imageEntity;
  final Size size;

  /// Generates a list of [Positioned] widgets representing damage masks.
  /// Each mask is positioned according to its bounding box ([boxes]) and
  /// scaled to fit the given [imageSize].
  List<Widget> _masks(Size imageSize) {
    final cacheMasks = <String>[];
    final maskWidgets = <Widget>[];

    for (final DamageEntity damage in imageEntity.damagesInImage ?? []) {
      final String? maskUrl = damage.maskUrl;
      if (maskUrl == null || maskUrl.isEmpty) continue;

      if (!cacheMasks.contains(maskUrl)) {
        cacheMasks.add(maskUrl);
        final boxes = damage.boxes;
        if (boxes == null || boxes.length < 4) continue;

        maskWidgets.add(
          Positioned(
            left: (boxes[0]) * imageSize.width,
            top: (boxes[1]) * imageSize.height,
            width: (boxes[2] - boxes[0]) * imageSize.width,
            height: (boxes[3] - boxes[1]) * imageSize.height,
            child: CachedNetworkImage(
              imageUrl: maskUrl,
              fit: BoxFit.fill,
              colorBlendMode: BlendMode.srcIn,
              color: (damage.damageTypeColor ?? '').color.withValues(
                alpha: maskOpacity,
              ),
              placeholder: (context, url) => const SizedBox.shrink(),
              errorWidget: (context, url, error) => Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (damage.damageTypeColor ?? '').color,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return maskWidgets;
  }

  /// Calculates the optimized image size based on container constraints
  /// and the original image resolution, maintaining the aspect ratio.
  Size _calculateImageSize(BoxConstraints constraints, Size imageSize) {
    if (imageSize.width <= 0 || imageSize.height <= 0) return Size.zero;
    final double imageRatio = imageSize.width / imageSize.height;
    final double containerRatio = constraints.maxWidth / constraints.maxHeight;

    if (containerRatio > imageRatio) {
      return Size(constraints.maxHeight * imageRatio, constraints.maxHeight);
    } else {
      return Size(constraints.maxWidth, constraints.maxWidth / imageRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: size.height,
      width: size.width,
      child: InteractiveViewer(
        maxScale: 3.0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageSize = _calculateImageSize(
              constraints,
              Size(
                imageEntity.resolution?[0].toDouble() ?? 1600,
                imageEntity.resolution?[1].toDouble() ?? 1200,
              ),
            );
            return Center(
              child: SizedBox.fromSize(
                size: imageSize,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: AlignmentGeometry.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageEntity.filePath ?? '',
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                    ),
                    ..._masks(imageSize),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
