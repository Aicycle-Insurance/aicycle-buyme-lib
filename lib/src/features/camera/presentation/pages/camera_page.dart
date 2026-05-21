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
import '../../../../core/utils/screen_utils.dart';
import '../controllers/camera_controller.dart';
import '../widgets/camera_bottom_bar.dart';
import '../widgets/camera_top_bar.dart';
import '../widgets/cert_top_bar.dart';
import '../widgets/guide_frame.dart';
import '../widgets/photo_preview.dart';
import '../../../../core/widgets/validation_dialog.dart';

/// Đối số truyền vào cho màn hình chụp ảnh [CameraPage].
class CameraArgs {
  /// Góc chụp hiện tại của xe (ví dụ: sườn trái, sườn phải, đăng kiểm...).
  final AicycleCarAngle vehicleAngle;

  /// Xác định xem ảnh chụp có hiển thị khung hướng dẫn (Guide Frame) hay không.
  final bool isFramedPhoto;

  /// Khởi tạo [CameraArgs] với góc chụp xe và cờ kiểm tra khung hướng dẫn.
  const CameraArgs({required this.vehicleAngle, required this.isFramedPhoto});
}

/// Trang chính hiển thị giao diện Camera chụp ảnh xe.
class CameraPage extends StatefulWidget {
  /// Khởi tạo màn hình Camera.
  const CameraPage({super.key, required this.args});

  /// Đối số cấu hình góc chụp và khung hướng dẫn.
  final CameraArgs args;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

/// State quản lý vòng đời và các sự kiện xảy ra trên màn hình [CameraPage].
class _CameraPageState extends State<CameraPage> {
  /// Controller quản lý camera và tải ảnh lên server.
  late final XCameraController _controller;

  /// Cờ hiển thị hộp thoại popup hướng dẫn chụp lần đầu.
  bool _showGuide = true;

  /// Kiểm tra góc chụp hiện tại có hỗ trợ hiển thị khung hướng dẫn hay không.
  bool get supportGuide => widget.args.isFramedPhoto;

  /// Các góc chụp cụ thể không cần hiển thị hướng dẫn ban đầu (ví dụ: đăng kiểm, tem đăng kiểm, số VIN, taplo).
  bool get _disableShowGuide =>
      widget.args.vehicleAngle == AicycleCarAngle.regCert ||
      widget.args.vehicleAngle == AicycleCarAngle.regStamp ||
      widget.args.vehicleAngle == AicycleCarAngle.vinNumber ||
      widget.args.vehicleAngle == AicycleCarAngle.taplo;

  /// Khởi tạo trạng thái ban đầu của trang, gán listener và gọi hàm initialize camera.
  @override
  void initState() {
    super.initState();
    _controller = XCameraController(angle: widget.args.vehicleAngle);
    _controller.addListener(_onStatusChanged);
    _controller.initialize();
  }

  /// Phản hồi khi trạng thái camera thay đổi. Nếu xảy ra lỗi khởi tạo, tự động quay về màn hình trước.
  void _onStatusChanged() {
    if (_controller.status == CameraStatus.error) {
      debugPrint(_controller.errorMessage);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// Giải phóng tài nguyên và huỷ lắng nghe thay đổi trạng thái của camera khi huỷ widget.
  @override
  void dispose() {
    _controller.removeListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  /// Hiển thị hộp thoại cảnh báo khi máy chủ (Engine AI) trả về cảnh báo về chất lượng hình ảnh hoặc loại xe.
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
          _controller.onWarningRetake();
        },
        onSecondaryTapped: () {
          Navigator.pop(context);
          _controller.onWarningContinue();
        },
      );
    }
  }

  /// Hiển thị hộp thoại lỗi khi quá trình chụp, nén hoặc tải ảnh lên server bị thất bại hoàn toàn.
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

  /// Kiểm tra và cảnh báo khi người dùng nhấn nút thoát nếu ảnh đăng kiểm chưa chụp đủ cả mặt trước và mặt sau (tối thiểu 2 ảnh).
  Future<bool> _onWillPop() async {
    if (widget.args.vehicleAngle == AicycleCarAngle.regCert &&
        _controller.regCertImages.isNotEmpty &&
        _controller.regCertImages.length < 2) {
      final shouldPop = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return RotatedBox(
            quarterTurns: 1,
            child: ValidationDialog(
              title: AppStrings.warning,
              width: 360.h,
              message: AppStrings.regCertRule,
              primaryButtonLabel: AppStrings.btnCaptureMore,
              secondaryButtonLabel: AppStrings.btnExit,
              onPrimaryTapped: () => Navigator.pop(context, false),
              onSecondaryTapped: () => Navigator.pop(context, true),
            ),
          );
        },
      );
      return shouldPop ?? false;
    }
    return true;
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
              final bool canPop =
                  !(widget.args.vehicleAngle == AicycleCarAngle.regCert &&
                      _controller.regCertImages.isNotEmpty &&
                      _controller.regCertImages.length < 2);

              return PopScope(
                canPop: canPop,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  _onWillPop().then((shouldPop) {
                    if (shouldPop && context.mounted) {
                      Navigator.pop(context);
                    }
                  });
                },
                child: Scaffold(
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
                                      if (supportGuide && _controller.showFrame)
                                        Center(
                                          child: GuideFrame(
                                            carCorner: widget.args.vehicleAngle,
                                          ),
                                        ),

                                      /// Top Buttons
                                      Visibility(
                                        visible:
                                            _controller.capturedImage == null,
                                        child: CameraTopBar(
                                          controller: _controller,
                                          turns: turns,
                                          showGuidleFrameButton: supportGuide,
                                          onBack: () {
                                            _onWillPop().then((shouldPop) {
                                              if (shouldPop &&
                                                  context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            });
                                          },
                                        ),
                                      ),

                                      if (widget.args.vehicleAngle ==
                                          AicycleCarAngle.regCert)
                                        CertTopBar(controller: _controller),

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
                        if (!_disableShowGuide)
                          ListenableBuilder(
                            listenable: sl.vehicleImageVault,
                            builder: (context, _) {
                              if (!sl.vehicleImageVault.hasAnyImage &&
                                  _showGuide) {
                                return Center(
                                  child: FirstGuidePopup(
                                    onTap: () =>
                                        setState(() => _showGuide = false),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                      ],
                    ),
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
