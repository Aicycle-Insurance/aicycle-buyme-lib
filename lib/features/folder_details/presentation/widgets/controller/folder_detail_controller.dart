import 'dart:async';

import '../../../../../enum/app_state.dart';
import '../../../../camera/data/models/damage_assessment_response.dart';
import '../../../../common/base_controller.dart';
import 'package:get/get.dart';

import '../../../data/models/buy_me_image_details.dart';
import '../../../data/models/buy_me_image_model.dart';
import '../../../data/models/check_car_model.dart';
import '../../../domain/usecase/check_is_one_car_usecase.dart';
import '../../../domain/usecase/get_image_details_usecase.dart';
import '../../../domain/usecase/get_image_info_usecase.dart';

class BuyMeFolderDetailController extends BuyMeBaseController {
  final BuyMeGetImageInfoUsecase getImageInfoUsecase = Get.find();
  final BuyMeGetImageDetailsUsecase getImageDetailsUsecase = Get.find();
  final BuyMeCheckIsOneCarUsecase checkIsOneCarUsecase = Get.find();
  var checkCarModel = Rx<CheckCarModel?>(null);
  var imageInfo = Rx<BuyMeImageResponse?>(null);
  // var damageResponseListener = Rx<DamageAssessmentResponse?>(null);

  final damageResponseStream =
      StreamController<DamageAssessmentResponse?>.broadcast();

  String? claimId;
  RxString message = ''.obs;
  final RxList<BuyMeImageDetails> imagesDetails = RxList<BuyMeImageDetails>();

  @override
  void onReady() async {
    super.onReady();
    getImageInfo();
    await getResult();
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
        status.value = BaseStatus(
            message: '${l.code.toString()}: ${l.details.toString()}',
            state: AppState.failed);
      },
      (r) {
        isLoading(false);
        imageInfo.value = r;
      },
    );
    await checkIsOneCar();
  }

  Future<void> getResult() async {
    if (imageInfo.value?.images == null || imageInfo.value!.images!.isEmpty) {
      return;
    }
    imagesDetails.clear();
    isLoading(true);
    for (BuyMeImage image in (imageInfo.value?.images ?? [])) {
      final res = await getImageDetailsUsecase(image.imageId.toString());

      res.fold(
        (l) {
          isLoading(false);
          status.value = BaseStatus(
            message: '${l.code.toString()}: ${l.details.toString()}',
            state: AppState.failed,
          );
        },
        (r) {
          imagesDetails.add(r);
        },
      );
      if (res.isLeft()) {
        break;
      }
    }
    isLoading(false);
  }

  Future<void> checkIsOneCar() async {
    final res = await checkIsOneCarUsecase(claimId!);
    res.fold(
      (l) => null,
      (r) => checkCarModel.value = r,
    );
  }
}
