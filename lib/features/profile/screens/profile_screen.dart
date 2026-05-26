import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signOutState = ref.watch(signOutProvider);
    final signOutNotifier = ref.read(signOutProvider.notifier);
    final isLoggingOut = signOutState.isLoading;
    final errorMessage = signOutState.error?.toString();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.profile, color: AppColors.neonPink, size: 34),
            const SizedBox(height: AppSpacing.regular),
            Text('Profile', style: AppTypography.heading2),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Your avatar, stats, favorite genres, and achievements.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
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
