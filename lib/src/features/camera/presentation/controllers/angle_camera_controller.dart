import 'package:aicycle_buyme_plus/src/core/utils/image_utils.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

enum AngleCameraStatus { initial, initializing, ready, error }

class AngleCameraController extends ChangeNotifier {
  CameraController? _controller;
  AngleCameraStatus _status = AngleCameraStatus.initial;
  String _errorMessage = '';
  FlashMode _flashMode = FlashMode.off;
  bool _showFrame = false;

  CameraController? get controller => _controller;
  AngleCameraStatus get status => _status;
  String get errorMessage => _errorMessage;
  FlashMode get flashMode => _flashMode;
  bool get showFrame => _showFrame;

  Future<void> initialize() async {
    try {
      _status = AngleCameraStatus.initializing;
      notifyListeners();

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _status = AngleCameraStatus.error;
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

      _status = AngleCameraStatus.ready;
      notifyListeners();
    } catch (e) {
      _status = AngleCameraStatus.error;
      _errorMessage = 'Camera initialization failed: $e';
      notifyListeners();
    }
  }

  Future<XFile?> takePicture(NativeDeviceOrientation orientation) async {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    if (_controller!.value.isTakingPicture) return null;

    try {
      final XFile rawImage = await _controller!.takePicture();

      return await ImageUtils.rotateImageIfNecessary(rawImage, orientation);
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return null;
    }
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
