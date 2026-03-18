import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import '../../../../../aicycle_buyme_plus.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../core/utils/orientation_utils.dart';
import '../../../../core/utils/screen_utils.dart';
import '../controllers/angle_camera_controller.dart';
import '../widgets/guide_frame.dart';

class CameraArgs {
  final AicycleCarAngle? vehicleAngle;

  const CameraArgs({this.vehicleAngle});
}

class AngleCameraPage extends StatefulWidget {
  const AngleCameraPage({super.key, required this.args});

  final CameraArgs args;

  @override
  State<AngleCameraPage> createState() => _AngleCameraPageState();
}

class _AngleCameraPageState extends State<AngleCameraPage> {
  late final AngleCameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AngleCameraController();
    _controller.addListener(_onStatusChanged);
    _controller.initialize();
  }

  void _onStatusChanged() {
    if (_controller.status == AngleCameraStatus.error) {
      debugPrint(_controller.errorMessage);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NativeDeviceOrientationReader(
      useSensor: true,
      builder: (context) {
        final orientation = NativeDeviceOrientationReader.orientation(context);
        final turns = OrientationUtils.getTurns(orientation);

        return ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            if (_controller.status == AngleCameraStatus.initializing ||
                _controller.status == AngleCameraStatus.initial) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (_controller.status == AngleCameraStatus.ready &&
                _controller.controller != null) {
              return Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_controller.controller!),

                    /// Guide Frame
                    if (widget.args.vehicleAngle != null &&
                        _controller.showFrame)
                      Center(
                        child: GuideFrame(carCorner: widget.args.vehicleAngle!),
                      ),

                    /// Top Buttons
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
                          onTap: _controller.toggleFlash,
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
                                _getFlashIcon(_controller.flashMode),
                                color: Colors.white,
                                size: 24.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Bottom Controls
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 122.h,
                        color: Colors.black54,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /// Gallery Button
                            InkWell(
                              onTap: () async {
                                final file = await _controller
                                    .pickImageFromGallery();
                                if (file != null && context.mounted) {
                                  Navigator.pop(context, file);
                                }
                              },
                              child: Container(
                                width: 48.r,
                                height: 48.r,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.borderGray,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: AnimatedRotation(
                                  turns: turns,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Colors.white,
                                    size: 24.r,
                                  ),
                                ),
                              ),
                            ),

                            // Capture Button
                            GestureDetector(
                              onTap: () async {
                                final file = await _controller.takePicture(
                                  orientation,
                                );
                                if (file != null && context.mounted) {
                                  Navigator.pop(context, file);
                                }
                              },
                              child: Container(
                                width: 58.r,
                                height: 58.r,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: AnimatedRotation(
                                  turns: turns,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 24.r,
                                  ),
                                ),
                              ),
                            ),

                            // Frame Button
                            if (widget.args.vehicleAngle != null)
                              InkWell(
                                onTap: _controller.toggleFrame,
                                child: SizedBox(
                                  width: 48.r,
                                  height: 48.r,
                                  child: AnimatedRotation(
                                    turns: turns,
                                    duration: const Duration(milliseconds: 300),
                                    child: Image.asset(
                                      _controller.showFrame
                                          ? Assets.images.icFrameOn.path
                                          : Assets.images.icFrameOff.path,
                                      package: AppStrings.package,
                                    ),
                                  ),
                                ),
                              )
                            else
                              SizedBox(width: 48.r, height: 48.r),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Scaffold(
              backgroundColor: Colors.black,
              body: SizedBox.shrink(),
            );
          },
        );
      },
    );
  }

  IconData _getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off_rounded;
      case FlashMode.always:
        return Icons.flash_on_rounded;
      case FlashMode.auto:
        return Icons.flash_auto_rounded;
      default:
        return Icons.flash_off_rounded;
    }
  }
}
