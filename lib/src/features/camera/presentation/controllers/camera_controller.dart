import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/extension/car_angle_ext.dart';
import '../../../../core/extension/xx_file.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/utils/image_utils.dart';
import '../../../../core/utils/internal_cache.dart';
import '../../../aicycle_buy_me/domain/entities/directional_image.dart';
import '../../domain/entities/cert_upload_entity.dart';
import '../../domain/entities/upload_vehicle_inspection.dart';
import '../../domain/usecases/upload_image_use_case.dart';
import '../../domain/usecases/upload_vehicle_inspection_use_case.dart';

enum CameraStatus { initial, initializing, ready, error }

class XCameraController extends ChangeNotifier {
  XCameraController({required this.angle});

  final AicycleCarAngle angle;
  CameraController? _controller;
  CameraStatus _status = CameraStatus.initial;
  String _errorMessage = '';
  FlashMode _flashMode = FlashMode.off;
  bool _showFrame = false;
  XXFile? _capturedImage;
  bool _isUploading = false;
  final List<XXFile> _regCertImages = [];
  UploadVehicleInspection? _warningResultCached;
  CertUploadEntity? _warningCertCached;
  static const List<int> warningEngineCodes = [
    23212,
    77704,
    60006,
    60007,
    66616,
  ];

  CameraController? get controller => _controller;
  CameraStatus get status => _status;
  String get errorMessage => _errorMessage;
  FlashMode get flashMode => _flashMode;
  bool get showFrame => _showFrame;
  XXFile? get capturedImage => _capturedImage;
  bool get isUploading => _isUploading;
  List<XXFile> get regCertImages => _regCertImages;
  bool get isRegCert => angle == AicycleCarAngle.regCert;

  String get regCertInstruction {
    if (!isRegCert) return angle.title;
    if (_regCertImages.isEmpty) return AppStrings.captureFrontRegCert;
    if (_regCertImages.length == 1) return AppStrings.captureRearRegCert;
    return angle.title;
  }

  /// Khởi tạo camera
  Future<void> initialize() async {
    try {
      _status = CameraStatus.initializing;
      notifyListeners();

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _status = CameraStatus.error;
        _errorMessage = 'No cameras found';
        notifyListeners();
        return;
      }

      final firstCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );

      await _controller!.initialize();
      await _controller!.setFlashMode(FlashMode.off);

