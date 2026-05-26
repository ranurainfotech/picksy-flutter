import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../theme/app_rooms_tokens.dart';
import 'rooms_floating_action_button.dart';

class RoomsEmptyState extends StatelessWidget {
  const RoomsEmptyState({super.key, required this.onCreateRoom});

  final VoidCallback onCreateRoom;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.section),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _EmptyIllustration(),
            const SizedBox(height: AppSpacing.section),
            Text(
              'No rooms yet 👀',
              style: AppTypography.heading3.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Create a room, invite friends, and let Picksy turn group indecision into a vibe.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            AppButton.primary(
              label: 'Create Your First Room',
              icon: AppIcons.createRoom,
              onPressed: onCreateRoom,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppRoomsTokens.emptyIllustrationSize,
      height: AppRoomsTokens.emptyIllustrationSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.neonGlow,
              boxShadow: AppShadows.purpleGlow,
            ),
            child: const SizedBox.expand(),
          ),
          Container(
            width: AppRoomsTokens.emptyIllustrationInnerSize,
            height: AppRoomsTokens.emptyIllustrationInnerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBackground.withValues(alpha: 0.84),
            ),
            child: const Icon(
              AppIcons.rooms,
              color: AppColors.neonPink,
              size: AppRoomsTokens.emptyIllustrationIconSize,
            ),
          ),
          const Positioned(
            right: 5,
            top: 12,
            child: RoomsFloatingActionButton(onPressed: _noop),
          ),
        ],
      ),
    );
  }
}

void _noop() {}
