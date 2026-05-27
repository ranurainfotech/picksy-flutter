import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

abstract final class AppHomeTokens {
  static const double bottomNavHeight = 82;
  static const double bottomNavIconSize = 30;
  static const double bottomNavTopPadding = 10;
  static const double bottomNavItemGap = 5;
  static const double bottomNavBorderOpacity = 0.75;
  static const double bottomNavBlur = 22;
  static const double inactiveAlpha = 0.54;

  static const Color bottomNavBackground = Color(0xF3070910);
  static const Color bottomNavBorder = Color(0xFF23283A);

  static const List<BoxShadow> bottomNavShadow = [
    BoxShadow(color: AppColors.black35, blurRadius: 26, offset: Offset(0, -12)),
  ];

  static const List<Shadow> activeIconShadows = [
    Shadow(color: AppColors.purpleGlow, blurRadius: 18),
  ];

  static const List<Shadow> activeTextShadows = [
    Shadow(color: AppColors.purpleGlow, blurRadius: 14),
  ];
}
