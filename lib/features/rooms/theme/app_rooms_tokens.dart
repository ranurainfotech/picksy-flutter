import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

abstract final class AppRoomsTokens {
  static const double headerTopPadding = 20;
  static const double createButtonSize = 44;
  static const double createButtonIconSize = 28;

  static const double listTopPadding = 17;
  static const double listBottomPadding = 22;
  static const double roomCardHeight = 112;
  static const double roomCardRadius = 17;
  static const double roomPosterSize = 84;
  static const double roomPosterRadius = 14;
  static const double roomCardBorderOpacity = 0.72;
  static const double roomCardBlurOpacity = 0.34;
  static const double roomPosterIconSize = 28;
  static const double roomPosterAmbientIconSize = 92;
  static const double roomPosterAmbientIconOffset = -18;
  static const double posterSparkleSize = 5;

  static const double avatarSize = 25;
  static const double avatarOverlap = 16;
  static const double avatarBorderWidth = 2;

  static const double chevronSize = 19;
  static const double memberCountWidth = 72;
  static const double ambientGlowSize = 230;
  static const double ambientGlowBlur = 120;
  static const double ambientGlowSpread = 18;
  static const double backgroundOrbOpacity = 0.08;
  static const double cardGlowRight = -42;
  static const double cardGlowTop = -34;
  static const double cardGlowSpread = -64;

  static const double actionSheetRadius = 30;
  static const double actionSheetBlur = 22;
  static const double actionSheetGrabberWidth = 42;
  static const double actionSheetGrabberHeight = 5;
  static const double actionTileIconBoxSize = 48;
  static const double emptyIllustrationSize = 132;
  static const double emptyIllustrationInnerSize = 94;
  static const double emptyIllustrationIconSize = 42;
  static const double lobbyPosterSize = 164;
  static const double lobbyPosterIconSize = 72;
  static const double swipePlaceholderIconSize = 76;
  static const Color actionSheetBackground = Color(0xE6111420);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF170C24), Color(0xFF0C1020), Color(0xFF05060A)],
  );

  static const LinearGradient createRoomGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.electricPurple, AppColors.like],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xF0191D2B), Color(0xF00B0F19)],
  );

  static const List<BoxShadow> createButtonShadow = [
    BoxShadow(color: AppColors.purpleGlow, blurRadius: 22, spreadRadius: 0),
  ];

  static const List<BoxShadow> roomCardShadow = [
    BoxShadow(color: AppColors.black35, blurRadius: 24, offset: Offset(0, 12)),
  ];
}
