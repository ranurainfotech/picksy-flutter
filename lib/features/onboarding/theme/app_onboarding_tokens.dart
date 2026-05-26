import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

abstract final class AppOnboardingTokens {
  static const String defaultNickname = 'moviebuff_07';
  static const String helperText = 'You can change this later';

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0B12), Color(0xFF090B14), Color(0xFF05060A)],
  );

  static const double ambientGlowSize = 220;
  static const double ambientGlowBlur = 110;
  static const double ambientGlowSpread = 16;
  static const double ambientGlowOpacity = 0.16;
  static const Alignment topGlowAlignment = Alignment(-0.85, -0.92);
  static const Alignment middleGlowAlignment = Alignment(0.92, -0.12);
  static const Alignment bottomGlowAlignment = Alignment(-0.70, 0.98);

  static const double inputSuffixIconSize = 20;
  static const double inputRadius = 14;
  static const int avatarGridColumns = 3;
  static const double avatarSize = 78;
  static const double avatarImagePadding = 4;
  static const double avatarGridSpacing = 12;
  static const double avatarBorderWidth = 1;
  static const double avatarSelectedBorderWidth = 2.8;
  static const double avatarCrownSize = 20;
  static const double avatarCrownOffset = -6;
  static const double avatarSelectedScale = 1.06;
  static const double avatarUnselectedScale = 1;

  static const List<Gradient> avatarGradients = [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2A2F45), Color(0xFFFF7A00)],
    ),
    AppGradients.primaryCta,
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF22283A), AppColors.neonOrange],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF22283A), AppColors.neonYellow],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF242A3E), AppColors.cyan],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2A2F45), AppColors.neonPink],
    ),
  ];
}
