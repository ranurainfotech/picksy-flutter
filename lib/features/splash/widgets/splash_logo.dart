import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_design_system.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
          clipBehavior: Clip.none,
          children: [
            RichText(
              text: TextSpan(
                style: AppTypography.displayLarge.copyWith(
                  fontSize: AppSplashTokens.logoFontSize,
                  height: AppSplashTokens.logoLineHeight,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  letterSpacing: AppSplashTokens.logoLetterSpacing,
                  shadows: AppShadows.elevated,
                ),
                children: const [
                  TextSpan(text: 'pick'),
                  TextSpan(
                    text: 'sy',
                    style: TextStyle(color: AppColors.neonPink),
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppSplashTokens.lightningTop,
              right: AppSplashTokens.lightningRight,
              child:
                  const Icon(
                        AppIcons.fastAction,
                        color: AppColors.neonYellow,
                        size: AppSplashTokens.lightningSize,
                      )
                      .animate(delay: 300.ms)
                      .scale(
                        begin: const Offset(0.72, 0.72),
                        end: const Offset(1.08, 1.08),
                        duration: 360.ms,
                        curve: Curves.easeOutBack,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.08, 1.08),
                        end: const Offset(1, 1),
                        duration: 160.ms,
                      ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 420.ms)
        .slideY(begin: AppSplashTokens.logoSlideStart, end: 0);
  }
}
