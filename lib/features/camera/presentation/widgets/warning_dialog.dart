import 'package:aicycle_buyme_lib/aicycle_buyme_lib.dart';
import 'package:aicycle_buyme_lib/generated/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../generated/locales.g.dart';
import '../../../common/c_button.dart';
import '../../../common/themes/c_colors.dart';
import '../../../common/extension/translation_ext.dart';
import '../../../common/themes/c_textstyle.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({
    super.key,
    required this.description,
    this.leftButtonText,
    this.showRight = true,
    this.leftPressed,
    this.rightPressed,
  });
  final String description;
  final String? leftButtonText;
  final bool showRight;
  final Function()? leftPressed;
  final Function()? rightPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CColors.white,
      ),
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.icWarning.svg(
            package: packageName,
            width: 40,
            height: 40,
            color: CColors.redA500,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: CTextStyles.base.s14.blackColor.w300(),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
          const Gap(20),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: CButton2(
                    isOutlined: true,
                    verticalPadding: 0,
                    title: leftButtonText ?? LocaleKeys.next.trans,
                    onPressed: leftPressed,
                    borderRadius: 6,
                    textColor: CColors.primaryA500,
                    textStyle: CTextStyles.base.s14.primaryColor,
                  ),
                ),
                if (showRight) ...[
                  const Gap(16),
                  Expanded(
                    child: CButton2(
                      verticalPadding: 0,
                      title: LocaleKeys.retake.trans,
                      onPressed: rightPressed,
                      borderRadius: 6,
                      textStyle: CTextStyles.base.s14.whiteColor.w300(),
                    ),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
