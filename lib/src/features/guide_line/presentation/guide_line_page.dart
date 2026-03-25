import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import '../../camera/presentation/pages/camera_page.dart';
import '../domain/entities/guide.dart';
import 'guide_constants.dart';

class GuideLinePage extends StatelessWidget {
  final AicycleCarAngle vehicleAngle;

  const GuideLinePage({super.key, required this.vehicleAngle});

  Guide get _guide => {
    AicycleCarAngle.vinNumber: GuideConstants.vinNumberGuide,
    AicycleCarAngle.regStamp: GuideConstants.regStampGuide,
    AicycleCarAngle.regCert: GuideConstants.regCertGuide,
    AicycleCarAngle.taplo: GuideConstants.taploGuide,
  }[vehicleAngle]!;

  String get buttonLabel {
    final config = AiCycleBuyMe.config;
    final displayName =
        config.displayConfig.carAnglesWithDisplayName[vehicleAngle] ??
        AppStrings.noDisplayName;
    return '${AppStrings.capturePhoto} ${displayName.toLowerCase()}';
  }

  Widget _buildSegment(RichTextSegment segment) {
    if (segment is TextParagraph) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(segment.text, style: AppTextStyles.bodyRegular),
      );
    } else if (segment is BulletGroup) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: segment.bullets.map(_buildBulletPoint).toList(),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBulletPoint(BulletPoint bullet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 8.0, left: 8.0),
            child: Icon(Icons.circle, size: 6.r, color: AppColors.textPrimary),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyRegular,
                children: [
                  if (bullet.prefix != null)
                    TextSpan(
                      text: '${bullet.prefix} ',
                      style: bullet.isPrefixBold
                          ? AppTextStyles.headingSemiBold
                          : AppTextStyles.bodyRegular,
                    ),
                  TextSpan(text: bullet.content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _buildGuideTitle() {
    final config = AiCycleBuyMe.config;
    final displayName =
        config.displayConfig.carAnglesWithDisplayName[vehicleAngle] ??
        AppStrings.noDisplayName;
    String title = AppStrings.captureGuide;
    title += ' ${displayName.toLowerCase()}';
    return Text(title, style: AppTextStyles.heading2);
  }

  void _gotoCameraPage(BuildContext context) async {
    final result = await Navigator.push<XFile?>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(
          args: CameraArgs(vehicleAngle: vehicleAngle, isFramedPhoto: false),
        ),
      ),
    );
    if (result != null) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: _buildGuideTitle(),
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: AiCycleBuyMe.config.displayConfig.showBackButton
            ? BackButton(color: AppColors.textPrimary)
            : null,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_guide.position.isNotEmpty) ...[
                    Text(
                      AppStrings.position,
                      style: AppTextStyles.headingSemiBold,
                    ),
                    const SizedBox(height: 4),
                    ..._guide.position.map(_buildSegment),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    AppStrings.requirement,
                    style: AppTextStyles.headingSemiBold,
                  ),
                  const SizedBox(height: 4),
                  ..._guide.requirement.map(_buildSegment),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.samplePhoto,
                    style: AppTextStyles.body12Medium,
                  ),
                  const SizedBox(height: 8),
                  ..._guide.samplePhotoUrls.map(
                    (url) => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ClipRidge(
                        child: Image.asset(
                          url,
                          fit: BoxFit.cover,
                          package: AppStrings.package,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () => _gotoCameraPage(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              elevation: 0,
            ),
            icon: Icon(Icons.camera_alt_outlined, size: 20.r),
            label: Text(buttonLabel, style: AppTextStyles.button),
          ),
        ),
      ),
    );
  }
}

class ClipRidge extends StatelessWidget {
  final Widget child;

  const ClipRidge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(12), child: child);
  }
}
