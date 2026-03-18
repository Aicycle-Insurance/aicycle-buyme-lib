import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../core/utils/orientation_utils.dart';
import '../../../../core/utils/screen_utils.dart';
import '../controllers/common_camera_controller.dart';
import '../widgets/photo_preview.dart';

class CommonCameraPage extends StatefulWidget {
  const CommonCameraPage({super.key});

  @override
  State<CommonCameraPage> createState() => _CommonCameraPageState();
}

class _CommonCameraPageState extends State<CommonCameraPage> {
  late final CommonCameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CommonCameraController();
    _controller.addListener(_onStatusChanged);
    _controller.initialize();
  }

  void _onStatusChanged() {
    if (_controller.status == CommonCameraStatus.error) {
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
            if (_controller.status == CommonCameraStatus.initializing ||
                _controller.status == CommonCameraStatus.initial) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (_controller.status == CommonCameraStatus.ready &&
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
                      Align(
                        alignment: Alignment.topCenter,
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
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Visibility(
                                        visible:
                                            _controller.capturedImage == null,
                                        child: SafeArea(
                                          minimum: EdgeInsets.only(
                                            bottom: 24.r,
                                          ),
                                          child: GestureDetector(
                                            onTap: () => _controller
                                                .takePicture(orientation),
                                            child: Container(
                                              width: 58.r,
                                              height: 58.r,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: AnimatedRotation(
                                                turns: turns,
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.black,
                                                  size: 24.r,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
              body: Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }

  IconData _getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.torch:
        return Icons.flashlight_on;
    }
  }
}
