// ignore_for_file: deprecated_member_use_from_same_package

import 'package:aicycle_buyme_lib/aicycle_buyme_lib.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';

import '../../../../generated/assets.gen.dart';
import '../../../../generated/locales.g.dart';
import '../../../common/c_button.dart';
import '../../../common/themes/c_colors.dart';
import '../../../common/extension/translation_ext.dart';
import '../../../common/themes/c_textstyle.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.description,
    this.subDescription,
    this.retake,
  });
  final String description;
  final String? subDescription;
  final Function()? retake;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width - 40,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Assets.icons.icWarningFilled.svg(
              package: packageName,
              color: CColors.redA400,
              height: 48,
              width: 48,
            ),
            const Gap(10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: CTextStyles.base.s14.w700(),
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(4),
            if (subDescription != null) ...[
              ReadMoreText(
                subDescription ?? "",
                textAlign: TextAlign.center,
                style: CTextStyles.base.s12.w300(),
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: LocaleKeys.readMore.trans,
                trimExpandedText: LocaleKeys.showLess.trans,
                // overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            CButton2(
              isOutlined: false,
              verticalPadding: 0,
              title: LocaleKeys.retake.trans,
              height: 40,
              onPressed: retake,
              borderRadius: 6,
              textColor: CColors.white,
              textStyle: CTextStyles.base.s14.w400(),
            ),
          ],
        ),
      ),
    );
  }
}
