import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';
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
import '../widgets/guide_frame.dart';
import '../widgets/photo_preview.dart';
import '../../../../core/widgets/validation_dialog.dart';

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
        title: 'Warning',
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
          Navigator.pop(context);
        },
      );
    }
  }

  void _onError(String message) {
    if (mounted) {
      CommonValidationDialog.show(
        context: context,
        title: 'Error',
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
                                        supportGuide: supportGuide,
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
                                            onSuccess: () {
                                              if (mounted) {
                                                Navigator.pop(
                                                  context,
                                                  _controller.capturedImage,
                                                );
                                              }
                                            },
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
