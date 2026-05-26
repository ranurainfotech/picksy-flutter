import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppOnboardingTokens.backgroundGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AmbientGlow(
            alignment: AppOnboardingTokens.topGlowAlignment,
            color: AppColors.electricPurple,
          ),
          const _AmbientGlow(
            alignment: AppOnboardingTokens.bottomGlowAlignment,
            color: AppColors.neonPink,
          ),
          child,
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: AppOnboardingTokens.ambientGlowSize,
          height: AppOnboardingTokens.ambientGlowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: AppOnboardingTokens.ambientGlowOpacity),
                blurRadius: AppOnboardingTokens.ambientGlowBlur,
                spreadRadius: AppOnboardingTokens.ambientGlowSpread,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
