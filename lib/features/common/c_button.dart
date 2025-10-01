import './themes/c_colors.dart';
import './themes/c_textstyle.dart';
import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? backgroundColor;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final bool isDisable;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? textColor;
  final bool? isOutlined;
  const CButton({
    super.key,
    required this.onPressed,
    this.textColor,
    this.textStyle,
    this.trailingIcon,
    this.leadingIcon,
    this.isDisable = false,
    this.horizontalPadding,
    this.verticalPadding,
    this.backgroundColor = CColors.primaryA500,
    this.borderRadius,
    required this.title,
    this.width,
    this.isOutlined,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisable ? null : onPressed,
      style: (isOutlined ?? false)
          ? OutlinedButton.styleFrom(
              side: const BorderSide(color: CColors.primaryA500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
              padding: EdgeInsets.zero,
            )
          : ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                isDisable ? CColors.inkA200 : backgroundColor,
              ),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 8),
                ),
              ),
            ),
      child: Container(
        height: height,
        width: width ?? double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0,
          vertical: verticalPadding ?? 14,
        ),
        child: Center(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: leadingIcon ?? const SizedBox.shrink(),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    textStyle?.copyWith(color: textColor) ??
                    CTextStyles.base.s16.copyWith(
                      color: (isOutlined ?? false)
                          ? CColors.primaryA500
                          : CColors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: trailingIcon ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CButton2 extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? backgroundColor;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final bool isDisable;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? textColor;
  final bool? isOutlined;
  const CButton2({
    super.key,
    required this.onPressed,
    this.textColor,
    this.textStyle,
    this.trailingIcon,
    this.leadingIcon,
    this.isDisable = false,
    this.horizontalPadding,
    this.verticalPadding,
    this.backgroundColor = CColors.primaryA500,
    this.borderRadius,
    required this.title,
    this.width,
    this.isOutlined,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisable ? null : onPressed,
      style: (isOutlined ?? false)
          ? OutlinedButton.styleFrom(
              side: const BorderSide(color: CColors.primaryA500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
              padding: EdgeInsets.zero,
            )
          : ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                isDisable ? CColors.inkA200 : backgroundColor,
              ),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 8),
                ),
              ),
            ),
      child: Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0,
          vertical: verticalPadding ?? 14,
        ),
        child: Center(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: leadingIcon ?? const SizedBox.shrink(),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    textStyle?.copyWith(color: textColor) ??
                    CTextStyles.base.s16.w500().setColor(
                      (isOutlined ?? false)
                          ? CColors.primaryA500
                          : CColors.white,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: trailingIcon ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
