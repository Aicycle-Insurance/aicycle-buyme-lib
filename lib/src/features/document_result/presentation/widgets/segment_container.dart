import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/extension/color_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../domain/entities/segment_result.dart';
import 'segmented_photo.dart';

class SegmentContainer extends StatefulWidget {
  const SegmentContainer({super.key, required this.segmentResult});
  final SegmentResult segmentResult;

  @override
  State<SegmentContainer> createState() => _SegmentContainerState();
}

class _SegmentContainerState extends State<SegmentContainer> {
  int selectedIndex = 0;
  final Map<int, bool> _maskVisibility = {};

  String getPercentage(DamageEntity damageResult) {
    final double percent = (damageResult.damagePercentage ?? 0) * 100;
    if (percent == percent.floor()) {
      return '${percent.toInt()}%';
    }
    return '${percent.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  AppStrings.part,
                  style: AppTextStyles.body12Regular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  widget.segmentResult.vehiclePartName ?? 'N/A',
                  style: AppTextStyles.body12Light,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  AppStrings.damageType,
                  style: AppTextStyles.body12Regular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: (() {
                    final seen = <String>{};
                    return (widget.segmentResult.damages ?? [])
                        .where((e) => seen.add(e.damageTypeName ?? 'N/A'))
                        .map(
                          (e) => Row(
                            children: [
                              Text(
                                e.damageTypeName ?? 'N/A',
                                style: AppTextStyles.body12Light,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 8.h),
                              Container(
                                height: 6.r,
                                width: 6.r,
                                decoration: BoxDecoration(
                                  color: e.damageTypeColor?.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList();
                  }()),
                ),
              ),
            ],
          ),
        ),
        if (widget.segmentResult.images?.isNotEmpty ?? false) ...[
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Stack(
              children: [
                SegmentedPhoto(
                  imageEntity: widget.segmentResult.images![selectedIndex],
                  maskType: AiCycleBuyMe.config.displayConfig.maskType,
                  showMask: _maskVisibility[selectedIndex] ?? true,
                  onToggleMask: () {
                    setState(() {
                      _maskVisibility[selectedIndex] =
                          !(_maskVisibility[selectedIndex] ?? true);
                    });
                  },
                ),
                Positioned(
                  bottom: 8.h,
                  right: 8.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${selectedIndex + 1}/${widget.segmentResult.images?.length}',
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xFFE8EAF3),
            height: 68.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.segmentResult.images?.length ?? 0,
              padding: EdgeInsets.all(16.r),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    width: 54.h,
                    margin: EdgeInsets.only(right: 16.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedIndex == index
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2.r,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: CachedNetworkImage(
                        imageUrl:
                            widget.segmentResult.images![index].filePath ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ],
    );
  }
}
