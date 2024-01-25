import 'package:get/get.dart';

import '../../../enum/app_state.dart';
import '../../common/base_controller.dart';
import '../data/model/claim_folder_model.dart';
import '../domain/usecase/create_folder_usecase.dart';
import '../domain/usecase/get_duplicate_folder_usecase.dart';
import 'aicycle_buy_me.dart';

class AiCycleBuyMeController extends BaseController {
  final CreateFolderUsecase createFolderUsecase = Get.find();
  final GetDuplicateFolderUsecase getDuplicateFolderUsecase = Get.find();
  late AiCycleBuyMeArgument argument;
  var claimFolder = Rx<ClaimFolderModel?>(null);

  @override
  void onReady() {
    super.onReady();
    createFolder();
  }

  void createFolder() async {
    isLoading(true);
    final res = await createFolderUsecase(
      externalClaimId: argument.externalClaimId,
      folderName: 'Pjico - ${argument.externalClaimId}',
      appUser: null,
      carColor: null,
      hasLicensePlate: true,
      isClaim: false,
      parentId: null,
      vehicleBrandId: '5',
      vehicleLicensePlates: '',
    );

    res.fold(
      (l) {
        if (l.details.toString().toLowerCase().contains('duplicate')) {
          getDuplicateFolder();
        } else {
          isLoading(false);
          status.value = BaseStatus(
            message: l.message,
            state: AppState.pop,
          );
        }
      },
      (r) {
        argument = AiCycleBuyMeArgument(
          externalClaimId: argument.externalClaimId,
          apiToken: argument.apiToken,
          aicycleClaimId: r.claimId,
          environtment: argument.environtment,
          locale: argument.locale,
        );
        isLoading(false);
        status.value = BaseStatus(
          message: null,
          state: AppState.redirect,
        );
        claimFolder.value = r;
      },
    );
  }

  void getDuplicateFolder() async {
    var res = await getDuplicateFolderUsecase(
        externalClaimId: argument.externalClaimId);
    res.fold(
      (l) {
        isLoading(false);
        status.value = BaseStatus(
          message: l.message,
          state: AppState.pop,
        );
      },
      (r) {
        argument = AiCycleBuyMeArgument(
          externalClaimId: argument.externalClaimId,
          apiToken: argument.apiToken,
          aicycleClaimId: r.claimId,
          environtment: argument.environtment,
          locale: argument.locale,
        );
        isLoading(false);
        status.value = BaseStatus(
          message: null,
          state: AppState.redirect,
        );
        claimFolder.value = r;
      },
    );
  }
}
