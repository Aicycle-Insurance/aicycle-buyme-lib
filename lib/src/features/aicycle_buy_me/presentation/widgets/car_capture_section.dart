import 'package:aicycle_buyme_plus/src/core/di/injection.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:aicycle_buyme_plus/src/features/guide_line/presentation/guide_line_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/widgets/dashed_container.dart';
import '../../../camera/presentation/pages/camera_page.dart';
import '../../../car_capture/presentation/pages/car_capture_page.dart';

import '../../../images_list/presentation/image_list_page.dart';
import '../../domain/entities/directional_image.dart';
import '../controllers/validation_vault.dart';

/// A section in the [BuyMePage] representing a specific document or exterior photo requirement.
/// Handles navigating to the appropriate capture flow (Camera or Guide).
class CarCaptureSection extends StatelessWidget {
  const CarCaptureSection({
    super.key,
    required this.angle,
    this.errorMessage,
    this.validationType = ValidationType.initial,
  });
  final AicycleCarAngle angle;
  final String? errorMessage;
  final ValidationType validationType;

  String get title {
    final config = AiCycleBuyMe.config;
    final displayName =
        config.displayConfig.carAnglesWithDisplayName[angle] ??
        AppStrings.noDisplayName;
    return '${AppStrings.photo} ${displayName.toLowerCase()}';
  }

  int get numberImageContainer {
    if (angle == AicycleCarAngle.regCert) {
      return 2;
    }
    return 1;
  }

  void onGuideTapped(BuildContext context) {
    if (angle == AicycleCarAngle.exterior) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CarCapturePage()),
      );
      return;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GuideLinePage(vehicleAngle: angle),
        ),
      );
    }
  }

  Widget _buildImageContainer(
    BuildContext context, {
    bool showCount = true,
    bool disableTap = false,
    int index = 0,
    required List<DirectionalImage> images,
  }) {
    final hasImage = images.length > index && images[index].imageUrl != null;
    return InkWell(
      onTap: () {
        if (disableTap) return;
        if (images.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraPage(
                args: CameraArgs(vehicleAngle: angle, isFramedPhoto: false),
              ),
            ),
          );
        } else {
          Navigator.push<XFile?>(
            context,
            MaterialPageRoute(
              builder: (context) => ImageListPage(vehicleAngle: angle),
            ),
          );
        }
      },
      child: Builder(
        builder: (context) {
          if (hasImage) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                height: 90.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: images[index].imageUrl!,
                      fit: BoxFit.cover,
                      height: 90.h,
                      width: double.infinity,
                    ),
                    if (showCount && images.length > 1)
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
    return ListenableBuilder(
      listenable: sl.vehicleImageVault,
      builder: (context, _) {
        final images = sl.vehicleImageVault.getImagesForAngle(angle);
        final color = validationType == ValidationType.success
            ? AppColors.success
            : AppColors.error;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170.h,
              // padding = 16.h * 3 = 48.h
              width: (MediaQuery.of(context).size.width - 48.h) / 2,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: errorMessage != null ? color : AppColors.borderGray,
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
                              child: _buildImageContainer(
                                context,
                                index: 0,
                                showCount: false,
                                disableTap:
                                    images.length >= numberImageContainer,
                                images: images,
                              ),
                            ),
                            Expanded(
                              child: _buildImageContainer(
                                context,
                                index: 1,
                                images: images,
                              ),
                            ),
                          ],
                        )
                      : _buildImageContainer(
                          context,
                          index: images.isEmpty ? 0 : images.length - 1,
                          images: images,
                        ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => onGuideTapped(context),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${AppStrings.guide} ',
                              style: AppTextStyles.link,
                            ),
                            WidgetSpan(
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14.r,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    validationType == ValidationType.success
                        ? Icons.check_circle_outline_rounded
                        : Icons.error_outline_rounded,
                    size: 16.r,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body12Medium.copyWith(color: color),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
