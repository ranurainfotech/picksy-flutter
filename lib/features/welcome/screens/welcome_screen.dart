import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../theme/app_welcome_tokens.dart';
import '../widgets/welcome_background.dart';
import '../widgets/welcome_hero_art.dart';
import '../widgets/welcome_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: WelcomeBackground(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.compact,
                AppSpacing.screenPadding,
                AppSpacing.section,
              ),
              child: _WelcomeContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

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
              const WelcomeLogo(),
              const SizedBox(height: AppSpacing.medium),
              RichText(
                    text: TextSpan(
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.primaryText,
                        height: AppWelcomeTokens.taglineLineHeight,
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
                  .slideY(begin: AppWelcomeTokens.taglineSlideStart),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        const WelcomeHeroArt(),
        const Spacer(flex: 3),
        AppButton.primary(
          label: 'Get Started',
          onPressed: () => context.go(AppRoutes.onboarding),
        ),
      ],
    );
  }
}
