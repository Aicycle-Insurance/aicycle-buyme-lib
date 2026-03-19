import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/screen_utils.dart';
import '../controllers/camera_controller.dart';

class CameraTopBar extends StatelessWidget {
  const CameraTopBar({
    super.key,
    required this.turns,
    required this.controller,
  });

  final double turns;
  final XCameraController controller;

  IconData _getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.torch:
        return Icons.highlight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 16.r,
          left: 16.r,
          child: SafeArea(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: AnimatedRotation(
                  turns: turns,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.r,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16.r,
          right: 16.r,
          child: SafeArea(
            child: InkWell(
              onTap: controller.toggleFlash,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: AnimatedRotation(
                  turns: turns,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _getFlashIcon(controller.flashMode),
                    color: Colors.white,
                    size: 24.r,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
