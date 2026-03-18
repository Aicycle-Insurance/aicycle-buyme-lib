import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import '../../../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.deleteButtonLabel = AppStrings.btnDelete,
    this.cancelButtonLabel = AppStrings.btnCancel,
    this.onDeleteTapped,
    this.onCancelTapped,
  });

  final String title;
  final String message;
  final String deleteButtonLabel;
  final String cancelButtonLabel;
  final VoidCallback? onDeleteTapped;
  final VoidCallback? onCancelTapped;

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String deleteButtonLabel = AppStrings.btnDelete,
    String cancelButtonLabel = AppStrings.btnCancel,
    VoidCallback? onDeleteTapped,
    VoidCallback? onCancelTapped,
  }) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        title: title,
        message: message,
        deleteButtonLabel: deleteButtonLabel,
        cancelButtonLabel: cancelButtonLabel,
        onDeleteTapped: onDeleteTapped,
        onCancelTapped: onCancelTapped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: AppColors.surface,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Icon Trash
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundError,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      Assets.images.icTrash01.path,
                      package: AppStrings.package,
                      height: 24.r,
                      width: 24.r,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Title
                Text(
                  title,
                  style: AppTextStyles.heading2.copyWith(fontSize: 16.sp),
                ),
                const SizedBox(height: 2),

                /// Message
                Text(
                  message,
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.ink2,
                  ),
                ),
                const SizedBox(height: 24),

                /// Buttons List
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onDeleteTapped?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        deleteButtonLabel,
                        style: AppTextStyles.button,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onCancelTapped?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.borderGray),
                        minimumSize: Size(double.infinity, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: Text(
                        cancelButtonLabel,
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Close Button
          Positioned(
            right: 12.w,
            top: 12.h,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close_rounded,
                color: AppColors.textDisabled,
                size: 24.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
