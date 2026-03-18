import 'package:flutter/material.dart';

/// Predefined colors for the SDK design system.
///
/// If SDK users need to override these, consider exposing them
/// through `AiCycleConfig`.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary palette
  static const Color primary = Color(0xFF5768FF);
  static const Color primaryDark = Color(0xFF1E63C4);
  static const Color primaryLight = Color(0xFFE5EFFB);
  static const Color black = Color(0xFF000000);

  // Background and Surface
  static const Color background = Color(0xFFF9F9F9);
  static const Color surface = Colors.white; // Background of Cards/Containers
  static const Color backgroundGray = Color(0xFFFAFAFA);
  static const Color backgroundError = Color(0xFFFEE4E2);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2738); // Main headings/text
  static const Color textSecondary = Color(0xFF6C757D); // Subtitles, hints
  static const Color textDisabled = Color(0xFFADB5BD);

  static const Color iconGray = Color(0xFFA4A7AE);

  // State Colors
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFF04438);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // Borders & Dividers
  static const Color border = Color(0xFFDEE2E6);
  static const Color divider = Color(0xFFE9ECEF);
  static const Color borderGray = Color(0xFFD5D7DA);

  static const Color shadowLight = Color(0xFF00001A);

  static const Color ink2 = Color(0xFF6D7280);
}
