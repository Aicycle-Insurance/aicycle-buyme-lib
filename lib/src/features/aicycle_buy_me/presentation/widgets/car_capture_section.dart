import 'package:aicycle_buyme_plus/src/core/theme/app_text_styles.dart';
import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:aicycle_buyme_plus/src/features/guide_line/presentation/guide_line_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/widgets/dashed_container.dart';
import '../../../car_capture/presentation/pages/car_capture_page.dart';

enum CarCaptureSectionType { regCert, regStamp, vinNumber, taplo, exterior }

class CarCaptureSection extends StatelessWidget {
  const CarCaptureSection({
    super.key,
    required this.type,
    required this.images,
    this.onAddTapped,
    this.errorMessage,
  });
  final CarCaptureSectionType type;
  final List<String> images;
  final Function()? onAddTapped;
  final String? errorMessage;

  String get title {
    switch (type) {
      case CarCaptureSectionType.regCert:
        return AppStrings.photoRegCert;
      case CarCaptureSectionType.regStamp:
        return AppStrings.photoRegStamp;
      case CarCaptureSectionType.vinNumber:
        return AppStrings.photoVinNumber;
      case CarCaptureSectionType.taplo:
        return AppStrings.photoTaplo;
      case CarCaptureSectionType.exterior:
        return AppStrings.photoExterior;
    }
  }

  int get numberImageContainer {
    if (type == CarCaptureSectionType.regCert) {
      return 2;
    }
    return 1;
  }

  void onGuideTapped(BuildContext context) {
    GuideType guideType = GuideType.vinNumber;
    switch (type) {
      case CarCaptureSectionType.regCert:
        guideType = GuideType.regCert;
        break;
      case CarCaptureSectionType.regStamp:
        guideType = GuideType.regStamp;
        break;
      case CarCaptureSectionType.vinNumber:
        guideType = GuideType.vinNumber;
        break;
      case CarCaptureSectionType.taplo:
        guideType = GuideType.taplo;
        break;
      case CarCaptureSectionType.exterior:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarCapturePage()),
        );
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuideLinePage(guideType: guideType),
      ),
    );
  }

  Widget _buildImageContainer() {
    return DashedContainer(
      height: 90.h,
      backgroundColor: AppColors.backgroundGray,
      borderRadius: 8.r,
      color: AppColors.borderGray,
      dashPattern: const [8, 8],
      child: InkWell(
        onTap: onAddTapped,
        child: Center(
          child: Icon(Icons.add_rounded, size: 20.r, color: AppColors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorMessage != null
                  ? AppColors.error
                  : AppColors.borderGray,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body12Medium),
              const SizedBox(height: 8),
              numberImageContainer > 1
                  ? Row(
                      spacing: 8.w,
                      children: [
                        Expanded(child: _buildImageContainer()),
                        Expanded(child: _buildImageContainer()),
                      ],
                    )
                  : _buildImageContainer(),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  text: '${AppStrings.guide} ',
                  style: AppTextStyles.link,
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onGuideTapped(context),
                ),
              ),
            ],
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                height: 16.r,
                width: 16.r,
                child: Assets.images.icInfoCircle.image(
                  package: AppStrings.package,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  errorMessage!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body12Medium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
