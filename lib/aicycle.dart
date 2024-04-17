import 'package:aicycle_buyme_lib/features/aicycle_buy_me/presentation/aicycle_buy_me.dart';
import 'package:camera/camera.dart';

import 'injection_container.dart';
export 'features/folder_details/presentation/folder_detail_page.dart';
export 'features/aicycle_buy_me/presentation/aicycle_buy_me.dart'
    hide
        apiToken,
        locale,
        environtment,
        enableVersion2,
        cameras,
        xApplication,
        savePhotoAfterShot;

class AICycle {
  static Future<void> initial({String? token}) async {
    apiToken = token;
    InjectionContainer.initial();
    cameras = await availableCameras();
  }
}
