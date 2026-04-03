import 'package:aicycle_buyme_plus/src/core/di/injection.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
import 'package:aicycle_buyme_plus/src/features/camera/presentation/widgets/first_guide_popup.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/orientation_utils.dart';
import '../controllers/camera_controller.dart';
import '../widgets/camera_bottom_bar.dart';
import '../widgets/camera_top_bar.dart';
// import '../widgets/guide_frame.dart';
import '../widgets/photo_preview.dart';
import '../../../../core/widgets/validation_dialog.dart';

class CameraArgs {
  final AicycleCarAngle vehicleAngle;
  final bool isFramedPhoto;

  const CameraArgs({required this.vehicleAngle, required this.isFramedPhoto});
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.args});

  final CameraArgs args;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final XCameraController _controller;
  bool _showGuide = true;

  // bool get supportGuide => widget.args.isFramedPhoto;

  @override
  void initState() {
    super.initState();
    _controller = XCameraController(angle: widget.args.vehicleAngle);
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

  void _onWarning(EngineException warning) {
    if (mounted) {
      CommonValidationDialog.show(
        context: context,
        title: AppStrings.warning,
        quarterTurns: 1,
        message: warning.message ?? 'Something went wrong.',
        primaryButtonLabel: AppStrings.btnRetake,
        secondaryButtonLabel: AppStrings.btnContinue,
        onPrimaryTapped: () {
          Navigator.pop(context);
          _controller.retake();
        },
        onSecondaryTapped: () {
          Navigator.pop(context);
          _controller.onWarningContinue();
        },
      );
    }
  }

  void _onError(String message) {
    if (mounted) {
      CommonValidationDialog.show(
        context: context,
        title: AppStrings.error,
        quarterTurns: 1,
        message: message,
        primaryButtonLabel: AppStrings.btnRetake,
        onPrimaryTapped: () {
          Navigator.pop(context);
          _controller.retake();
        },
      );
    }
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
                  automaticallyImplyLeading: false,
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  toolbarHeight: 0,
                  elevation: 0,
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
                                    // if (supportGuide && _controller.showFrame)
                                    //   Center(
                                    //     child: GuideFrame(
                                    //       carCorner: widget.args.vehicleAngle,
                                    //     ),
                                    //   ),

                                    /// Top Buttons
                                    Visibility(
                                      visible:
                                          _controller.capturedImage == null,
                                      child: CameraTopBar(
                                        controller: _controller,
                                        turns: turns,
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
                                        // supportGuide: supportGuide,
                                      ),
                                    ),

                                    /// Photo preview
                                    if (_controller.capturedImage != null)
                                      PhotoPreview(
                                        image: _controller.capturedImage!,
                                        isUploading: _controller.isUploading,
                                        onRetake: _controller.retake,
                                        onSave: () async {
                                          await _controller.upload(
                                            onSuccess: _controller.retake,
                                            onWarning: _onWarning,
                                            onError: _onError,
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListenableBuilder(
                        listenable: sl.vehicleImageVault,
                        builder: (context, _) {
                          if (widget.args.vehicleAngle ==
                                  AicycleCarAngle.exterior &&
                              sl.vehicleImageVault.exteriorImages.isEmpty &&
                              _showGuide) {
                            return Center(
                              child: FirstGuidePopup(
                                onTap: () => setState(() => _showGuide = false),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
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
}
