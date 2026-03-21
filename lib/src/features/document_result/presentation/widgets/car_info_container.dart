import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:aicycle_buyme_plus/src/features/document_result/domain/entities/vehicle_info.dart';
import 'package:flutter/material.dart';

import '../../../../core/extension/color_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class CarInfoContainer extends StatelessWidget {
  const CarInfoContainer({super.key, required this.vehicleInfo});
  final VehicleInfo? vehicleInfo;

  Widget _tableCell(String title, {String? value, Widget? valueWidget}) {
    return SizedBox(
      height: 42.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), style: AppTextStyles.body10Regular),
          if (value != null)
            Text(
              value,
              style: AppTextStyles.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            valueWidget ?? Text('N/A', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: AppColors.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.carInfo, style: AppTextStyles.bodySemibold),
          SizedBox(height: 16.h),
          Row(
            spacing: 16.h,
            children: [
              Expanded(
                flex: 2,
                child: _tableCell(
                  AppStrings.licensePlate,
                  value: vehicleInfo?.plateNumber,
                ),
              ),
              Expanded(
                flex: 3,
                child: _tableCell(
                  AppStrings.carColor,
                  valueWidget: Container(
                    height: 20.h,
                    width: 20.h,
                    decoration: BoxDecoration(
                      color: vehicleInfo?.carColor?.color,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            spacing: 16.h,
            children: [
              Expanded(
                flex: 2,
                child: _tableCell(
                  AppStrings.carBrand,
                  value: vehicleInfo?.carCompany,
                ),
              ),
              Expanded(
                flex: 3,
                child: _tableCell(
                  AppStrings.carModel,
                  value: vehicleInfo?.carModel,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            spacing: 16.h,
            children: [
              Expanded(
                flex: 2,
                child: _tableCell(
                  AppStrings.traveled,
                  value: vehicleInfo?.odo?.toStringAsFixed(2),
                ),
              ),
              Expanded(
                flex: 3,
                child: _tableCell(
                  AppStrings.vinNumber,
                  value: vehicleInfo?.vinNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
