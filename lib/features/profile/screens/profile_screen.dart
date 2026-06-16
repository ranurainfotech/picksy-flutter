import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_providers.dart';
import '../../subscription/exceptions/monetization_exceptions.dart';
import '../../subscription/providers/subscription_providers.dart';
import '../../subscription/widgets/pro_membership_badge.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signOutState = ref.watch(signOutProvider);
    final signOutNotifier = ref.read(signOutProvider.notifier);
    final isLoggingOut = signOutState.isLoading;
    final errorMessage = signOutState.error?.toString();
    final monetizationAsync = ref.watch(monetizationStateProvider);
    final isPro = monetizationAsync.value?.isPro ?? false;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.profile, color: AppColors.neonPink, size: 34),
            const SizedBox(height: AppSpacing.regular),
            Text('Profile', style: AppTypography.heading2),
            const SizedBox(height: AppSpacing.section),
            if (isPro) ...[
              const ProMembershipBadge(),
              const SizedBox(height: AppSpacing.regular),
              _ProMembershipCard(),
            ] else ...[
              Text(
                'Your avatar, stats, favorite genres, and achievements.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              AppButton.primary(
                label: 'Upgrade to Pro',
                onPressed: () => context.push(
                  AppRoutes.paywall,
                  extra: PaywallReason.profileUpgrade,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.section),
            AppButton.secondary(
              label: isLoggingOut ? 'Logging out...' : 'Log out',
              icon: AppIcons.logout,
              onPressed: isLoggingOut
                  ? null
                  : () async {
                      signOutNotifier.clearError();
                      final didSignOut = await signOutNotifier.signOut();

                      if (!context.mounted || !didSignOut) {
                        return;
                      }

                      context.go(AppRoutes.welcome);
                    },
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.small),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.reject),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProMembershipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.regular),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.largeBorder,
        border: Border.all(color: AppColors.activeBorder.withValues(alpha: 0.35)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.purpleGlow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You\'re on Pro',
            style: AppTypography.heading3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            'Unlimited rooms, unlimited swipes, and no ads.',
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSpacing.regular),
          const _ProBenefitRow(text: 'Unlimited active rooms'),
          const _ProBenefitRow(text: 'Unlimited daily swipes'),
          const _ProBenefitRow(text: 'Ad-free experience'),
        ],
      ),
    );
  }
}

class _ProBenefitRow extends StatelessWidget {
  const _ProBenefitRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.compact),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.neonPink, size: 18),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyRegular.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
