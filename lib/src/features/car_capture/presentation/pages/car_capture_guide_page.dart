import 'dart:io';

import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:aicycle_buyme_plus/src/core/widgets/app_checkbox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/delete_confirm_dialog.dart';
import '../controllers/car_capture_controller.dart';
import '../widgets/guide_page_bottom_bar.dart';

class CarCaptureGuidePage extends StatefulWidget {
  const CarCaptureGuidePage({
    super.key,
    required this.controller,
    required this.corner,
    this.images = const [],
    this.onImageAdded,
    this.onImageDeleted,
  });

  final CarCaptureController controller;
  final AicycleCarAngle corner;
  final List<String> images;
  final Function(AicycleCarAngle, String)? onImageAdded;
  final Function(AicycleCarAngle, String)? onImageDeleted;

  @override
  State<CarCaptureGuidePage> createState() => _CarCaptureGuidePageState();
}

class _CarCaptureGuidePageState extends State<CarCaptureGuidePage> {
  late final CarCaptureController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
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

  Widget _buildCapturedImages(String url) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => controller.toggleImageSelection(url),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                children: [
                  if (url.startsWith('http'))
                    CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  else
                    Image.file(
                      File(url),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: AppCheckbox(
                      size: 16.h,
                      value: controller.isSelected(url),
                      onChanged: (value) =>
                          controller.toggleImageSelection(url),
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
      title: AppStrings.deleteImageTitle(controller.selectedImages.length),
      message: AppStrings.deleteImageMessage,
      onDeleteTapped: controller.deleteSelectedImages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            actions: [
              Visibility(
                visible: controller.showDeleteButton,
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
                    Text(controller.title, style: AppTextStyles.heading2),
                    Text(
                      controller.description,
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
                      if (controller.images.isEmpty) ...[
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
                          crossAxisCount: controller.images.isEmpty
                              ? (controller.sampleImages.length > 1 ? 2 : 1)
                              : (controller.images.length > 1 ? 2 : 1),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: controller.images.isEmpty
                              ? (controller.sampleImages.length > 1
                                    ? 176 / 160
                                    : 361 / 244)
                              : (controller.images.length > 1
                                    ? 176 / 160
                                    : 361 / 244),
                        ),
                        itemCount: controller.images.isEmpty
                            ? controller.sampleImages.length
                            : controller.images.length,
                        itemBuilder: (context, index) {
                          return controller.images.isEmpty
                              ? _buildSampleImage(
                                  controller.sampleImages[index],
                                )
                              : _buildCapturedImages(controller.images[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: GuidePageBottomBar(controller: controller),
        );
      },
    );
  }
}
