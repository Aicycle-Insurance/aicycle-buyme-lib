import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
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
  }) {
    showDialog(
      context: context,
      builder: (context) => ValidationDialog(
        title: title,
        message: message,
        primaryButtonLabel: primaryButtonLabel,
        secondaryButtonLabel: secondaryButtonLabel,
        onPrimaryTapped: onPrimaryTapped,
        onSecondaryTapped: onSecondaryTapped,
      ),
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
  });

  final String title;
  final String message;
  final String primaryButtonLabel;
  final String? secondaryButtonLabel;
  final VoidCallback? onPrimaryTapped;
  final VoidCallback? onSecondaryTapped;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.surface,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Icon
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: AppColors.backgroundError,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: AppColors.error,
                size: 20.r,
              ),
            ),
            const SizedBox(height: 16),

            /// Title
            Text(title, style: AppTextStyles.headingSemiBold),
            const SizedBox(height: 8),

            /// Message
            Text(message, style: AppTextStyles.bodyRegular),
            const SizedBox(height: 24),

            /// Buttons
            Row(
              children: [
                if (secondaryButtonLabel != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          onSecondaryTapped ?? () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.borderGray),
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
                    onPressed: onPrimaryTapped ?? () => Navigator.pop(context),
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
                      style: AppTextStyles.button.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
