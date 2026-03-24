import 'package:aicycle_buyme_plus/src/core/parse_output.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import 'controllers/document_result_controller.dart';
import 'widgets/car_info_container.dart';
import 'widgets/segment_container.dart';

class DocumentResultPage extends StatefulWidget {
  const DocumentResultPage({super.key, this.onComplete});
  final Function(Map<String, dynamic> data)? onComplete;

  @override
  State<DocumentResultPage> createState() => _DocumentResultPageState();
}

class _DocumentResultPageState extends State<DocumentResultPage> {
  late final DocumentResultController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DocumentResultController(
      sl.getVehicleInfoUseCase,
      sl.getDamageStatisticsUseCase,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          AppStrings.documentResultTitle,
          style: AppTextStyles.heading2,
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => _controller.refresh(false),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),

                  /// Thông tin xe
                  CarInfoContainer(vehicleInfo: _controller.vehicleInfo),
                  SizedBox(height: 4.h),

                  /// Thống kê vết hỏng
                  Container(
                    color: AppColors.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Text(
                            AppStrings.damageStatistics,
                            style: AppTextStyles.heading2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.r).copyWith(top: 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppStrings.notice,
                                  style: AppTextStyles.bodyRegular.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: AppStrings.noticeDescription,
                                  style: AppTextStyles.bodyRegular,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListenableBuilder(
                          listenable: _controller,
                          builder: (context, child) {
                            if (_controller.damageStatistics?.isEmpty == true) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.r),
                                  child: Text(
                                    AppStrings.noDamage,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children:
                                  _controller.damageStatistics
                                      ?.map(
                                        (e) =>
                                            SegmentContainer(segmentResult: e),
                                      )
                                      .toList() ??
                                  [],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
              ElevatedButton(
                onPressed: () {
                  final data = ParseOutput.parseDamageStatistics(
                    _controller.damageStatistics ?? [],
                  );
                  widget.onComplete?.call(data);
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
                  AppStrings.sendAndComplete,
                  style: AppTextStyles.button,
                ),
              ),
              SizedBox(height: 8.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 40.h),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.btnRetake,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
