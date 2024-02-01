import 'features/aicycle_buy_me/data/repository/aicycle_buy_me_repository_impl.dart';
import 'features/aicycle_buy_me/domain/usecase/create_folder_usecase.dart';
import 'features/aicycle_buy_me/domain/usecase/get_duplicate_folder_usecase.dart';
import 'features/folder_details/data/repository/folder_detail_repository_impl.dart';
import 'features/folder_details/domain/usecase/check_is_one_car_usecase.dart';
import 'features/folder_details/domain/usecase/detele_image_by_id_usecase.dart';
import 'features/folder_details/domain/usecase/get_image_info_usecase.dart';
import 'package:get/get.dart';

import 'features/camera/data/repository/camera_repository_impl.dart';
import 'features/camera/domain/usecase/upload_image_usecase.dart';
import 'features/camera/domain/usecase/call_engine_usecase.dart';

class InjectionContainer {
  InjectionContainer._();

  static initial() {
    _camera();
    _folderDetail();
    _folder();
  }

  static void _folderDetail() {
    Get.lazyPut(
      () => BuyMeFolderDetailRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut(
      () =>
          BuyMeGetImageInfoUsecase(Get.find<BuyMeFolderDetailRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut(
      () => BuyMeDeleteImageByIdUsecase(
          Get.find<BuyMeFolderDetailRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut(
      () => BuyMeCheckIsOneCarUsecase(
          Get.find<BuyMeFolderDetailRepositoryImpl>()),
      fenix: true,
    );
  }

  static void _camera() {
    Get.lazyPut(
      () => BuyMeCameraRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut(
      () => BuyMeCallEngineUsecase(Get.find<BuyMeCameraRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut(
      () => BuyMeUploadImageUsecase(Get.find<BuyMeCameraRepositoryImpl>()),
      fenix: true,
    );
  }

  static void _folder() {
    Get.lazyPut(
      () => AicycleBuyMeRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut(
      () => BuyMeCreateFolderUsecase(Get.find<AicycleBuyMeRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut(
      () => BuyMeGetDuplicateFolderUsecase(
          Get.find<AicycleBuyMeRepositoryImpl>()),
      fenix: true,
    );
  }
}
