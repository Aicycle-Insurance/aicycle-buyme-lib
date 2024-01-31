// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

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
import '../data/models/buy_me_image_model.dart';
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
  });
  // final String claimFolderId;
  // final String externalClaimId;
  final bool? hasAppBar;
  final Function(List<BuyMeImage>? images)? onViewResultCallBack;
  final Function(DamageAssessmentResponse?)? onCallEngineSuccessfully;
  final AiCycleBuyMeArgument argument;

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState
    extends BaseState<FolderDetailPage, FolderDetailController> {
  late final StreamSubscription _callEngineSub;

  @override
  FolderDetailController provideController() {
    if (Get.isRegistered<FolderDetailController>()) {
      return Get.find<FolderDetailController>();
    } else {
      return Get.put(FolderDetailController());
    }
  }

  @override
  void initState() {
    super.initState();
    apiToken = widget.argument.apiToken;
    environtment = widget.argument.environtment ?? Evn.production;
    locale = widget.argument.locale;
    controller.claimId =
        widget.argument.aicycleClaimId ?? widget.argument.externalClaimId;
    _callEngineSub = controller.damageResponseStream.stream.listen((p0) {
      if (p0 != null) {
        widget.onCallEngineSuccessfully?.call(p0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _callEngineSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: (widget.hasAppBar ?? true)
          ? AppBar(
              backgroundColor: CColors.white,
              elevation: 0.7,
            )
          : null,
      body: LoadingView<FolderDetailController>(
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
                      if (controller.checkCarModel() != null) {
                        return IsOneCarWidget(
                          checkCarModel: controller.checkCarModel(),
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
                                  ),
                                  CarPosition(
                                    claimFolderId:
                                        widget.argument.aicycleClaimId ??
                                            widget.argument.externalClaimId,
                                    direction:
                                        CarPartDirectionEnum.d45RightBack,
                                    images: controller.imageInfo.value?.images,
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
                () => CButton(
                  isDisable:
                      controller.imageInfo.value?.images?.isNotEmpty != true,
                  onPressed: () {
                    widget.onViewResultCallBack
                        ?.call(controller.imageInfo.value?.images);
                    // Navigator.pop(context);
                  },
                  title: LocaleKeys.viewResult.trans,
                ),
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
