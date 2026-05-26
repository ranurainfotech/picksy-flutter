import 'package:flutter/material.dart';

abstract final class AppCreateJoinRoomTokens {
  static const double topPadding = 42;
  static const double horizontalPadding = 20;
  static const double headingFontSize = 32;
  static const double headingLineHeight = 1.1;
  static const double headingBottomGap = 24;
  static const double categoryHeight = 72;
  static const double categoryRadius = 22;
  static const double categoryIconSize = 26;
  static const double categoryGap = 14;
  static const double joinSectionTopGap = 36;
  static const double selectedBorderWidth = 1.2;
  static const double selectionIndicatorSize = 24;
  static const double selectionCheckSize = 18;
  static const double joinLabelBottomGap = 12;
  static const double joinInputHeight = 56;
  static const double joinInputRadius = 18;
  static const double joinButtonHorizontalPadding = 22;
  static const double dividerLabelGap = 14;
  static const double dividerVerticalMargin = 28;
  static const double createButtonHeight = 60;
  static const double createButtonRadius = 22;
  static const double buttonPressedScale = 0.97;
  static const double ambientGlowSize = 240;
  static const double ambientGlowBlur = 128;
  static const double ambientGlowSpread = 18;
  static const double ambientGlowOpacity = 0.13;

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0B12), Color(0xFF090B14), Color(0xFF05060A)],
  );

  static const LinearGradient selectedCategoryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7B2EFF), Color(0xFFFF2DAF)],
  );

  static const LinearGradient joinButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7B2EFF), Color(0xFFFF2DAF)],
  );

  static const LinearGradient createRoomGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7B2EFF), Color(0xFFFF2DAF)],
  );

  static const Color categoryBackground = Color(0xFF121624);
  static const Color inputBackground = Color(0xFF121624);
  static const Color glowPurple = Color(0x59B026FF);
  static const Color glowPink = Color(0x59FF2DAF);

  static const List<BoxShadow> selectedCategoryShadow = [
    BoxShadow(color: glowPurple, blurRadius: 24),
  ];

  static const List<BoxShadow> buttonPurpleGlow = [
    BoxShadow(color: glowPurple, blurRadius: 24),
  ];

  static const List<BoxShadow> createButtonGlow = [
    BoxShadow(color: glowPink, blurRadius: 32),
  ];
}
