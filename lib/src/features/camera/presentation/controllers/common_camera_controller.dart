import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '../../../../core/utils/image_utils.dart';
import '../../../../core/xx_file.dart';

enum CommonCameraStatus { initial, initializing, ready, error }

class CommonCameraController extends ChangeNotifier {
  CameraController? _controller;
  CommonCameraStatus _status = CommonCameraStatus.initial;
  String _errorMessage = '';
  FlashMode _flashMode = FlashMode.off;
  XXFile? _capturedImage;

  CameraController? get controller => _controller;
  CommonCameraStatus get status => _status;
  String get errorMessage => _errorMessage;
  FlashMode get flashMode => _flashMode;
  XXFile? get capturedImage => _capturedImage;

  Future<void> initialize() async {
    try {
      _status = CommonCameraStatus.initializing;
      notifyListeners();

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _status = CommonCameraStatus.error;
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

      _status = CommonCameraStatus.ready;
      notifyListeners();
    } catch (e) {
      _status = CommonCameraStatus.error;
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

  Future<XFile?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return XFile(file.path);
    }
    return null;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
