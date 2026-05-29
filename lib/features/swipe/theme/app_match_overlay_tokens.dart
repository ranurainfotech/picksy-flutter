import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppMatchOverlayTokens {
  static const Color backdrop = Color(0xCC050816);
  static const double backdropMaxOpacity = 0.55;
  static const double blurSigma = 10;

  static const Color titleLine = Color(0xF2FFFFFF);
  static const Color matchGradientTop = Color(0xFFFF4DB8);
  static const Color matchGradientBottom = Color(0xFFFF2D8D);
  static const Color heartGradientStart = Color(0xFF7B61FF);
  static const Color heartGradientEnd = Color(0xFFFF4DB8);

  static const double artCardWidth = 145;
  static const double artCardHeight = 210;
  static const double artCardRadius = 28;

  static const double centerHeartSize = 72;
  static const double avatarSize = 52;
  static const double avatarOverlap = 18;

  static const Duration backdropDuration = Duration(milliseconds: 150);
  static const Duration titleDuration = Duration(milliseconds: 450);
  static const Duration cardsDuration = Duration(milliseconds: 500);
  static const Duration avatarPopDuration = Duration(milliseconds: 180);
  static const Duration fadeOutDuration = Duration(milliseconds: 400);

  /// Bricolage Grotesque ExtraBold Italic — match celebration headline.
  static TextStyle matchHeadlineStyle({double fontSize = 58}) {
    return GoogleFonts.bricolageGrotesque(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.italic,
      height: 0.86,
      letterSpacing: -1.2,
      color: Colors.white,
    );
  }

  static const double matchTitleSkewX = 0.07;
  static const double matchTitleRotateZ = -0.04;
}
