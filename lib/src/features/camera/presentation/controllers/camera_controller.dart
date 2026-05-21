import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
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

/// Trạng thái hoạt động của Camera.
enum CameraStatus {
  /// Trạng thái ban đầu, chưa khởi tạo.
  initial,

  /// Đang trong quá trình khởi tạo camera.
  initializing,

  /// Camera đã sẵn sàng sử dụng.
  ready,

  /// Đã xảy ra lỗi trong quá trình khởi tạo hoặc hoạt động.
  error,
}

/// Controller quản lý luồng hoạt động, xử lý trạng thái và upload ảnh của Camera.
class XCameraController extends ChangeNotifier {
  /// Hàm khởi tạo [XCameraController] với góc chụp xe xác định.
  XCameraController({required this.angle});

  /// Góc chụp hiện tại của xe (ví dụ: trước, sườn trái, đăng kiểm...).
  final AicycleCarAngle angle;

  /// Controller điều khiển camera thuộc thư viện camera chính thức của Flutter.
  CameraController? _controller;

  /// Trạng thái hoạt động hiện tại của camera.
  CameraStatus _status = CameraStatus.initial;

  /// Thông báo lỗi khi xảy ra sự cố trong quá trình khởi tạo hoặc xử lý camera.
  String _errorMessage = '';

  /// Chế độ đèn flash hiện tại của camera (mặc định là tắt).
  FlashMode _flashMode = FlashMode.off;

  /// Xác định xem có hiển thị khung hướng dẫn chụp ảnh trên màn hình hay không.
  bool _showFrame = true;

  /// Tệp ảnh đã chụp thành công và đang chờ xử lý hoặc upload.
  XXFile? _capturedImage;

  /// Xác định xem ảnh hiện tại có phải được chọn từ thư viện (gallery) hay không.
  bool _isPickedFromGallery = false;

  /// Trạng thái đang thực hiện tải (upload) ảnh lên máy chủ.
  bool _isUploading = false;

  /// Danh sách các ảnh đăng kiểm đã chụp (luồng đăng kiểm cần chụp cả mặt trước và mặt sau).
  final List<XXFile> _regCertImages = [];

  /// Dữ liệu kết quả giám định xe được tạm lưu khi gặp cảnh báo (warning) từ engine.
  UploadVehicleInspection? _warningResultCached;

  /// Dữ liệu kết quả đăng kiểm được tạm lưu khi gặp cảnh báo (warning) từ engine.
  CertUploadEntity? _warningCertCached;

  /// Danh sách các mã lỗi từ Engine được coi là cảnh báo (warning) thay vì lỗi nghiêm trọng.
  static const List<int> warningEngineCodes = [
    23212,
    77704,
    60006,
    60007,
    66616,
  ];

  /// Lấy [CameraController] để hiển thị giao diện xem trước (CameraPreview).
  CameraController? get controller => _controller;

  /// Lấy trạng thái hiện tại của camera.
  CameraStatus get status => _status;

  /// Lấy thông báo lỗi hiện tại (nếu có).
  String get errorMessage => _errorMessage;

  /// Lấy chế độ đèn flash hiện tại.
  FlashMode get flashMode => _flashMode;

  /// Lấy trạng thái hiển thị của khung hướng dẫn chụp.
  bool get showFrame => _showFrame;

  /// Lấy tệp ảnh đã chụp thành công.
  XXFile? get capturedImage => _capturedImage;

  /// Kiểm tra xem camera có đang thực hiện upload ảnh lên server hay không.
  bool get isUploading => _isUploading;

  /// Lấy danh sách các ảnh đăng kiểm đã được chụp.
  List<XXFile> get regCertImages => _regCertImages;

  /// Kiểm tra xem góc chụp hiện tại có phải là góc chụp đăng kiểm (regCert) hay không.
  bool get isRegCert => angle == AicycleCarAngle.regCert;

  /// Lấy chuỗi hướng dẫn tương ứng cho luồng chụp ảnh đăng kiểm.
  String get regCertInstruction {
    if (!isRegCert) return angle.title;
    if (_regCertImages.isEmpty) return AppStrings.captureFrontRegCert;
    if (_regCertImages.length == 1) return AppStrings.captureRearRegCert;
    return angle.title;
  }

  /// Khởi tạo camera.
  /// Lấy danh sách các camera khả dụng, ưu tiên chọn camera sau,
  /// cấu hình chất lượng hình ảnh, và thiết lập chế độ đèn flash ban đầu là tắt.
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

  /// Thực hiện chụp ảnh dựa trên hướng xoay hiện tại của thiết bị.
  /// Nếu cần thiết, bức ảnh sẽ được tự động xoay về hướng chuẩn trước khi lưu trữ.
  Future<void> takePicture(NativeDeviceOrientation orientation) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final XFile rawImage = await _controller!.takePicture();

      final rotatedImage = await ImageUtils.rotateImageIfNecessary(
        rawImage,
        orientation,
      );

      _isPickedFromGallery = false;
      _capturedImage = XXFile.fromXFile(rotatedImage, orientation: orientation);
      notifyListeners();
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  /// Thiết lập tệp ảnh đã chụp từ bên ngoài và thông báo cho giao diện cập nhật.
  void setCapturedImage(XXFile image) {
    _capturedImage = image;
    notifyListeners();
  }

