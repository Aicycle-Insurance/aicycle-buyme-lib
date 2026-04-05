import 'package:flutter/material.dart';

import '../../../../core/utils/screen_utils.dart';
import '../controllers/camera_controller.dart';
import 'cert_image_preview.dart';

class CertTopBar extends StatelessWidget {
  const CertTopBar({super.key, required this.controller});

  final XCameraController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80.r,
      right: 16.r,
      child: RotatedBox(
        quarterTurns: 1,
        child: Row(
          children: [
            CertImagePreview(
              image: controller.regCertImages.isEmpty
                  ? null
                  : controller.regCertImages[0],
              onTap: controller.setCapturedImage,
            ),
            SizedBox(width: 16.h),
            CertImagePreview(
              image: controller.regCertImages.length > 1
                  ? controller.regCertImages[1]
                  : null,
              onTap: controller.setCapturedImage,
            ),
            SizedBox(width: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                controller.regCertInstruction,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
