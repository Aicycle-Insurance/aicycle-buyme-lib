import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../domain/entities/segment_result.dart';

class ImageInfoBottomsheet extends StatelessWidget {
  const ImageInfoBottomsheet({super.key, required this.image});

  final ImageEntity image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      height: MediaQuery.sizeOf(context).height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Handle bar
          Center(
            child: Container(
              width: 38.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          /// Title
          Text(AppStrings.imageInfo, style: AppTextStyles.bodySemibold),
          SizedBox(height: 20.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// File path
                  _SectionLabel(AppStrings.imageFilePath),
                  SizedBox(height: 6.h),
                  _FilePathRow(filePath: image.imageUrl),
                  SizedBox(height: 32.h),

                  /// Uploading time
                  _InfoRow(
                    label: AppStrings.imageUploadingTime,
                    value: image.uploadingTime != null
                        ? '${image.uploadingTime!.toStringAsFixed(2)} s'
                        : null,
                  ),
                  SizedBox(height: 8.h),

                  /// Processing time
                  _InfoRow(
                    label: AppStrings.imageProcessingTime,
                    value: image.processingTime != null
                        ? '${image.processingTime!.toStringAsFixed(2)} s'
                        : null,
                  ),
                  SizedBox(height: 32.h),

                  /// Captured date
                  _InfoRow(
                    label: AppStrings.imageCapturedDate,
                    value: _formatDate(image.capturedDate),
                  ),
                  SizedBox(height: 8.h),

                  /// Captured location
                  _InfoRow(
                    label: AppStrings.imageCapturedLocation,
                    value: image.capturedLocation,
                  ),
                  SizedBox(height: 32.h),

                  /// Uploaded date
                  _InfoRow(
                    label: AppStrings.imageUploadedDate,
                    value: _formatDate(image.uploadedDate),
                  ),
                  SizedBox(height: 8.h),

                  /// Uploaded location
                  _InfoRow(
                    label: AppStrings.imageUploadedLocation,
                    value: image.uploadedLocation,
                  ),
                  SizedBox(height: 32.h),

                  /// Trace ID
                  _InfoRow(
                    label: AppStrings.traceId,
                    value: image.traceId,
                    showCopy: true,
                  ),
                  SizedBox(height: 8.h),

                  /// Claim ID
                  _InfoRow(
                    label: AppStrings.folderId,
                    value: image.aicycleFolderId,
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final y = date.year.toString().padLeft(4, '0');
    final mo = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final mi = date.minute.toString().padLeft(2, '0');
    final s = date.second.toString().padLeft(2, '0');
    return '$d/$mo/$y $h:$mi:$s';
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.bodyMedium);
  }
}

class _InfoRow extends StatefulWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.showCopy = false,
  });

  final String label;
  final String? value;
  final bool showCopy;

  @override
  State<_InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<_InfoRow> {
  IconData _icon = Icons.copy_rounded;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${widget.label} ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          TextSpan(
            text: widget.value?.isNotEmpty == true ? '${widget.value} ' : 'N/A',
            style: AppTextStyles.bodyMedium.copyWith(
              color: widget.value?.isNotEmpty == true
                  ? AppColors.primary
                  : AppColors.textDisabled,
            ),
          ),
          if (widget.showCopy && widget.value?.isNotEmpty == true)
            WidgetSpan(
              child: GestureDetector(
                onTap: () => _copy(context),
                child: Icon(_icon, color: AppColors.primary, size: 16.h),
              ),
            ),
        ],
      ),
    );
  }

  void _copy(BuildContext context) {
    if (widget.value == null || widget.value!.isEmpty) return;
    Clipboard.setData(ClipboardData(text: widget.value!));
    setState(() {
      _icon = Icons.check_rounded;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _icon = Icons.copy_rounded;
      });
    });
  }
}

class _FilePathRow extends StatefulWidget {
  const _FilePathRow({this.filePath});
  final String? filePath;

  @override
  State<_FilePathRow> createState() => _FilePathRowState();
}

class _FilePathRowState extends State<_FilePathRow> {
  IconData _icon = Icons.copy_rounded;
  void _copy(BuildContext context) {
    if (widget.filePath == null || widget.filePath!.isEmpty) return;
    Clipboard.setData(ClipboardData(text: widget.filePath!));
    setState(() {
      _icon = Icons.check_rounded;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _icon = Icons.copy_rounded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.filePath?.isNotEmpty == true;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(6.r)),
            ),
            child: Text(
              hasValue ? widget.filePath! : 'N/A',
              style: AppTextStyles.body12Regular.copyWith(
                color: hasValue
                    ? AppColors.textPrimary
                    : AppColors.textDisabled,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (hasValue)
          GestureDetector(
            onTap: () => _copy(context),
            child: Container(
              height: 48.h,
              padding: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(6.r),
                ),
              ),
              child: Center(
                child: Icon(_icon, color: Colors.white, size: 16.h),
              ),
            ),
          ),
      ],
    );
  }
}
