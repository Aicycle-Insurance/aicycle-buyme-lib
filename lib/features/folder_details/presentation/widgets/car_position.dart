// ignore_for_file: deprecated_member_use_from_same_package

import '../../../../enum/car_model.dart';
import '../../../camera/presentation/camera_page.dart';
import '../../../common/themes/c_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../aicycle_buyme_lib.dart';
import '../../../common/cache_image_widget.dart';
import '../../../common/themes/c_colors.dart';
import '../../../../enum/car_part_direction.dart';
import '../../../../generated/assets.gen.dart';
import '../../data/models/buy_me_image_model.dart';

class CarPosition extends StatelessWidget {
  final String claimFolderId;
  final CarPartDirectionEnum direction;
  final List<BuyMeImage>? images;
  const CarPosition({
    super.key,
    required this.direction,
    required this.claimFolderId,
    this.images,
  });

  @override
  Widget build(BuildContext context) {
    final scrWidth = MediaQuery.of(context).size.width;
    final String? image = images
        ?.firstWhere(
          (e) => e.directionSlug == direction.excelId.toString(),
          orElse: () => const BuyMeImage(),
        )
        .imageUrl;

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CameraPage(
            argument: BuyMeCameraArgument(
              carPartDirectionEnum: direction,
              carModelEnum: CarModelEnum.kiaMorning,
              claimId: claimFolderId,
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          image == null
              ? Container(
                  padding: const EdgeInsets.all(12),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Assets.icons.icCamera.svg(
                    color: CColors.primaryA500,
                    package: packageName,
                  ),
                )
              : CachedImageWidget(
                  url: image,
                  width: 40,
                  height: 40,
                  borderRadius: 4,
                ),
          const Gap(10),
          Container(
            width: (0.8 * scrWidth) / 3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              direction.buyMeTitle,
              textAlign: TextAlign.center,
              style: CTextStyles.base.s12.setColor(CColors.inkA500),
            ),
          ),
        ],
      ),
    );
  }
}
