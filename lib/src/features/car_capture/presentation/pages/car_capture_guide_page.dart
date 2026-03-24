import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/src/core/di/injection.dart';
import 'package:aicycle_buyme_plus/src/core/extension/car_angle_ext.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:aicycle_buyme_plus/src/core/widgets/app_checkbox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/delete_confirm_dialog.dart';
import '../../../aicycle_buy_me/domain/entities/directional_image.dart';
import '../widgets/guide_page_bottom_bar.dart';

class CarCaptureGuidePage extends StatefulWidget {
  const CarCaptureGuidePage({super.key, required this.angle});
  final AicycleCarAngle angle;

  @override
  State<CarCaptureGuidePage> createState() => _CarCaptureGuidePageState();
}

class _CarCaptureGuidePageState extends State<CarCaptureGuidePage> {
  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl.vehicleImageVault.clearSelection();
    });
    super.dispose();
  }

  Widget _buildSampleImage(String imagePath) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Image.asset(
        imagePath,
        package: AppStrings.package,
        fit: BoxFit.contain,
      ),
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

  void _showDeleteConfirmationDialog() {
    DeleteConfirmDialog.show(
      context: context,
      title: AppStrings.deleteImageTitle(
        sl.vehicleImageVault.selectedImageIds.length,
      ),
      message: AppStrings.deleteImageMessage,
      onDeleteTapped: () =>
          sl.vehicleImageVault.deleteSelectedImages(widget.angle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sl.vehicleImageVault,
      builder: (context, child) {
        final images = sl.vehicleImageVault.getImagesForAngle(widget.angle);
        final showDeleteButton =
            sl.vehicleImageVault.selectedImageIds.isNotEmpty;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
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
                  onPressed: _showDeleteConfirmationDialog,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.angle.title, style: AppTextStyles.heading2),
                    Text(
                      widget.angle.description,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
              // if (controller.images.isEmpty)
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (images.isEmpty) ...[
                        Text(
                          AppStrings.samplePhoto,
                          style: AppTextStyles.body12Medium,
                        ),
                        const SizedBox(height: 8),
                      ],
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: images.isEmpty
                              ? (widget.angle.sampleImages.length > 1 ? 2 : 1)
                              : (images.length > 1 ? 2 : 1),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: images.isEmpty
                              ? (widget.angle.sampleImages.length > 1
                                    ? 176 / 160
                                    : 361 / 244)
                              : (images.length > 1 ? 176 / 160 : 361 / 244),
                        ),
                        itemCount: images.isEmpty
                            ? widget.angle.sampleImages.length
                            : images.length,
                        itemBuilder: (context, index) {
                          return images.isEmpty
                              ? _buildSampleImage(
                                  widget.angle.sampleImages[index],
                                )
                              : _buildCapturedImages(images[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: GuidePageBottomBar(angle: widget.angle),
        );
      },
    );
  }
}
