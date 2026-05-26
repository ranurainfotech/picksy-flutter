import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppGradients {
  static const LinearGradient primaryCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.electricPurple, AppColors.neonPink],
  );

  static LinearGradient primaryCtaFlow(double progress) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const [
        AppColors.electricPurple,
        AppColors.softPurple,
        AppColors.neonPink,
        AppColors.softPurple,
        AppColors.electricPurple,
      ],
      stops: const [0, 0.24, 0.50, 0.76, 1],
      tileMode: TileMode.repeated,
      transform: _SlidingGradientTransform(progress),
    );
  }

  static const LinearGradient match = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.neonPink, Color(0xFF9D4EDD), AppColors.electricPurple],
  );

  static const LinearGradient neonGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xE6FF2DAF), Color(0xE67B2EFF)],
  );

  static const LinearGradient darkSurface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F111A), Color(0xFF161B29)],
  );

  static const LinearGradient swipeCardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x6606070B),
      AppColors.primaryBackground,
    ],
    stops: [0.35, 0.65, 1],
  );

  static const LinearGradient selectedChip = primaryCta;

  static const LinearGradient avatarBorder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.neonPink, AppColors.softPurple, AppColors.cyan],
  );
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.progress);

  final double progress;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * progress, 0, 0);
  }
}
