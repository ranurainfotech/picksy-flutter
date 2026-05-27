import 'package:flutter/material.dart';

abstract final class AppCreateRoomDetailsTokens {
  // Layout
  static const double horizontalPadding = 24;
  static const double topBarTopMargin = 12;
  static const double topBarBottomMargin = 28;

  // Top bar
  static const double backButtonSize = 48;
  static const double backButtonRadius = 16;
  static const Color backButtonBackground = Color(0xFF111522);
  static const Color backButtonBorder = Color(0xFF232938);

  // Hero
  static const double heroFontSize = 22;
  static const double heroLineHeight = 1.0;
  static const double heroBottomGap = 14;
  static const double subtitleFontSize = 15;
  static const double subtitleBottomGap = 36;

  // Room name
  static const double roomNameLabelBottomGap = 14;
  static const double roomNameFieldHeight = 46;
  static const double roomNameFieldRadius = 14;
  static const Color roomNameBackground = Color(0xFF0F1320);
  static const Color roomNameBorder = Color(0xFFB026FF);
  static const Color roomNameBorderAlt = Color(0xFFFF2DAF);
  static const Color roomNameFocusGlow = Color(0xFFB026FF);
  static const double roomNameFieldBottomGap = 34;

  // Mood
  static const double moodTitleFontSize = 18;
  static const double moodTitleBottomGap = 18;
  static const double moodChipHeight = 40;
  static const double moodChipRadius = 12;
  static const double moodGridHorizontalGap = 12;
  static const double moodGridVerticalGap = 14;
  static const Color moodChipBackground = Color(0xFF111522);
  static const Color moodChipBorder = Color(0xFF232938);
  static const double moodSectionBottomGap = 36;

  // Filters
  static const double filtersHeaderBottomGap = 18;
  static const double filterCardRadius = 26;
  static const Color filterCardBackground = Color(0xFF0F1320);
  static const Color filterCardBorder = Color(0xFF1E2534);
  static const double filterCardPadding = 20;
  static const double filterCardGap = 16;
  static const double filterChipHeight = 34;
  static const double filterChipRadius = 12;
  static const double filterChipGap = 10;
  static const Color filterChipUnselected = Color(0xFF141A28);

  // Slider
  static const double sliderMin = 1;
  static const double sliderMax = 10;
  static const double sliderTrackHeight = 6;
  static const double sliderThumbSize = 26;

  // CTA
  static const double ctaHeight = 66;
  static const double ctaRadius = 24;
  static const double ctaBottomMargin = 24;
  static const double ctaFontSize = 22;

  // Ambient
  static const double ambientGlowSize = 220;
  static const double ambientGlowBlur = 100;
  static const double ambientGlowOpacity = 0.1;

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF090B14), Color(0xFF070A12), Color(0xFF05060B)],
  );

  /// "tonight?" — dark pink left → light pink right.
  static const LinearGradient heroHighlightGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFB83278),
      Color(0xFFFF2DAF),
      Color(0xFFFF8AD8),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient selectedChipGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7B2EFF), Color(0xFFFF2DAF)],
  );

  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7B2EFF), Color(0xFFFF2DAF)],
  );
}
