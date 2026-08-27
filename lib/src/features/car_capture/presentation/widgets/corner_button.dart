import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extension/directional_image_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../controllers/car_capture_controller.dart';
import '../pages/car_capture_guide_page.dart';

/// An interactive hotspot representing a specific vehicle angle on the [CarCapturePage].
/// Displays a directional arrow if empty, or a thumbnail with a count if photos exist.
class CornerButton extends StatelessWidget {
  const CornerButton({super.key, required this.angle});
  final AicycleCarAngle angle;

  @override
  Widget build(BuildContext context) {
    final rotateAngle = CarCaptureController.getRotateAngle(angle);
    final images = sl.vehicleImageVault.getImagesForAngle(angle);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarCaptureGuidePage(angle: angle),
          ),
        );
      },
      child: images.isEmpty
          ? Transform.rotate(
              angle: rotateAngle,
              child: Assets.images.icArrowRight.image(
                package: AppStrings.package,
                height: 40.h,
                width: 40.h,
              ),
            )
          : Container(
              height: 40.h,
              width: 40.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: images.last.imageUrl ?? '',
                      cacheKey: images.last.cacheKey,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Center(
                      child: Container(
                        height: 24.h,
                        width: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            images.length.toString(),
                            style: AppTextStyles.body12Medium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
