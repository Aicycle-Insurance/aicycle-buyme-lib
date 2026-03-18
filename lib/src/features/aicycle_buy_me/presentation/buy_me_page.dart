import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import 'controllers/buy_me_controller.dart';
import 'widgets/car_capture_guide.dart';
import 'widgets/car_capture_section.dart';

class BuyMePage extends StatefulWidget {
  const BuyMePage({super.key});

  @override
  State<BuyMePage> createState() => _BuyMePageState();
}

class _BuyMePageState extends State<BuyMePage> {
  late final BuyMeController controller;

  @override
  void initState() {
    super.initState();
    controller = BuyMeController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.r,
                      mainAxisSpacing: 16.r,
                      padding: EdgeInsets.all(16.r),
                      children: [
                        /// Đăng kiểm
                        CarCaptureSection(
                          type: CarCaptureSectionType.regCert,
                          images: controller.regCertImages,
                        ),

                        /// Tem đăng kiểm
                        CarCaptureSection(
                          type: CarCaptureSectionType.regStamp,
                          images: controller.regStampImages,
                        ),

                        /// Số khung
                        CarCaptureSection(
                          type: CarCaptureSectionType.vinNumber,
                          images: controller.vinNumberImages,
                        ),

                        /// Taplo
                        CarCaptureSection(
                          type: CarCaptureSectionType.taplo,
                          images: controller.taploImages,
                        ),

                        /// Tổng thể
                        CarCaptureSection(
                          type: CarCaptureSectionType.exterior,
                          images: controller.exteriorImages,
                        ),
                      ],
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
