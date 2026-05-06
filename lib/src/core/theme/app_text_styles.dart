import 'package:flutter/material.dart';
import '../utils/screen_utils.dart';
import 'app_colors.dart';

/// Standard typography for the SDK.
///
/// We recommend using absolute font sizes depending on your SDK's requirement,
/// but ideally you check `Theme.of(context).textTheme` first to blend in with the Host App.
/// These act as fallbacks if the host app's theme doesn't fit well.
class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Inter';

  /// Use for large Page Headers (e.g. Hướng dẫn chụp xe)
  static TextStyle get heading1 => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Use for Card/Section Titles (e.g. Ảnh đăng kiểm)
  static TextStyle get heading2 => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Standard Body Text
  static TextStyle get body => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 20 / 14,
  );

  /// Secondary/Hint Text (e.g. descriptions under cards)
  static TextStyle get bodySecondary => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 20 / 14,
  );

  /// Button Text
  static TextStyle get button => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Guideline Heading (Vị trí, Yêu cầu)
  static TextStyle get headingSemiBold => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF1F2738),
    height: 20 / 14,
  );

  /// Guideline Body (Description text)
  static TextStyle get bodyRegular => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF1F2738),
    height: 20 / 14,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1F2738),
    height: 20 / 14,
  );

  static TextStyle get bodySemibold => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF1F2738),
    height: 20 / 14,
  );

  /// Small links (e.g. Hướng dẫn >)
  static TextStyle get link => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 20 / 12,
  );

  static TextStyle get body12Light => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    color: const Color(0xFF1F2738),
    height: 16 / 12,
  );

  static TextStyle get body12Regular => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF1F2738),
    height: 16 / 12,
  );

  static TextStyle get body12Medium => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1F2738),
    height: 16 / 12,
  );

  static TextStyle get body10Regular => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF7B8090),
    height: 2,
  );

  static TextStyle get body8Regular => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 8.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF7B8090),
    height: 12 / 8,
  );
}
