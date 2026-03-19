import 'package:aicycle_buyme_plus/src/core/utils/image_utils.dart';
import 'package:aicycle_buyme_plus/src/core/extension/xx_file.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

enum CameraStatus { initial, initializing, ready, error }

class XCameraController extends ChangeNotifier {
  CameraController? _controller;
  CameraStatus _status = CameraStatus.initial;
  String _errorMessage = '';
  FlashMode _flashMode = FlashMode.off;
  bool _showFrame = false;
  XXFile? _capturedImage;

  CameraController? get controller => _controller;
  CameraStatus get status => _status;
  String get errorMessage => _errorMessage;
  FlashMode get flashMode => _flashMode;
  bool get showFrame => _showFrame;
  XXFile? get capturedImage => _capturedImage;

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

  Future<void> pickImageFromGallery(NativeDeviceOrientation orientation) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final rotatedImage = await ImageUtils.rotateImageIfNecessary(
        file,
        orientation,
      );
      _capturedImage = XXFile.fromXFile(rotatedImage, orientation: orientation);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
