import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../../aicycle_buyme_plus.dart';
import '../../../core/di/injection.dart';
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
                                  angle: AicycleCarAngle.regCert,
                                ),
                              ),
                              Expanded(
                                child: CarCaptureSection(
                                  angle: AicycleCarAngle.regStamp,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16.h,
                            children: [
                              Expanded(
                                child: CarCaptureSection(
                                  angle: AicycleCarAngle.vinNumber,
                                ),
                              ),
                              Expanded(
                                child: CarCaptureSection(
                                  angle: AicycleCarAngle.taplo,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16.h,
                            children: [
                              Expanded(
                                child: ListenableBuilder(
                                  listenable: sl.validationVault,
                                  builder: (context, _) {
                                    return CarCaptureSection(
                                      angle: AicycleCarAngle.exterior,
                                      errorMessage:
                                          sl.validationVault.errorMessage,
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
          child: ListenableBuilder(
            listenable: sl.validationVault,
            builder: (context, _) {
              final canSubmit =
                  sl.validationVault.isHasImage &&
                  sl.validationVault.errorMessage?.isNotEmpty != true;
              return ElevatedButton(
                onPressed: canSubmit ? controller.submit : null,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
