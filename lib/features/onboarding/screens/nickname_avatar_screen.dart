import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../models/avatar_option.dart';
import '../providers/onboarding_profile_provider.dart';
import '../theme/app_onboarding_tokens.dart';
import '../widgets/avatar_choice_grid.dart';
import '../widgets/nickname_input.dart';
import '../widgets/onboarding_background.dart';

class NicknameAvatarScreen extends ConsumerWidget {
  const NicknameAvatarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(onboardingProfileProvider);
    final submitState = ref.watch(onboardingSubmitProvider);
    final profileNotifier = ref.read(onboardingProfileProvider.notifier);
    final submitNotifier = ref.read(onboardingSubmitProvider.notifier);
    final errorMessage = submitState.error?.toString();
    final isSubmitting = submitState.isLoading;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: OnboardingBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.section,
                AppSpacing.screenPadding,
                AppSpacing.section,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's your\nvibe name? 😎",
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.18),
                  const SizedBox(height: AppSpacing.medium),
                  NicknameInput(
                        initialValue: profile.nickname,
                        onChanged: (nickname) {
                          profileNotifier.updateNickname(nickname);
                          submitNotifier.clearError();
                        },
                      )
                      .animate()
                      .fadeIn(delay: 80.ms, duration: 320.ms)
                      .slideY(begin: 0.16),
                  if (errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      errorMessage,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.reject,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.section),
                  Text(
                    'Pick an avatar',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.regular),
                  AvatarChoiceGrid(
                    options: AvatarOptions.all,
                    selectedAvatarId: profile.selectedAvatarId,
                    onAvatarSelected: (avatarId) {
                      profileNotifier.selectAvatar(avatarId);
                      submitNotifier.clearError();
                    },
                  ).animate().fadeIn(delay: 160.ms, duration: 360.ms),
                  const Spacer(),
                  AppButton.primary(
                        label: isSubmitting
                            ? 'Creating your vibe...'
                            : "Let's Go",
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                final didComplete = await submitNotifier
                                    .submit();

                                if (!context.mounted || !didComplete) {
                                  return;
                                }

                                context.go(AppRoutes.home);
                              },
                      )
                      .animate()
                      .fadeIn(delay: 260.ms, duration: 360.ms)
                      .slideY(begin: 0.24, curve: Curves.easeOutCubic),
                  const SizedBox(height: AppSpacing.compact),
                  Center(
                    child: Text(
                      AppOnboardingTokens.helperText,
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
