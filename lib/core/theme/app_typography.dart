import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const String primaryFont = 'Satoshi';
  static const List<String> fallbackFonts = [
    'Inter',
    'SF Pro Display',
    'Roboto',
  ];

  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 42,
    height: 48 / 42,
    fontWeight: FontWeight.w900,
    letterSpacing: -1,
    color: AppColors.primaryText,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 34,
    height: 40 / 34,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );

  static const TextStyle button = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );

  static const TextStyle tiny = TextStyle(
    fontFamily: primaryFont,
    fontFamilyFallback: fallbackFonts,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w500,
    color: AppColors.tertiaryText,
  );

  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    headlineLarge: heading1,
    headlineMedium: heading2,
    headlineSmall: heading3,
    titleLarge: bodyLarge,
    titleMedium: bodyRegular,
    bodyLarge: bodyLarge,
    bodyMedium: bodyRegular,
    bodySmall: caption,
    labelLarge: button,
    labelMedium: caption,
    labelSmall: tiny,
  );
}
