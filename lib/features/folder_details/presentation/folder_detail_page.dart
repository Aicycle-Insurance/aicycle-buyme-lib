// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:aicycle_buyme_lib/enum/car_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../aicycle_buyme_lib.dart';
import '../../../enum/car_part_direction.dart';
import '../../../generated/assets.gen.dart';
import '../../../generated/locales.g.dart';
import '../../aicycle_buy_me/presentation/aicycle_buy_me.dart';
import '../../camera/data/models/damage_assessment_response.dart';
import '../../common/base_widget.dart';
import '../../common/extension/translation_ext.dart';
import '../../common/c_button.dart';
import '../../common/c_loading_view.dart';
import '../../common/themes/c_colors.dart';
import 'widgets/controller/folder_detail_controller.dart';
import 'widgets/car_position.dart';
import 'widgets/is_one_car_widget.dart';

class FolderDetailPage extends StatefulWidget {
  const FolderDetailPage({
    super.key,
    this.onViewResultCallBack,
    this.hasAppBar,
    this.onCallEngineSuccessfully,
    required this.argument,
    this.onError,
  });
  // final String claimFolderId;
  // final String externalClaimId;
  final bool? hasAppBar;
  final Function(Map<String, dynamic> result)? onViewResultCallBack;
  final Function(dynamic error)? onError;
  final Function(DamageAssessmentResponse?)? onCallEngineSuccessfully;
  final AiCycleBuyMeArgument argument;

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState
    extends BaseState<FolderDetailPage, BuyMeFolderDetailController> {
  late final StreamSubscription _callEngineSub;
  late final StreamSubscription _errorSub;

  @override
  BuyMeFolderDetailController provideController() {
    if (Get.isRegistered<BuyMeFolderDetailController>()) {
      return Get.find<BuyMeFolderDetailController>();
    } else {
      return Get.put(BuyMeFolderDetailController());
    }
  }

  @override
  void initState() {
    super.initState();
    apiToken = widget.argument.apiToken;
    xApplication = widget.argument.xApplication;
    environtment = widget.argument.environtment ?? Evn.production;
    enableVersion2 = widget.argument.enableVersion2 ?? true;
    locale = widget.argument.locale;
    controller.claimId =
        widget.argument.aicycleClaimId ?? widget.argument.externalClaimId;

    ///
    _callEngineSub = controller.damageResponseStream.stream.listen((p0) {
      if (p0 != null) {
        widget.onCallEngineSuccessfully?.call(p0);
      }
    });
    _errorSub = controller.receiveErrorStream.stream.listen((p0) {
      if (p0 != null) {
        widget.onError?.call(p0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _callEngineSub.cancel();
    _errorSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    savePhotoAfterShot = widget.argument.savePhotoAfterShot;
    super.build(context);
    return Scaffold(
      appBar: (widget.hasAppBar ?? true)
          ? AppBar(
              backgroundColor: CColors.white,
              elevation: 0.7,
            )
          : null,
      body: LoadingView<BuyMeFolderDetailController>(
        isCustomLoading: true,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(32),

                    /// Check car
                    Obx(() {
                      if (controller.message.value.isNotEmpty ||
                          controller.checkCarModel() != null) {
                        return IsOneCarWidget(
                          checkCarModel: controller.checkCarModel(),
                          message: controller.message.value,
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    Container(
                      height: 500,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: Assets.images.car.image(
                              package: packageName,
                              height: 167,
                              width: 113,
                            ),
                          ),

                          /// 2 Góc sau
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CarPosition(
                                    claimFolderId:
                                        widget.argument.aicycleClaimId ??
                                            widget.argument.externalClaimId,
                                    direction: CarPartDirectionEnum.d45LeftBack,
                                    images: controller.imageInfo.value?.images,
                                    carModelEnum: CarModelEnum.fromId(
                                        widget.argument.vehicleTypeId),
                                  ),
                                  CarPosition(
                                    claimFolderId:
                                        widget.argument.aicycleClaimId ??
                                            widget.argument.externalClaimId,
                                    direction:
                                        CarPartDirectionEnum.d45RightBack,
                                    images: controller.imageInfo.value?.images,
                                    carModelEnum: CarModelEnum.fromId(
                                        widget.argument.vehicleTypeId),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// Tem đăng kiểm
                          Positioned(
                            left: 0,
                            child: Obx(
                              () => CarPosition(
                                claimFolderId: widget.argument.aicycleClaimId ??
                                    widget.argument.externalClaimId,
                                images: controller.imageInfo.value?.images,
                                direction: CarPartDirectionEnum.leftProd,
                                carModelEnum: CarModelEnum.fromId(
                                    widget.argument.vehicleTypeId),
                              ),
                            ),
                          ),

                          /// trước trái
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Obx(
                              () => CarPosition(
                                claimFolderId: widget.argument.aicycleClaimId ??
                                    widget.argument.externalClaimId,
                                images: controller.imageInfo.value?.images,
                                direction: CarPartDirectionEnum.d45LeftFront,
                                carModelEnum: CarModelEnum.fromId(
                                    widget.argument.vehicleTypeId),
                              ),
                            ),
                          ),

                          /// Trước phải
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Obx(
                              () => CarPosition(
                                claimFolderId: widget.argument.aicycleClaimId ??
                                    widget.argument.externalClaimId,
                                images: controller.imageInfo.value?.images,
                                direction: CarPartDirectionEnum.d45RightFront,
                                carModelEnum: CarModelEnum.fromId(
                                    widget.argument.vehicleTypeId),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// button
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 32,
              ),
              decoration: const BoxDecoration(color: Colors.white),
              child: Obx(
                () {
                  bool isDisable = false;
                  if (controller.imageInfo.value != null) {
                    if (controller.imageInfo.value!.images == null ||
                        controller.imageInfo.value!.images!.isEmpty) {
                      isDisable = true;
                    }
                  } else {
                    isDisable = true;
                  }
                  return CButton(
                    isDisable: isDisable,
                    onPressed: () {
                      controller.getResult().then((value) {
                        final imagesJson = List.from(controller.imagesDetails
                            .map((element) => element.toJson())
                            .toList());
                        final Map<String, dynamic> result = {
                          'results': imagesJson,
                          'itemsCount': controller.imagesDetails.length
                        };
                        widget.onViewResultCallBack?.call(result);
                      });
                    },
                    title: LocaleKeys.viewResult.trans,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