      _status = CameraStatus.ready;
      notifyListeners();
    } catch (e) {
      _status = CameraStatus.error;
      _errorMessage = 'Camera initialization failed: $e';
      notifyListeners();
    }
  }

  /// Chụp ảnh
  Future<void> takePicture(NativeDeviceOrientation orientation) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final XFile rawImage = await _controller!.takePicture();

      final rotatedImage = await ImageUtils.rotateImageIfNecessary(
        rawImage,
        orientation,
      );

      _capturedImage = XXFile.fromXFile(rotatedImage, orientation: orientation);
      notifyListeners();
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void setCapturedImage(XXFile image) {
    _capturedImage = image;
    notifyListeners();
  }

  /// Chụp lại (reset ảnh đã chụp)
  void retake() {
    if (isRegCert) {
      if (_capturedImage != null && _regCertImages.contains(_capturedImage!)) {
        _regCertImages.remove(_capturedImage!);
      }
    }
    _capturedImage = null;
    notifyListeners();
  }

  /// Xoá ảnh đăng kiểm đã chụp
  void discardRegCertImage(XXFile image) {
    _regCertImages.removeWhere((e) => e.path == image.path);
    notifyListeners();
  }

  /// Chuyển đổi chế độ flash
  Future<void> toggleFlash() async {
    if (_controller == null) return;

    final modes = [FlashMode.off, FlashMode.always];
    final currentIndex = modes.indexOf(_flashMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    _flashMode = modes[nextIndex];

    await _controller!.setFlashMode(_flashMode);
    notifyListeners();
  }

  /// Chuyển đổi hiển thị khung hướng dẫn
  void toggleFrame() {
    _showFrame = !_showFrame;
    notifyListeners();
  }

  /// Chọn ảnh từ thư viện
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _capturedImage = XXFile.fromXFile(
        file,
        orientation: NativeDeviceOrientation.landscapeLeft,
      );
      notifyListeners();
    }
  }

  /// Thực hiện upload ảnh nếu cần (dành riêng cho luồng regCert)
  Future<void> upload({
    required VoidCallback onSuccess,
    required void Function(EngineException warning) onWarning,
    required void Function(String message) onError,
  }) async {
    if (_capturedImage == null) return;

    try {
      if (isRegCert) {
        if (!_regCertImages.contains(_capturedImage!)) {
          _regCertImages.add(_capturedImage!);
        }
        if (_regCertImages.length < 2) {
          _capturedImage = null;
          notifyListeners();
          return;
        }
      }

      _setUploading(true);

      if (isRegCert) {
        _warningCertCached = null;
        final images = await Future.wait(
          _regCertImages.map((e) => ImageUtils.compressedImage(e)),
        );
        final result = await _uploadRegCert(images);
        _handleUploadResult(
          result.errorLevel,
          onWarning: () {
            _warningCertCached = result;
            onWarning(
              EngineException(result.errorMessage, result.errorCodeFromEngine),
            );
          },
          onError: (msg) =>
              onError(msg ?? result.errorMessage ?? 'Something went wrong.'),
          onSuccess: () {
            _regCertImages.clear();
            onSuccess();
          },
        );
      } else {
        _warningResultCached = null;
        final image = await ImageUtils.compressedImage(_capturedImage!);
        final result = await _uploadRegularImage(image);
        _handleUploadResult(
          result.errorLevel,
          onWarning: () {
            _warningResultCached = result;
            onWarning(
              EngineException(result.errorMessage, result.errorCodeFromEngine),
            );
          },
          onError: (msg) =>
              onError(msg ?? result.errorMessage ?? 'Something went wrong.'),
          onSuccess: onSuccess,
        );
      }
    } on EngineException catch (e) {
      if (warningEngineCodes.contains(e.engineCode)) {
        onWarning(e);
      } else {
        onError(e.message ?? 'Something went wrong.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      _setUploading(false);
    }
  }

  void _handleUploadResult(
    ErrorLevel? errorLevel, {
    required VoidCallback onWarning,
    required void Function(String? message) onError,
    required VoidCallback onSuccess,
  }) {
    if (errorLevel == ErrorLevel.warning) {
      onWarning();
    } else if (errorLevel == ErrorLevel.error) {
      onError(null);
    } else {
      onSuccess();
    }
  }

  /// Tiếp tục sau khi nhận cảnh báo từ engine
  void onWarningContinue() {
    if (isRegCert) {
      if (_warningCertCached != null) {
        _addCertToVault(_warningCertCached!);
        _warningCertCached = null;
        _regCertImages.clear();
      }
    } else {
      if (_warningResultCached != null) {
        _addRegularToVault(_warningResultCached!);
        _warningResultCached = null;
      }
    }
    _capturedImage = null;
    notifyListeners();
  }

  /// Chụp lại sau khi nhận cảnh báo từ engine
  void onWarningRetake() {
    if (isRegCert) {
      if (_capturedImage != null && _regCertImages.contains(_capturedImage!)) {
        _regCertImages.remove(_capturedImage!);
      }
      _warningCertCached = null;
    } else {
      _warningResultCached = null;
    }
    _capturedImage = null;
    notifyListeners();
  }

  /// Cập nhật trạng thái đang upload
  void _setUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  /// Upload ảnh đăng kiểm (regCert)
  Future<CertUploadEntity> _uploadRegCert(List<XFile> compressedImages) async {
    final result = await sl.uploadVehicleInspectionUseCase(
      UploadVehicleInspectionParams(
        imagePaths: compressedImages.map((e) => e.path).toList(),
        claimId: InternalCache.claimId,
      ),
    );

    if (result.errorLevel == ErrorLevel.success) {
      _addCertToVault(result);
    }
    return result;
  }

  Future<UploadVehicleInspection> _uploadRegularImage(
    XFile compressedImage,
  ) async {
    final result = await sl.uploadImageUseCase(
      UploadImageParams(
        imagePath: compressedImage.path,
        claimId: InternalCache.claimId,
        angleId: angle.id,
      ),
    );

    if (result.errorLevel == ErrorLevel.success) {
      _addRegularToVault(result);
    }
    return result;
  }

  void _addCertToVault(CertUploadEntity result) {
    if (result.imgUrls == null) return;
    sl.vehicleImageVault.addImagesFromServer(
      AicycleCarAngle.regCert,
      result.imgUrls!
          .map((e) => DirectionalImage(imageId: result.imageId, imageUrl: e))
          .toList(),
    );
  }

  void _addRegularToVault(UploadVehicleInspection result) {
    if (result.imgUrl == null) return;
    sl.vehicleImageVault.addImagesFromServer(result.angleFromEngine ?? angle, [
      DirectionalImage(imageId: result.imageId, imageUrl: result.imgUrl),
    ]);
  }

  /// Giải phóng tài nguyên camera
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
