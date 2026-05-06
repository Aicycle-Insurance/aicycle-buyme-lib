import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../config/aicycle_config.dart';
import '../../../../core/extension/color_ext.dart';
import '../../../../core/extension/damage_ext.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../domain/entities/segment_result.dart';

const double maskOpacity = 0.4;

/// Widget to display a photo with overlapping damage masks.
/// It uses [InteractiveViewer] to allow zooming and panning.
class SegmentedPhoto extends StatefulWidget {
  /// Creates a [SegmentedPhoto] widget.
  /// [imageEntity] contains the image URL and the list of associated damage masks.
  /// [size] defines the initial display dimensions of the photo container.
  /// [maskType] defines the type of mask to display.
  const SegmentedPhoto({
    super.key,
    required this.imageEntity,
    this.size = const Size(double.maxFinite, 220),
    required this.maskType,
    this.showMask = true,
    this.onToggleMask,
  });

  final ImageEntity imageEntity;
  final Size size;
  final MaskType maskType;
  final bool showMask;
  final VoidCallback? onToggleMask;

  @override
  State<SegmentedPhoto> createState() => _SegmentedPhotoState();
}

class _SegmentedPhotoState extends State<SegmentedPhoto> {
  Offset _buttonOffset = Offset(8.h, 8.h);
  final double _buttonSize = 40.h;

  /// Generates a list of [Positioned] widgets representing damage masks.
  /// Each mask is positioned according to its bounding box ([boxes]) and
  /// scaled to fit the given [imageSize].
  List<Widget> _masks(Size imageSize) {
    final cacheMasks = <String>[];
    final maskWidgets = <Widget>[];

    for (final DamageEntity damage in widget.imageEntity.damagesInImage ?? []) {
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
            child: switch (widget.maskType) {
              MaskType.boundingBox => _boundingBoxMask(damage),
              _ => _segmentationMask(maskUrl, damage.damageTypeColor),
            },
          ),
        );
      }
    }
    return maskWidgets;
  }

  Widget _boundingBoxMask(DamageEntity damage) {
    final color = (damage.damageTypeColor ?? '').color;
    final textColor = color.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    final boxes = damage.boxes ?? [];
    final bool isCloseToTop = boxes.length >= 4 ? boxes[1] < 0.1 : false;
    final bool isCloseToRight = boxes.length >= 4 ? boxes[0] > 0.7 : false;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 0.5),
          ),
        ),
        Positioned(
          left: isCloseToRight ? null : 0,
          right: isCloseToRight ? 0 : null,
          top: isCloseToTop ? null : 0,
          bottom: isCloseToTop ? 0 : null,
          child: FractionalTranslation(
            translation: Offset(0, isCloseToTop ? 1 : -1),
            child: Container(
              color: color,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                damage.getDisplayShortName(),
                style: AppTextStyles.body6Regular.copyWith(color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _segmentationMask(String maskUrl, String? damageTypeColor) {
    return CachedNetworkImage(
      imageUrl: maskUrl,
      fit: BoxFit.fill,
      colorBlendMode: BlendMode.srcIn,
      color: (damageTypeColor ?? '').color.withValues(alpha: maskOpacity),
      placeholder: (context, url) => const SizedBox.shrink(),
      errorWidget: (context, url, error) => Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: (damageTypeColor ?? '').color),
        ),
      ),
    );
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
      height: widget.size.height,
      width: widget.size.width,
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 3.0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final imageSize = _calculateImageSize(
                    constraints,
                    Size(
                      widget.imageEntity.resolution?[0].toDouble() ?? 1600,
                      widget.imageEntity.resolution?[1].toDouble() ?? 1200,
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
                            imageUrl: widget.imageEntity.filePath ?? '',
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                const SizedBox.shrink(),
                            errorWidget: (context, url, error) =>
                                const SizedBox.shrink(),
                          ),
                          if (widget.showMask) ..._masks(imageSize),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: _buttonOffset.dx,
            top: _buttonOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final parentBox = context.findRenderObject() as RenderBox?;
                  if (parentBox == null) return;
                  final parentSize = parentBox.size;
                  // right-based: moving right means decreasing dx
                  final newDx = (_buttonOffset.dx - details.delta.dx).clamp(
                    0.0,
                    parentSize.width - _buttonSize,
                  );
                  final newDy = (_buttonOffset.dy + details.delta.dy).clamp(
                    0.0,
                    parentSize.height - _buttonSize,
                  );
                  _buttonOffset = Offset(newDx, newDy);
                });
              },
              child: Container(
                width: _buttonSize,
                height: _buttonSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    widget.showMask ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: widget.onToggleMask,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
