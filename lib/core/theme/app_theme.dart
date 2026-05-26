import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.electricPurple,
      primary: AppColors.electricPurple,
      secondary: AppColors.neonPink,
      surface: AppColors.cardBackground,
      error: AppColors.reject,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTypography.primaryFont,
      scaffoldBackgroundColor: AppColors.primaryBackground,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.neonPink,
        scaffoldBackgroundColor: AppColors.primaryBackground,
        textTheme: CupertinoTextThemeData(
          primaryColor: AppColors.primaryText,
          textStyle: AppTypography.bodyRegular,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primaryText,
        titleTextStyle: AppTypography.heading3,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bottomNavBackground,
        selectedItemColor: AppColors.bottomNavActive,
        unselectedItemColor: AppColors.bottomNavInactive,
        selectedLabelStyle: AppTypography.tiny,
        unselectedLabelStyle: AppTypography.tiny,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        shadowColor: AppColors.black35,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeBorder),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.elevatedCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.regular,
          vertical: AppSpacing.compact,
        ),
        hintStyle: AppTypography.bodyRegular.copyWith(
          color: AppColors.tertiaryText,
        ),
        labelStyle: AppTypography.bodyRegular.copyWith(
          color: AppColors.secondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mediumBorder,
          borderSide: const BorderSide(color: AppColors.primaryBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumBorder,
          borderSide: const BorderSide(color: AppColors.primaryBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumBorder,
          borderSide: const BorderSide(color: AppColors.activeBorder),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryText,
        size: AppSpacing.icon,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.elevatedCard,
        selectedColor: AppColors.electricPurple,
        disabledColor: AppColors.cardBackground,
        side: const BorderSide(color: AppColors.primaryBorder),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumBorder),
        labelStyle: AppTypography.caption,
        secondaryLabelStyle: AppTypography.caption.copyWith(
          color: AppColors.primaryText,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.compact),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