  /// Chụp lại (reset ảnh đã chụp).
  /// Đối với luồng chụp đăng kiểm, nếu ảnh đã chụp nằm trong danh sách đăng kiểm thì cũng loại bỏ ảnh này.
  void retake() {
    if (isRegCert) {
      if (_capturedImage != null && _regCertImages.contains(_capturedImage!)) {
        _regCertImages.remove(_capturedImage!);
      }
    }
    _capturedImage = null;
    notifyListeners();
  }

  /// Xoá ảnh đăng kiểm cụ thể ra khỏi danh sách ảnh đã chụp.
  void discardRegCertImage(XXFile image) {
    _regCertImages.removeWhere((e) => e.path == image.path);
    notifyListeners();
  }

  /// Chuyển đổi chế độ bật/tắt của đèn flash camera.
  Future<void> toggleFlash() async {
    if (_controller == null) return;

    final modes = [FlashMode.off, FlashMode.always];
    final currentIndex = modes.indexOf(_flashMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    _flashMode = modes[nextIndex];

    await _controller!.setFlashMode(_flashMode);
    notifyListeners();
  }

  /// Chuyển đổi trạng thái hiển thị của khung hướng dẫn chụp ảnh trên màn hình.
  void toggleFrame() {
    _showFrame = !_showFrame;
    notifyListeners();
  }

  /// Chọn một ảnh từ thư viện hình ảnh của thiết bị làm ảnh đã chụp.
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _isPickedFromGallery = true;
      _capturedImage = XXFile.fromXFile(
        file,
        orientation: NativeDeviceOrientation.landscapeLeft,
      );
      notifyListeners();
    }
  }

  /// Thực hiện upload ảnh lên server.
  /// Hỗ trợ cả luồng upload ảnh đăng kiểm (cần tối thiểu 2 ảnh) và ảnh giám định xe thông thường.
  /// Gọi các callback [onSuccess], [onWarning] hoặc [onError] tùy thuộc vào kết quả xử lý.
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
          onSuccess: () async {
            await _savePictureToGallery();
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
          onSuccess: () async {
            await _savePictureToGallery();
            onSuccess();
          },
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

  Future<void> _savePictureToGallery() async {
    // Lưu ảnh vào thư viện ảnh nếu được cấu hình và ảnh chụp từ camera
    if (AiCycleBuyMe.config.generalConfig.saveToGalleryAfterCapture &&
        !_isPickedFromGallery) {
      try {
        if (isRegCert) {
          for (final img in _regCertImages) {
            await GallerySaver.saveImage(img.path);
          }
        } else {
          await GallerySaver.saveImage(_capturedImage!.path);
        }
      } catch (e) {
        debugPrint('Failed to save to gallery: $e');
      }
    }
  }

  /// Xử lý kết quả upload dựa trên mức độ lỗi (ErrorLevel) để gọi các callback tương ứng.
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

  /// Tiếp tục lưu trữ và đồng bộ sau khi người dùng xác nhận bỏ qua cảnh báo từ Engine.
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
    _savePictureToGallery();
    notifyListeners();
  }

  /// Chụp lại sau khi nhận được cảnh báo từ Engine.
  /// Bỏ qua dữ liệu cache cũ và đưa camera về chế độ sẵn sàng chụp lại.
  Future<void> onWarningRetake() async {
    // Do đã upload => khi retake cần xoá trên server
    _setUploading(true);
    try {
      final imageId = isRegCert
          ? _warningCertCached?.imageId
          : _warningResultCached?.imageId;
      if (imageId != null) {
        await sl.vehicleImageVault.deleteImageById(imageId);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _setUploading(false);
    }

    /// Xoá ảnh local cache
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

  /// Cập nhật trạng thái đang upload và thông báo cho giao diện người dùng.
  void _setUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  /// Upload ảnh đăng kiểm (regCert) lên máy chủ sau khi đã nén.
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

  /// Upload ảnh giám định thông thường lên máy chủ sau khi đã nén.
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

  /// Thêm danh sách ảnh đăng kiểm đã được upload thành công từ máy chủ vào kho lưu trữ hình ảnh của xe.
  void _addCertToVault(CertUploadEntity result) {
    if (result.imgUrls == null) return;
    sl.vehicleImageVault.addImagesFromServer(
      AicycleCarAngle.regCert,
      result.imgUrls!
          .map((e) => DirectionalImage(imageId: result.imageId, imageUrl: e))
          .toList(),
    );
  }

  /// Thêm ảnh giám định xe đã được upload thành công từ máy chủ vào kho lưu trữ hình ảnh của xe.
  void _addRegularToVault(UploadVehicleInspection result) {
    if (result.imgUrl == null) return;
    sl.vehicleImageVault.addImagesFromServer(result.angleFromEngine ?? angle, [
      DirectionalImage(imageId: result.imageId, imageUrl: result.imgUrl),
    ]);
  }

  /// Giải phóng tài nguyên [CameraController] khi controller này bị hủy.
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
