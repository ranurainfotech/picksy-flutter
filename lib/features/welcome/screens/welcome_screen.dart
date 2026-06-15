import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_design_system.dart';
import '../../auth/providers/auth_providers.dart';
import '../theme/app_welcome_tokens.dart';
import '../widgets/welcome_background.dart';
import '../widgets/welcome_hero_art.dart';
import '../widgets/welcome_logo.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(googleSignInActionProvider);
    final signInNotifier = ref.read(googleSignInActionProvider.notifier);
    final isSigningIn = signInState.isLoading;
    final errorMessage = signInState.error?.toString();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: WelcomeBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.compact,
                AppSpacing.screenPadding,
                AppSpacing.section,
              ),
              child: Column(
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
                            .slideY(
                              begin: AppWelcomeTokens.taglineSlideStart,
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  const WelcomeHeroArt(),
                  const Spacer(flex: 3),
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.reject,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                  ],
                  AppButton.secondary(
                    label: isSigningIn
                        ? 'Signing in...'
                        : 'Continue with Google',
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: isSigningIn
                        ? null
                        : () async {
                            signInNotifier.clearError();
                            await signInNotifier.signIn();
                          },
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  Center(
                    child: Text(
                      'Sign in to keep your rooms, matches, and profile.',
                      textAlign: TextAlign.center,
                      style: AppTypography.tiny.copyWith(
                        color: AppColors.tertiaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
