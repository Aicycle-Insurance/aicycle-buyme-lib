import 'dart:io';

import 'package:aicycle_buyme_lib/features/common/extension/translation_ext.dart';
import 'package:aicycle_buyme_lib/generated/locales.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../aicycle_buyme_lib.dart';
import '../../generated/assets.gen.dart';
import 'base_controller.dart';
import 'themes/c_colors.dart';
import 'themes/c_textstyle.dart';
import 'utils.dart';

class LoadingView<T> extends StatelessWidget {
  const LoadingView({
    super.key,
    this.child,
    this.showBackground = true,
    this.color,
    this.tag,
    this.isCustomLoading = false,
    this.quarterTurns = 0,
  });
  final Widget? child;
  final bool showBackground;
  final Color? color;
  final String? tag;
  final bool isCustomLoading;
  final int quarterTurns;

  T get controller => GetInstance().find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context) {
    final loadingWidget = SizedBox.expand(
      child: Container(
        color: CColors.transparent,
        child: Center(
          child: !isCustomLoading
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: showBackground ? CColors.white : CColors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: showBackground
                        ? [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 6,
                              color: CColors.black.withOpacity(0.08),
                            )
                          ]
                        : null,
                  ),
                  child: CLoading(color: color),
                )
              : RotatedBox(
                  quarterTurns: quarterTurns,
                  child: Container(
                    height: 180,
                    width: quarterTurns == 0 || quarterTurns == 2
                        ? double.maxFinite
                        : 300,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: showBackground
                          ? const Color.fromRGBO(253, 251, 253, 1)
                          : CColors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: showBackground
                          ? [
                              BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                                color: CColors.black.withOpacity(0.08),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Assets.gif.loading.image(
                          height: 80,
                          fit: BoxFit.contain,
                          package: packageName,
                        ),
                        const Gap(8),
                        Text(
                          LocaleKeys.isProcessing.trans,
                          style: CTextStyles.base.s14.w500(),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        if (child != null) child!,
        if (Get.isRegistered<T>(tag: tag) &&
            (controller is BuyMeBaseController))
          Obx(() {
            if ((controller as BuyMeBaseController).isLoading.value) {
              Utils.dismissKeyboard();
              return loadingWidget;
            }
            return const SizedBox.shrink();
          })
        else
          loadingWidget
      ],
    );
  }
}

class CLoading extends StatelessWidget {
  const CLoading({
    super.key,
    this.color,
    this.size = 28,
    this.strokeWidth = 3,
    this.isAndroid = false,
  });

  final Color? color;
  final double size;
  final double strokeWidth;
  final bool isAndroid;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: Platform.isAndroid || isAndroid
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? CColors.primaryA500,
                  ),
                ),
              )
            : CupertinoActivityIndicator(
                animating: true,
                radius: 12,
                color: color ?? CColors.inkA400,
              ),
      ),
    );
  }
}
