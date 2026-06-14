import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

abstract final class AppMatchesTokens {
  static const double screenHorizontalPadding = 16;
  static const double headerTopPadding = 8;
  static const double titleSize = 40;
  static const double subtitleSize = 16;
  static const double cardHeight = 176;
  static const double cardRadius = 24;
  static const double cardImageWidth = 100;
  static const double cardImageHeight = 140;
  static const double cardImageRadius = 16;
  static const double cardGap = 12;
  static const double badgeHeight = 26;
  static const double itemTitleSize = 22;
  static const double roomContextSize = 16;
  static const double matchResultSize = 14;
  static const double timestampSize = 13;
  static const double avatarSize = 32;
  static const double avatarOverlap = 8;
  static const int feedPageSize = 20;

  static TextStyle poppinsBold({required double fontSize, Color? color}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primaryText,
      height: 1.15,
    );
  }

  static TextStyle poppinsSemiBold({required double fontSize, Color? color}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.primaryText,
      height: 1.2,
    );
  }

  static TextStyle poppinsMedium({required double fontSize, Color? color}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.primaryText,
      height: 1.25,
    );
  }

  static TextStyle poppinsRegular({required double fontSize, Color? color}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.primaryText,
      height: 1.3,
    );
  }

  static const LinearGradient cardBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF141A2B), Color(0xFF0D1220)],
  );

  static const LinearGradient perfectBadgeGradient = LinearGradient(
    colors: [Color(0xFFFF4DB8), Color(0xFFFF2D8D)],
  );

  static const LinearGradient majorityBadgeGradient = LinearGradient(
    colors: [Color(0xFF7B61FF), Color(0xFF5A45E8)],
  );

  static const LinearGradient cardBorderGradient = LinearGradient(
    colors: [Color(0x66FF4DB8), Color(0x667B61FF)],
  );

  static List<BoxShadow> get cardGlow => AppShadows.purpleGlow;
}
