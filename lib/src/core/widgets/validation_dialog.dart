import 'package:aicycle_buyme_plus/gen/assets.gen.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_strings.dart';
import '../theme/app_text_styles.dart';

class CommonValidationDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryButtonLabel,
    String? secondaryButtonLabel,
    VoidCallback? onPrimaryTapped,
    VoidCallback? onSecondaryTapped,
    int quarterTurns = 0,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isLandscape = quarterTurns == 1 || quarterTurns == 3;
        return RotatedBox(
          quarterTurns: quarterTurns,
          child: ValidationDialog(
            title: title,
            message: message,
            primaryButtonLabel: primaryButtonLabel,
            secondaryButtonLabel: secondaryButtonLabel,
            onPrimaryTapped: onPrimaryTapped,
            onSecondaryTapped: onSecondaryTapped,
            width: isLandscape ? 360.w : null,
          ),
        );
      },
    );
  }
}

class ValidationDialog extends StatelessWidget {
  const ValidationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryButtonLabel,
    this.secondaryButtonLabel,
    this.onPrimaryTapped,
    this.onSecondaryTapped,
    this.width,
  });

  final String title;
  final String message;
  final String primaryButtonLabel;
  final String? secondaryButtonLabel;
  final VoidCallback? onPrimaryTapped;
  final VoidCallback? onSecondaryTapped;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.surface,
      elevation: 0,
      insetPadding: width != null
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      child: Container(
        width: width,
        padding: EdgeInsets.all(8.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Icon
            Assets.images.icErrorOutline.image(
              width: 48.r,
              height: 48.r,
              package: AppStrings.package,
            ),
            SizedBox(height: 8.h),

            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    title,
                    style: AppTextStyles.headingSemiBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  /// Message
                  Text(
                    message,
                    style: AppTextStyles.bodyRegular,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),

                  /// Buttons
                  Row(
                    children: [
                      if (secondaryButtonLabel != null) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                onSecondaryTapped ??
                                () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(
                                color: AppColors.borderGray,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              secondaryButtonLabel!,
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              onPrimaryTapped ?? () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            primaryButtonLabel,
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
