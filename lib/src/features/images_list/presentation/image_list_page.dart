import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../aicycle_buyme_plus.dart';
import '../../../../gen/assets.gen.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/screen_utils.dart';
import '../../../core/widgets/app_checkbox.dart';
import '../../../core/widgets/delete_confirm_dialog.dart';
import '../../aicycle_buy_me/domain/entities/directional_image.dart';
import '../../camera/presentation/pages/camera_page.dart';

class ImageListPage extends StatelessWidget {
  const ImageListPage({super.key, required this.vehicleAngle});

  final AicycleCarAngle vehicleAngle;

  String get title {
    final displayName =
        AiCycleBuyMe
            .config
            .displayConfig
            .carAnglesWithDisplayName[vehicleAngle] ??
        AppStrings.noDisplayName;
    return '${AppStrings.photo} ${displayName.toLowerCase()}';
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    DeleteConfirmDialog.show(
      context: context,
      title: AppStrings.deleteImageTitle(
        sl.vehicleImageVault.selectedImageIds.length,
      ),
      message: AppStrings.deleteImageMessage,
      onDeleteTapped: () =>
          sl.vehicleImageVault.deleteSelectedImages(vehicleAngle),
    );
  }

  Widget _buildCapturedImages(DirectionalImage image) {
    return ListenableBuilder(
      listenable: sl.vehicleImageVault,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => sl.vehicleImageVault.toggleImageSelection(image.imageId),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: image.imageUrl ?? '',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: AppCheckbox(
                      size: 16.h,
                      value: sl.vehicleImageVault.isSelected(image.imageId),
                      onChanged: (value) => sl.vehicleImageVault
                          .toggleImageSelection(image.imageId),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sl.vehicleImageVault,
      builder: (context, child) {
        final images = sl.vehicleImageVault.getImagesForAngle(vehicleAngle);
        final showDeleteButton =
            sl.vehicleImageVault.selectedImageIds.isNotEmpty;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            title: Text(title, style: AppTextStyles.heading2),
            actions: [
              Visibility(
                visible: showDeleteButton,
                child: IconButton(
                  icon: Image.asset(
                    Assets.images.icTrash01.path,
                    package: AppStrings.package,
                    height: 20,
                    width: 20,
                  ),
                  onPressed: () => _showDeleteConfirmationDialog(context),
                ),
              ),
            ],
          ),
          body: images.isEmpty
              ? Center(
                  child: Text(
                    AppStrings.noImagesFound,
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.iconGray,
                    ),
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      ListenableBuilder(
                        listenable: sl.validationVault,
                        builder: (context, child) {
                          return Visibility(
                            visible:
                                sl.validationVault.errorMessage?.isNotEmpty ==
                                true,
                            child: Container(
                              margin: EdgeInsets.all(16.r).copyWith(bottom: 0),
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: AppColors.error),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Assets.images.icErrorOutline.image(
                                    package: AppStrings.package,
                                    height: 38.h,
                                    width: 38.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: Text(
                                      sl.validationVault.errorMessage ?? '',
                                      style: AppTextStyles.bodySemibold
                                          .copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: images.length > 1 ? 2 : 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: images.length > 1
                                    ? 176 / 160
                                    : 361 / 244,
                              ),
                          padding: EdgeInsets.all(16.r),
                          itemCount: images.length,
                          itemBuilder: (context, index) =>
                              _buildCapturedImages(images[index]),
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      sl.vehicleImageVault.clearSelection();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraPage(
                            args: CameraArgs(
                              vehicleAngle: vehicleAngle,
                              isFramedPhoto: false,
                            ),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: images.isEmpty
                          ? AppColors.primary
                          : AppColors.background,
                      foregroundColor: AppColors.textPrimary,
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: AppColors.borderGray),
                      minimumSize: Size(double.infinity, 40.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    icon: Image.asset(
                      Assets.images.icCameraPlus.path,
                      package: AppStrings.package,
                      color: images.isEmpty ? Colors.white : AppColors.iconGray,
                      height: 20.w,
                      width: 20.w,
                    ),
                    label: Text(
                      AppStrings.btnCaptureMore,
                      style: AppTextStyles.button.copyWith(
                        color: images.isEmpty
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (images.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    ElevatedButton(
                      onPressed: () {
                        sl.vehicleImageVault.clearSelection();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.btnDone,
                        style: AppTextStyles.button,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
