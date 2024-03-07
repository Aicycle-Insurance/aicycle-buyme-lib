import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../aicycle_buyme_lib.dart';
import '../../../enum/app_state.dart';
import '../../../generated/assets.gen.dart';
import '../../../generated/locales.g.dart';
import '../../common/base_widget.dart';
import '../../common/themes/c_colors.dart';
import '../../common/themes/c_textstyle.dart';
import '../../folder_details/presentation/folder_detail_page.dart';
import '../../common/extension/translation_ext.dart';
import 'aicycle_buy_me_controller.dart';

enum Evn {
  dev,
  stage,
  production,
}

String? apiToken;
Evn environtment = Evn.production;
Locale? locale;
bool? enableVersion2 = true;
List<CameraDescription> cameras = <CameraDescription>[];

class AiCycleBuyMeArgument {
  final String externalClaimId;
  final String apiToken;
  final Evn? environtment;
  final Locale? locale;
  final String? aicycleClaimId;
  final bool? enableVersion2;

  AiCycleBuyMeArgument({
    required this.externalClaimId,
    required this.apiToken,
    this.environtment,
    this.locale,
    this.aicycleClaimId,
    this.enableVersion2,
  });
}

class AiCycleBuyMe extends StatefulWidget {
  const AiCycleBuyMe({
    super.key,
    required this.argument,
    required this.onViewResultCallBack,
  });
  final AiCycleBuyMeArgument argument;
  final Function(Map<String, dynamic>? imagesResult) onViewResultCallBack;

  @override
  State<AiCycleBuyMe> createState() => _AiCycleBuyMeState();
}

class _AiCycleBuyMeState
    extends BaseState<AiCycleBuyMe, AiCycleBuyMeController> {
  @override
  AiCycleBuyMeController provideController() {
    if (Get.isRegistered<AiCycleBuyMeController>()) {
      return Get.find<AiCycleBuyMeController>();
    }
    return Get.put(AiCycleBuyMeController());
  }

  @override
  void initState() {
    super.initState();
    controller.argument = widget.argument;
    apiToken = widget.argument.apiToken;
    environtment = widget.argument.environtment ?? Evn.production;
    enableVersion2 = widget.argument.enableVersion2 ?? true;
    locale = widget.argument.locale;
    controller.status.listen((state) {
      if (state.state == AppState.redirect) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => FolderDetailPage(
              argument: controller.argument,
              onViewResultCallBack: widget.onViewResultCallBack,
              onCallEngineSuccessfully: (p0) {},
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CColors.primaryA400,
              CColors.primaryA500,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.logo.image(
              package: packageName,
              width: 300,
            ),
            const Gap(24),
            Text(
              LocaleKeys.pleaseWait.trans,
              style: CTextStyles.base.s16.whiteColor,
            ),
            const Gap(12),
            SizedBox(
              width: 240,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(2),
                color: CColors.active,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
