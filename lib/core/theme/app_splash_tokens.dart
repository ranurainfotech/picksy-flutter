import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppSplashTokens {
  static const double logoFontSize = 76;
  static const double logoLineHeight = 1;
  static const double logoLetterSpacing = -3.6;
  static const double lightningSize = 22;
  static const double lightningTop = -10;
  static const double lightningRight = -18;

  static const double taglineLineHeight = 1.18;
  static const double taglineSlideStart = 0.18;
  static const double logoSlideStart = 0.12;
  static const double ctaSlideStart = 0.35;

  static const double heroHeight = 260;
  static const double assetFloatDistance = 8;
  static const double assetRotationDrift = 0.035;
  static const double assetScaleDrift = 0.025;

  static const SplashAssetSpec film = SplashAssetSpec(
    assetPath: 'assets/film.png',
    width: 126,
    left: -4,
    top: 18,
    angle: -0.22,
    duration: Duration(milliseconds: 2100),
  );

  static const SplashAssetSpec popcorn = SplashAssetSpec(
    assetPath: 'assets/popcorn.png',
    width: 146,
    right: -4,
    top: 6,
    angle: 0.12,
    duration: Duration(milliseconds: 2400),
    phase: math.pi / 2,
  );

  static const SplashAssetSpec console = SplashAssetSpec(
    assetPath: 'assets/console.png',
    width: 168,
    left: 56,
    bottom: 4,
    angle: 0.06,
    duration: Duration(milliseconds: 2600),
    phase: math.pi,
  );

  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.25,
    colors: [Color(0x332B126D), AppColors.primaryBackground],
  );

  static const double ambientGlowSize = 220;
  static const double ambientGlowBlur = 120;
  static const double ambientGlowSpread = 24;
  static const double ambientGlowOpacity = 0.20;

  static const List<SplashStarSpec> stars = [
    SplashStarSpec(0.16, 0.20, 2.0, AppColors.softPurple),
    SplashStarSpec(0.76, 0.17, 1.8, AppColors.neonYellow),
    SplashStarSpec(0.86, 0.31, 1.6, AppColors.neonPink),
    SplashStarSpec(0.24, 0.49, 1.8, AppColors.neonPink),
    SplashStarSpec(0.70, 0.52, 2.2, AppColors.softPurple),
    SplashStarSpec(0.13, 0.72, 1.4, AppColors.electricPurple),
    SplashStarSpec(0.82, 0.76, 2.0, AppColors.neonPink),
    SplashStarSpec(0.35, 0.84, 1.4, AppColors.cyan),
  ];

  static const double starOpacity = 0.78;
  static const double starStrokeWidth = 1.4;
}

class SplashAssetSpec {
  const SplashAssetSpec({
    required this.assetPath,
    required this.width,
    required this.angle,
    required this.duration,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.phase = 0,
  });

  final String assetPath;
  final double width;
  final double angle;
  final Duration duration;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double phase;
}

class SplashStarSpec {
  const SplashStarSpec(this.x, this.y, this.radius, this.color);

  final double x;
  final double y;
  final double radius;
  final Color color;
}
