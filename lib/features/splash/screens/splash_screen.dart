import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_design_system.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_hero_art.dart';
import '../widgets/splash_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SplashBackground(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.compact,
                AppSpacing.screenPadding,
                AppSpacing.section,
              ),
              child: _SplashContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(flex: 2),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SplashLogo(),
              const SizedBox(height: AppSpacing.medium),
              RichText(
                    text: TextSpan(
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.primaryText,
                        height: AppSplashTokens.taglineLineHeight,
                      ),
                      children: const [
                        TextSpan(text: "Can't decide?\n"),
                        TextSpan(text: "Let's decide "),
                        TextSpan(
                          text: 'together.',
                          style: TextStyle(
                            color: AppColors.neonPink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 180.ms, duration: 420.ms)
                  .slideY(begin: AppSplashTokens.taglineSlideStart),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        const SplashHeroArt(),
        const Spacer(flex: 3),
        AppButton.primary(label: 'Get Started', onPressed: () {})
            .animate()
            .fadeIn(delay: 520.ms, duration: 420.ms)
            .slideY(
              begin: AppSplashTokens.ctaSlideStart,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }
}
