import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_design_system.dart';

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
          clipBehavior: Clip.none,
          children: [
            RichText(
              text: TextSpan(
                style: AppTypography.displayLarge.copyWith(
                  fontSize: AppWelcomeTokens.logoFontSize,
                  height: AppWelcomeTokens.logoLineHeight,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  letterSpacing: AppWelcomeTokens.logoLetterSpacing,
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
              top: AppWelcomeTokens.lightningTop,
              right: AppWelcomeTokens.lightningRight,
              child:
                  const Icon(
                        AppIcons.fastAction,
                        color: AppColors.neonYellow,
                        size: AppWelcomeTokens.lightningSize,
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
        .slideY(begin: AppWelcomeTokens.logoSlideStart, end: 0);
  }
}
