import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/utils/orientation_utils.dart';
import '../../../../core/utils/screen_utils.dart';
import '../controllers/camera_controller.dart';
import '../widgets/camera_bottom_bar.dart';
import '../widgets/guide_frame.dart';
import '../widgets/photo_preview.dart';

class CameraArgs {
  final AicycleCarAngle? vehicleAngle;

  const CameraArgs({this.vehicleAngle});
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.args});

  final CameraArgs args;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final XCameraController _controller;

  bool get supportGuide =>
      widget.args.vehicleAngle != AicycleCarAngle.regCert &&
      widget.args.vehicleAngle != AicycleCarAngle.regStamp &&
      widget.args.vehicleAngle != AicycleCarAngle.vinNumber &&
      widget.args.vehicleAngle != AicycleCarAngle.taplo;

  @override
  void initState() {
    super.initState();
    _controller = XCameraController();
    _controller.addListener(_onStatusChanged);
    _controller.initialize();
  }

  void _onStatusChanged() {
    if (_controller.status == CameraStatus.error) {
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
            if (_controller.status == CameraStatus.initializing ||
                _controller.status == CameraStatus.initial) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (_controller.status == CameraStatus.ready &&
                _controller.controller != null) {
              return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  toolbarHeight: 0,
                ),
                body: SafeArea(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: ClipRect(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.width *
                                  _controller.controller!.value.aspectRatio,
                              child: CameraPreview(
                                _controller.controller!,
                                child: Stack(
                                  children: [
                                    /// Guide Frame
                                    if (supportGuide && _controller.showFrame)
                                      Center(
                                        child: GuideFrame(
                                          carCorner: widget.args.vehicleAngle!,
                                          orientation: orientation,
                                        ),
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
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
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
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Icon(
                                                _getFlashIcon(
                                                  _controller.flashMode,
                                                ),
                                                color: Colors.white,
                                                size: 24.r,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// Bottom Controls
                                    Visibility(
                                      visible:
                                          _controller.capturedImage == null,
                                      child: CameraBottomBar(
                                        controller: _controller,
                                        orientation: orientation,
                                        turns: turns,
                                        args: widget.args,
                                        supportGuide: supportGuide,
                                      ),
                                    ),

                                    /// Photo preview
                                    if (_controller.capturedImage != null)
                                      PhotoPreview(
                                        image: _controller.capturedImage!,
                                        onRetake: _controller.retake,
                                        onSave: () => Navigator.pop(
                                          context,
                                          _controller.capturedImage,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
