import 'dart:io';

import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:aicycle_buyme_plus/src/features/guide_line/presentation/guide_line_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/widgets/dashed_container.dart';
import '../../../camera/presentation/pages/camera_page.dart';
import '../../../car_capture/presentation/pages/car_capture_page.dart';

import '../controllers/buy_me_controller.dart';

/// A section in the [BuyMePage] representing a specific document or exterior photo requirement.
/// Handles navigating to the appropriate capture flow (Camera or Guide).
class CarCaptureSection extends StatelessWidget {
  const CarCaptureSection({
    super.key,
    required this.type,
    required this.images,
    this.onAddTapped,
    this.onImageCaptured,
    this.onImageAdded,
    this.onImageDeleted,
    this.imagesMap = const {},
    this.errorMessage,
  });
  final CarCaptureSectionType type;
  final List<String> images;
  final Map<AicycleCarAngle, List<String>> imagesMap;
  final Function()? onAddTapped;
  final Function(XFile file, int index)? onImageCaptured;
  final Function(AicycleCarAngle angle, String path)? onImageAdded;
  final Function(AicycleCarAngle angle, String path)? onImageDeleted;
  final String? errorMessage;

  String get title {
    switch (type) {
      case CarCaptureSectionType.regCert:
        return AppStrings.photoRegCert;
      case CarCaptureSectionType.regStamp:
        return AppStrings.photoRegStamp;
      case CarCaptureSectionType.vinNumber:
        return AppStrings.photoVinNumber;
      case CarCaptureSectionType.taplo:
        return AppStrings.photoTaplo;
      case CarCaptureSectionType.exterior:
        return AppStrings.photoExterior;
    }
  }

  int get numberImageContainer {
    if (type == CarCaptureSectionType.regCert) {
      return 2;
    }
    return 1;
  }

  AicycleCarAngle getAngle() {
    switch (type) {
      case CarCaptureSectionType.regCert:
        return AicycleCarAngle.regCert;
      case CarCaptureSectionType.regStamp:
        return AicycleCarAngle.regStamp;
      case CarCaptureSectionType.vinNumber:
        return AicycleCarAngle.vinNumber;
      case CarCaptureSectionType.taplo:
        return AicycleCarAngle.taplo;
      case CarCaptureSectionType.exterior:
        return AicycleCarAngle.front;
    }
  }

  void onGuideTapped(BuildContext context) {
    GuideType guideType = GuideType.vinNumber;
    switch (type) {
      case CarCaptureSectionType.regCert:
        guideType = GuideType.regCert;
        break;
      case CarCaptureSectionType.regStamp:
        guideType = GuideType.regStamp;
        break;
      case CarCaptureSectionType.vinNumber:
        guideType = GuideType.vinNumber;
        break;
      case CarCaptureSectionType.taplo:
        guideType = GuideType.taplo;
        break;
      case CarCaptureSectionType.exterior:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarCapturePage(
              onImageAdded: onImageAdded,
              onImageDeleted: onImageDeleted,
              imagesMap: imagesMap,
            ),
          ),
        );
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuideLinePage(guideType: guideType),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, {int index = 0}) {
    final hasImage = images.length > index && images[index].isNotEmpty;
    return InkWell(
      onTap: () async {
        if (type == CarCaptureSectionType.exterior) {
          onGuideTapped(context);
        } else {
          final result = await Navigator.push<XFile?>(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CameraPage(args: CameraArgs(vehicleAngle: getAngle())),
            ),
          );
          if (result != null) {
            onImageCaptured?.call(result, index);
          }
        }
        onAddTapped?.call();
      },
      child: Builder(
        builder: (context) {
          final imagePath = images[index];
          final isNetworkImage = imagePath.startsWith('http');

          if (hasImage) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                height: 90.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    isNetworkImage
                        ? CachedNetworkImage(
                            imageUrl: imagePath,
                            fit: BoxFit.cover,
                            height: 90.h,
                            width: double.infinity,
                          )
                        : Image.file(
                            File(images[index]),
                            fit: BoxFit.cover,
                            height: 90.h,
                            width: double.infinity,
                          ),
                    if (images.length > 1)
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            '+${images.length}',
                            style: AppTextStyles.body12Medium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          return DashedContainer(
            height: 90.h,
            backgroundColor: AppColors.backgroundGray,
            borderRadius: 8.r,
            color: AppColors.borderGray,
            dashPattern: hasImage ? [] : const [8, 8],
            child: Center(
              child: Icon(
                Icons.add_rounded,
                size: 20.r,
                color: AppColors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 170.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorMessage != null
                  ? AppColors.error
                  : AppColors.borderGray,
            ),
          ),
          padding: EdgeInsets.all(8.h).copyWith(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body12Medium),
              SizedBox(height: 8.h),
              numberImageContainer > 1
                  ? Row(
                      spacing: 8.w,
                      children: [
                        Expanded(
                          child: _buildImageContainer(context, index: 0),
                        ),
                        Expanded(
                          child: _buildImageContainer(context, index: 1),
                        ),
                      ],
                    )
                  : _buildImageContainer(context, index: images.length - 1),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  text: '${AppStrings.guide} ',
                  style: AppTextStyles.link,
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onGuideTapped(context),
                ),
              ),
            ],
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                height: 16.r,
                width: 16.r,
                child: Assets.images.icInfoCircle.image(
                  package: AppStrings.package,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  errorMessage!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body12Medium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
