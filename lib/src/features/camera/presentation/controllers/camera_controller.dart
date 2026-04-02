import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:aicycle_buyme_plus/src/core/di/injection.dart';
import 'package:aicycle_buyme_plus/src/core/utils/image_utils.dart';
import 'package:aicycle_buyme_plus/src/core/extension/xx_file.dart';
import 'package:aicycle_buyme_plus/src/core/utils/internal_cache.dart';
import 'package:aicycle_buyme_plus/src/features/camera/domain/usecases/upload_image_use_case.dart';
import 'package:aicycle_buyme_plus/src/features/camera/domain/usecases/upload_vehicle_inspection_use_case.dart';
import 'package:aicycle_buyme_plus/src/features/aicycle_buy_me/domain/entities/directional_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/extension/car_angle_ext.dart';
import '../../domain/entities/upload_vehicle_inspection.dart';

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

  void retake() {
    _capturedImage = null;
    notifyListeners();
  }

  Future<void> toggleFlash() async {
    if (_controller == null) return;

    final modes = [FlashMode.off, FlashMode.always];
    final currentIndex = modes.indexOf(_flashMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    _flashMode = modes[nextIndex];

    await _controller!.setFlashMode(_flashMode);
    notifyListeners();
  }

  void toggleFrame() {
    _showFrame = !_showFrame;
    notifyListeners();
  }

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
      _setUploading(true);

      final compressedImage = await ImageUtils.compressedImage(_capturedImage!);
      late UploadVehicleInspection result;
      // Chỉ upload nếu góc chụp là regCert (đăng kiểm)
      if (angle == AicycleCarAngle.regCert) {
        result = await _uploadRegCert(compressedImage);
      } else {
        result = await _uploadRegularImage(compressedImage);
      }

      /// Handle if status 200 mà vẫn có error :)
      if (result.errorCodeFromEngine != null &&
          warningEngineCodes.contains(result.errorCodeFromEngine)) {
        onWarning(
          EngineException(result.errorMessage, result.errorCodeFromEngine),
        );
      } else if (result.errorCodeFromEngine != null &&
          result.errorCodeFromEngine != 0) {
        onError(result.errorMessage ?? 'Something went wrong.');
      } else {
        onSuccess();
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

  void _setUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  Future<UploadVehicleInspection> _uploadRegCert(XFile compressedImage) async {
    final claimId = InternalCache.claimId;

    final result = await sl.uploadVehicleInspectionUseCase(
      UploadVehicleInspectionParams(
        imagePath: compressedImage.path,
        claimId: claimId,
      ),
    );

    if (result.imgUrl != null) {
      sl.vehicleImageVault.addImagesFromServer(
        result.angleFromEngine ?? angle,
        [DirectionalImage(imageId: result.imageId, imageUrl: result.imgUrl)],
      );
    }

    return result;
  }

  Future<UploadVehicleInspection> _uploadRegularImage(
    XFile compressedImage,
  ) async {
    final claimId = InternalCache.claimId;

    final result = await sl.uploadImageUseCase(
      UploadImageParams(
        imagePath: compressedImage.path,
        claimId: claimId,
        angleId: angle.id,
      ),
    );

    if (result.imgUrl != null) {
      sl.vehicleImageVault.addImagesFromServer(
        result.angleFromEngine ?? angle,
        [DirectionalImage(imageId: result.imageId, imageUrl: result.imgUrl)],
      );
    }

    return result;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
