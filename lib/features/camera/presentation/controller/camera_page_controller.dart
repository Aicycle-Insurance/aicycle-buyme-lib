// import 'package:aicycle_buyme_lib/enum/car_part_direction.dart';
// import 'dart:io';

// import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../common/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../../../../enum/app_state.dart';
import '../../../common/contants/direction_constant.dart';
import '../../../common/utils.dart';
// import '../../../folder_details/data/models/buy_me_image_model.dart';
import '../../../folder_details/domain/usecase/detele_image_by_id_usecase.dart';
import '../../../folder_details/presentation/widgets/controller/folder_detail_controller.dart';
import '../../data/models/damage_assessment_response.dart';
import '../../domain/usecase/call_engine_usecase.dart';
import '../../domain/usecase/upload_image_usecase.dart';
import '../camera_page.dart';

class BuyMeCameraPageController extends BuyMeBaseController {
  final BuyMeCallEngineUsecase callEngineUsecase =
      Get.find<BuyMeCallEngineUsecase>();
  final BuyMeUploadImageUsecase uploadImageToS3Server =
      Get.find<BuyMeUploadImageUsecase>();
  final BuyMeDeleteImageByIdUsecase deleteImageByIdUsecase = Get.find();
  CameraController? cameraController;
  var isInActive = false.obs;
  var showGuideFrame = true.obs;
  var flashMode = Rx<FlashMode>(FlashMode.off);
  var previewFile = Rx<XFile?>(null);
  var showRetake = false.obs;
  var showErrorDialog = false.obs;
  var isResizing = false.obs;
  var isConfidentLevelWarning = false.obs;
  var damageAssessmentResponse = Rx<DamageAssessmentResponse?>(null);
  BuyMeCameraArgument? argument;
  DamageAssessmentResponse? cacheDamageResponse;
  Map<String, dynamic> cacheValidationModel = {};
  var isFromGallery = false.obs;
  var localImageSize = Rx<Size?>(null);
  var isCameraLoading = false.obs;

