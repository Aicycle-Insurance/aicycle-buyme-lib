import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../../aicycle_buyme_plus.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../document_result/presentation/document_result_page.dart';
import 'controllers/buy_me_controller.dart';
import 'widgets/car_capture_guide.dart';
import 'widgets/car_capture_section.dart';

class BuyMePage extends StatelessWidget {
  final BuyMeController controller;
  final AiCycleConfig config;
  final Function(dynamic data)? onComplete;

  const BuyMePage({
    super.key,
    required this.controller,
    required this.config,
    this.onComplete,
  });

  void onSubmit(BuildContext context) {
    if (config.generalConfig.showResultScreen == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentResultPage(onComplete: onComplete),
        ),
      );
    } else {
      controller.submit(onComplete);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listSupportCarAngles = config
        .displayConfig
        .carAnglesWithDisplayName
        .keys
        .toList();
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

                  if (listSupportCarAngles.isEmpty)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.r),
                        child: Center(
                          child: Text(
                            AppStrings.noSupportCarAngles,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.iconGray,
                            ),
                          ),
                        ),
                      ),
                    )
                  /// Hình ảnh xe
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.h),
                        child: Wrap(
                          spacing: 16.h,
                          runSpacing: 16.h,
                          children: [
                            /// Giấy đăng kiểm
                            if (listSupportCarAngles.contains(
                              AicycleCarAngle.regCert,
                            ))
                              CarCaptureSection(angle: AicycleCarAngle.regCert),

                            /// Tem đăng kiểm
                            if (listSupportCarAngles.contains(
                              AicycleCarAngle.regStamp,
                            ))
                              CarCaptureSection(
                                angle: AicycleCarAngle.regStamp,
                              ),

                            /// Số khung
                            if (listSupportCarAngles.contains(
                              AicycleCarAngle.vinNumber,
                            ))
                              CarCaptureSection(
                                angle: AicycleCarAngle.vinNumber,
                              ),

                            /// Taplo
                            if (listSupportCarAngles.contains(
                              AicycleCarAngle.taplo,
                            ))
                              CarCaptureSection(angle: AicycleCarAngle.taplo),

                            /// Ngoại thất
                            CarCaptureSection(angle: AicycleCarAngle.exterior),
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
      bottomNavigationBar: listSupportCarAngles.isEmpty
          ? null
          : Container(
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
                      onPressed: canSubmit ? () => onSubmit(context) : null,
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
                    );
                  },
                ),
              ),
            ),
    );
  }
}
