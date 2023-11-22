import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../common/base_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../../../../enum/app_state.dart';
import '../../../common/contants/direction_constant.dart';
import '../../../common/utils.dart';
import '../../../folder_details/controller/folder_detail_controller.dart';
import '../../data/models/damage_assessment_response.dart';
import '../../domain/usecase/call_engine_usecase.dart';
import '../../domain/usecase/upload_image_usecase.dart';
import '../camera_page.dart';

class CameraPageController extends BaseController {
  final CallEngineUsecase callEngineUsecase = Get.find<CallEngineUsecase>();
  final UploadImageUsecase uploadImageToS3Server =
      Get.find<UploadImageUsecase>();
  CameraController? cameraController;
  var isInActive = false.obs;
  var showGuideFrame = true.obs;
  var flashMode = Rx<FlashMode>(FlashMode.off);
  var previewFile = Rx<XFile?>(null);
  var showRetake = false.obs;
  var showErrorDialog = false.obs;
  var isResizing = false.obs;
  var isConfidentLevelWarning = false.obs;
  BuyMeCameraArgument? argument;
  DamageAssessmentResponse? cacheDamageResponse;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    if (cameras.isNotEmpty) {
      onNewCameraSelected(cameras[0]);
    }
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final CameraController? cameraCtrl = cameraController;
    // App state changed before we got the chance to initialize.
    if (cameraCtrl == null || !cameraCtrl.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      isInActive(true);
      cameraCtrl.dispose();
      update(['camera']);
    } else if (state == AppLifecycleState.resumed) {
      isInActive(false);
      onNewCameraSelected(cameraCtrl.description);
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    isLoading(true);
    final CameraController? oldController = cameraController;
    if (oldController != null) {
      cameraController = null;
      await oldController.dispose();
    }
    final CameraController cameraCtrl = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: false,
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
      if (Platform.isIOS) {
        cameraCtrl.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
      }
      isLoading(false);
    } on CameraException catch (_) {
      isLoading(false);
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
    if (previewFile.value == null) {
      previewFile.value = await cameraController?.takePicture();
      if (previewFile.value != null) {
        isResizing(true);
        var resizeFile = await Utils.compressImage(previewFile.value!, 100);
        previewFile.value = resizeFile;
        isResizing(false);
        callEngine();
      }
    }
  }

  void retakePhoto() {
    previewFile(null);
    showRetake(false);
    status(BaseStatus(message: null));
  }

  void pickedPhoto() async {
    if (previewFile() == null) {
      previewFile.value = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (previewFile.value != null) {
        isResizing(true);
        var resizeFile = await Utils.compressImage(previewFile.value!, 100);
        previewFile.value = resizeFile;
        isResizing(false);
        callEngine();
      }
    }
  }

  void callEngine() async {
    if (previewFile() != null && argument != null) {
      /// Tính thời gian upload
      isLoading(true);
      final Stopwatch timer = Stopwatch();
      timer.start();
      var uploadRes =
          await uploadImageToS3Server(localFilePath: previewFile()!.path);
      timer.stop();
      // Kết thúc
      uploadRes.fold(
        (l) {
          status(
            BaseStatus(
              message: l.message.toString(),
              state: AppState.failed,
            ),
          );
          isLoading(false);
        },
        (r) async {
          if (r.level == 'info' && r.filePath != null) {
            var callEngineRes = await callEngineUsecase(
              claimId: argument!.claimId,
              imageName: basename(previewFile()!.path),
              filePath: r.filePath!,
              isCapDon: true,
              position: positionIds[0],
              direction: argument!.carPartDirectionEnum.excelId,
              vehiclePartExcelId: '',
              timeAppUpload: timer.elapsedMilliseconds / 1000,
              utcTimeCreated: DateTime.now().toUtc().toIso8601String(),
            );

            callEngineRes.fold((l) {
              isLoading(false);

              /// Code from engine
              if (l.errorCodeFromEngine != null) {
                status(
                  BaseStatus(
                    message: l.message.toString(),
                    state: AppState.failed,
                  ),
                );
                showRetake(false);
                showErrorDialog(true);
              } else {
                status(
                  BaseStatus(
                    message: l.message.toString(),
                    state: AppState.failed,
                  ),
                );
                showRetake(true);
              }
            }, (r) {
              isLoading(false);
              if (r.errorCodeFromEngine == null || r.errorCodeFromEngine == 0) {
                // getIt<EventBus>().fire(CallEngineEvent());
                // getIt<EventBus>().fire(
                //   BuyMeCallEngineEvent(
                //     imageModel: ImageModel(
                //       imageId: r.imageId?.toString(),
                //       directionId: state.argument?.carPartDirectionEnum.id.toString(),
                //       directionName: state.argument?.carPartDirectionEnum.title,
                //       imageUrl: r.result?.imgUrl,
                //       resizeImageUrl: r.result?.imgUrl,
                //       imageSize: r.result?.imgSize?.map((e) => e ?? 0).toList(),
                //       directionSlug: r.result?.extraInfor?.imageDirection,
                //     ),
                //   ),
                // );
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
                      state: AppState.warning,
                    ),
                  );
                  showRetake(false);
                }
              }
            });
          }

          /// warning
          else if (r.level == 'warning') {
            isLoading(false);
            status(BaseStatus(
              message: r.message,
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
}