import 'dart:async';

import '../../../../../enum/app_state.dart';
import '../../../../camera/data/models/damage_assessment_response.dart';
import '../../../../common/base_controller.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

import '../../../data/models/buy_me_image_model.dart';
import '../../../data/models/check_car_model.dart';
import '../../../domain/usecase/check_is_one_car_usecase.dart';
import '../../../domain/usecase/get_image_info_usecase.dart';

List<CameraDescription> cameras = <CameraDescription>[];

class FolderDetailController extends BaseController {
  final GetImageInfoUsecase getImageInfoUsecase = Get.find();
  final CheckIsOneCarUsecase checkIsOneCarUsecase = Get.find();
  var checkCarModel = Rx<CheckCarModel?>(null);
  var imageInfo = Rx<BuyMeImageResponse?>(null);
  // var damageResponseListener = Rx<DamageAssessmentResponse?>(null);

  final damageResponseStream =
      StreamController<DamageAssessmentResponse?>.broadcast();

  String? claimId;

  @override
  void onReady() {
    super.onReady();
    getImageInfo();
  }

  @override
  void onClose() {
    damageResponseStream.close();
    super.onClose();
  }

  void getImageInfo() async {
    if (claimId == null) {
      return;
    }
    isLoading(true);
    final res = await getImageInfoUsecase(claimId!);
    res.fold(
      (l) {
        isLoading(false);
        status.value = BaseStatus(message: l.message, state: AppState.failed);
      },
      (r) {
        isLoading(false);
        imageInfo.value = r;
      },
    );
    await checkIsOneCar();
  }

  Future<void> checkIsOneCar() async {
    final res = await checkIsOneCarUsecase(claimId!);
    res.fold(
      (l) => null,
      (r) => checkCarModel.value = r,
    );
  }
}