  late Stream<DeviceOrientation> sensorStream;
  DeviceOrientation currentOrientation = DeviceOrientation.portraitUp;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    if (cameras.isNotEmpty) {
      onNewCameraSelected(cameras[0]);
    }
    sensorStream = accelerometerEventStream()
        .map<DeviceOrientation>(Utils.getOrientation)
        .distinct();
    sensorStream.listen((event) {
      currentOrientation = event;
    });
    super.onInit();
  }

  @override
  void onReady() {
    if (cameras.isEmpty) {
      status.value = BaseStatus(
        message: 'No camera found',
        state: AppState.pop,
      );
    }
    super.onReady();
  }

  var isPickingPhoto = false.obs;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final CameraController? cameraCtrl = cameraController;
    // App state changed before we got the chance to initialize.
    if (cameraCtrl == null || !cameraCtrl.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive && !isPickingPhoto()) {
      isInActive(true);
      cameraCtrl.dispose();
      update(['camera']);
    } else if (state == AppLifecycleState.resumed && !isPickingPhoto()) {
      isInActive(false);
      onNewCameraSelected(cameraCtrl.description);
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    isCameraLoading(true);
    final CameraController? oldController = cameraController;
    if (oldController != null) {
      cameraController = null;
      await oldController.dispose();
    }
    final CameraController cameraCtrl = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    cameraController = cameraCtrl;
    // If the controller is updated then update the UI.
    cameraCtrl.addListener(() {
      if (cameraCtrl.value.hasError) {
        status.value = BaseStatus(
          message: 'Camera error',
          state: AppState.failed,
        );
      }
    });
    try {
      await cameraCtrl.initialize();
      // if (Platform.isIOS) {
      //   cameraCtrl.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
      // }
      isCameraLoading(false);
    } on CameraException catch (_) {
      isCameraLoading(false);
      status.value = BaseStatus(
        message: 'No camera found',
        state: AppState.pop,
      );
    }
    update(['camera']);
  }

  void switchFlashMode() async {
    if (flashMode() == FlashMode.off) {
      await cameraController?.setFlashMode(FlashMode.torch);
      flashMode.value = FlashMode.torch;
    } else {
      await cameraController?.setFlashMode(FlashMode.off);
      flashMode.value = FlashMode.off;
    }
  }

  void takePhoto() async {
    int rotate = currentOrientation == DeviceOrientation.landscapeLeft
        ? -90
        : currentOrientation == DeviceOrientation.landscapeRight
            ? 90
            : 0;
    if (previewFile.value == null) {
      previewFile.value = await cameraController?.takePicture();
      await cameraController?.pausePreview();
      isFromGallery.value = false;
      if (previewFile.value != null) {
        isResizing.value = true;
        final resizeFile = await Utils.compressImageV2(
          previewFile.value!,
          100,
          // fromGallery: false,
          rotate: rotate,
          imageSizeCallBack: (p0) {
            localImageSize.value = p0;
          },
        );
        // previewFile.value = resizeFile;
        isResizing.value = false;
        callEngine(resizeFile);
      }
    } else {
      await cameraController?.resumePreview();
    }
  }

  void retakePhoto() {
    cameraController?.resumePreview();
    localImageSize.value = null;
    previewFile.value = null;
    showRetake(false);
    showErrorDialog(false);
    status(BaseStatus(message: null));
  }

  void pickedPhoto() async {
    if (previewFile.value == null) {
      isPickingPhoto(true);
      var pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      isFromGallery.value = true;
      isPickingPhoto(false);
      if (pickedFile != null) {
        previewFile.value = pickedFile;
        isResizing.value = true;
        var resizeFile = await Utils.compressImageV2(
          pickedFile,
          100,
          // fromGallery: true,
          imageSizeCallBack: (p0) {
            localImageSize.value = p0;
          },
        );
        // previewFile.value = resizeFile;
        isResizing.value = false;
        await callEngine(resizeFile);
      }
    }
  }

  Future<void> callEngine(XFile file) async {
    if (argument != null) {
      /// Tính thời gian upload
      isLoading.value = true;
      final Stopwatch timer = Stopwatch();
      timer.start();
      var uploadRes = await uploadImageToS3Server(localFilePath: file.path);
      timer.stop();
      // Kết thúc
      uploadRes.fold(
        (l) {
          isLoading(false);
          status(
            BaseStatus(
              message: l.message.toString(),
              state: AppState.customError,
            ),
          );
          showErrorDialog(true);
          showRetake(true);
        },
        (r) async {
          if (r.level == 'info' && r.filePath != null) {
            await callEngineImpl(
              localFilePath: file.path,
              serverFilePath: r.filePath!,
              timeAppUpload: timer.elapsedMilliseconds / 1000,
            );
          }

          /// warning
          else if (r.level == 'warning') {
            cacheValidationModel['localFilePath'] = file.path;
            cacheValidationModel['serverFilePath'] = r.filePath;
            cacheValidationModel['timeAppUpload'] =
                timer.elapsedMilliseconds / 1000;
            isLoading(false);
            showRetake(false);
            status(BaseStatus(
              message: r.message ?? 'Warning',
              state: AppState.warning,
            ));
          }

          /// error
          else {
            isLoading(false);
            status(BaseStatus(
              message: null,
              state: AppState.idle,
            ));
            showRetake(true);
          }
        },
      );
    }
  }

  void engineWarningHandle(String action) async {
    switch (action) {
      case 'next':
        if (cacheValidationModel['localFilePath'] != null &&
            cacheValidationModel['serverFilePath'] != null) {
          await callEngineImpl(
            localFilePath: cacheValidationModel['localFilePath'],
            serverFilePath: cacheValidationModel['serverFilePath'],
            timeAppUpload: cacheValidationModel['timeAppUpload'],
          );
        } else {
          status(
              BaseStatus(message: 'Hệ thống lỗi', state: AppState.customError));
          showErrorDialog(true);
          damageAssessmentResponse.value = null;
          previewFile.value = null;
        }
        break;
      case 'save':
        if (cacheDamageResponse != null) {
          updateDirection(cacheDamageResponse);
        }
        status(BaseStatus(message: null, state: AppState.pop));
        damageAssessmentResponse.value = cacheDamageResponse;
        break;
      case 'retake':
        cameraController?.resumePreview();
        if (status.value.state == AppState.warning &&
            cacheDamageResponse != null) {
          await deleteImageByIdUsecase(cacheDamageResponse!.imageId.toString())
              .then((value) => cacheDamageResponse = null);
        }
        localImageSize.value = null;
        previewFile.value = null;
        cacheValidationModel = {};
        status(BaseStatus(message: null, state: AppState.idle));
        damageAssessmentResponse.value = null;
        showErrorDialog(false);
        cacheDamageResponse = null;
        break;
    }
  }

  Future<void> callEngineImpl({
    required String localFilePath,
    required String serverFilePath,
    double? timeAppUpload,
  }) async {
    var callEngineRes = await callEngineUsecase(
      claimId: argument!.claimId,
      imageName: basename(localFilePath),
      filePath: serverFilePath,
      isCapDon: true,
      position: positionIds[0],
      direction: argument!.carPartDirectionEnum.excelId,
      vehiclePartExcelId: '',
      timeAppUpload: timeAppUpload,
      utcTimeCreated: DateTime.now().toUtc().toIso8601String(),
    );

    callEngineRes.fold((l) {
      isLoading(false);

      /// Code from engine
      if (l.errorCodeFromEngine != null) {
        status(
          BaseStatus(
            message: l.message.toString(),
            state: AppState.customError,
          ),
        );
        showErrorDialog(true);
        //   status(
        //     BaseStatus(
        //       message: l.message.toString(),
        //       state: AppState.customError,
        //     ),
        //   );
        //   showRetake(false);
        //   showErrorDialog(true);
        // } else {
        //   status(
        //     BaseStatus(
        //       message: l.message.toString(),
        //       state: AppState.customError,
        //     ),
        //   );
        //   showErrorDialog(true);
        //   showRetake(true);
      }
    }, (r) {
      isLoading(false);
      if (r.errorCodeFromEngine == null || r.errorCodeFromEngine == 0) {
        updateDirection(r);
        status(
          BaseStatus(
            message: null,
            state: AppState.pop,
          ),
        );
      } else {
        cacheDamageResponse = r;

        /// confident level thấp
        if (r.errorCodeFromEngine == 66616) {
          status(
            BaseStatus(
              message: r.message,
              state: AppState.warning,
            ),
          );
          showRetake(false);
          isConfidentLevelWarning(true);
        } else {
          status(
            BaseStatus(
              message: r.message,
              state: AppState.customError,
            ),
          );
          showRetake(false);
          showErrorDialog(true);
        }
      }
    });
  }

  void updateDirection(DamageAssessmentResponse? value) {
    if (Get.isRegistered<BuyMeFolderDetailController>()) {
      final folderDetailController = Get.find<BuyMeFolderDetailController>();
      folderDetailController.getImageInfo();
      // folderDetailController.damageResponseListener.value = value;
      folderDetailController.damageResponseStream.sink.add(value);
      // var images = folderDetailController.imageInfo.value?.images ?? [];
      // images.removeWhere(
      //   (element) =>
      //       element.directionSlug == argument?.carPartDirectionEnum.excelId ||
      //       element.directionId == argument?.carPartDirectionEnum.id.toString(),
      // );
      // images.add(BuyMeImage(
      //   imageId: value?.imageId?.toString(),
      //   directionId: argument?.carPartDirectionEnum.id.toString(),
      //   directionName: argument?.carPartDirectionEnum.buyMeTitle,
      //   directionSlug: value?.result?.extraInfor?.imageDirection ??
      //       argument?.carPartDirectionEnum.excelId,
      //   imageUrl: value?.result?.imgUrl,
      //   resizeImageUrl: value?.result?.imgUrl,
      //   imageSize: value?.result?.imgSize,
      // ));

      // folderDetailController.imageInfo.value =
      //     BuyMeImageResponse(images: images);
    }
  }
}
