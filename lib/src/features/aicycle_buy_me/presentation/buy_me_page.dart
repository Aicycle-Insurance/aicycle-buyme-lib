import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import 'controllers/buy_me_controller.dart';
import 'widgets/car_capture_guide.dart';
import 'widgets/car_capture_section.dart';

class BuyMePage extends StatelessWidget {
  final BuyMeController controller;
  const BuyMePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        toolbarHeight: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refresh,
          color: AppColors.primary,
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return Column(
                children: [
                  /// Hướng dẫn chụp ảnh xe
                  const CarCaptureGuide(),
                  const SizedBox(height: 4),

                  /// Hình ảnh xe
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                        spacing: 16.h,
                        children: [
                          Row(
                            spacing: 16.h,
                            children: [
                              Expanded(
                                child: CarCaptureSection(
                                  type: CarCaptureSectionType.regCert,
                                  images: controller.regCertImages,
                                  onImageCaptured: (file, index) =>
                                      controller.addImage(
                                        CarCaptureSectionType.regCert,
                                        file.path,
                                        index: index,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: CarCaptureSection(
                                  type: CarCaptureSectionType.regStamp,
                                  images: controller.regStampImages,
                                  onImageCaptured: (file, index) =>
                                      controller.addImage(
                                        CarCaptureSectionType.regStamp,
                                        file.path,
                                        index: index,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16.h,
                            children: [
                              Expanded(
                                child: CarCaptureSection(
                                  type: CarCaptureSectionType.vinNumber,
                                  images: controller.vinNumberImages,
                                  onImageCaptured: (file, index) =>
                                      controller.addImage(
                                        CarCaptureSectionType.vinNumber,
                                        file.path,
                                        index: index,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: CarCaptureSection(
                                  type: CarCaptureSectionType.taplo,
                                  images: controller.taploImages,
                                  onImageCaptured: (file, index) =>
                                      controller.addImage(
                                        CarCaptureSectionType.taplo,
                                        file.path,
                                        index: index,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16.h,
                            children: [
                              Expanded(
                                child: CarCaptureSection(
                                  type: CarCaptureSectionType.exterior,
                                  images: controller.exteriorImages,
                                  imagesMap: controller.exteriorImagesMap,
                                  onImageAdded: (angle, path) =>
                                      controller.addImage(
                                        CarCaptureSectionType.exterior,
                                        path,
                                        vehicleAngle: angle,
                                      ),
                                  onImageDeleted: (angle, path) {
                                    controller.removeImage(
                                      CarCaptureSectionType.exterior,
                                      path: path,
                                      vehicleAngle: angle,
                                    );
                                  },
                                ),
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: controller.submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              elevation: 0,
            ),
            child: Text(AppStrings.btnDone, style: AppTextStyles.button),
          ),
        ),
      ),
    );
  }
}
