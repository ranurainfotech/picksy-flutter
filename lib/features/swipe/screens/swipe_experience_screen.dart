import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../home/theme/app_home_tokens.dart';
import '../../rooms/providers/rooms_provider.dart';
import '../../rooms/theme/app_rooms_tokens.dart';

class SwipeExperienceScreen extends ConsumerWidget {
  const SwipeExperienceScreen({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomPreviewProvider(roomId));

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppRoomsTokens.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.go(AppRoutes.roomLobby(roomId)),
                    icon: const Icon(
                      AppIcons.chevronLeft,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  AppIcons.fastAction,
                  color: AppColors.neonPink,
                  size: AppRoomsTokens.swipePlaceholderIconSize,
                  shadows: AppHomeTokens.activeIconShadows,
                ),
                const SizedBox(height: AppSpacing.section),
                Text(
                  room == null ? 'Swipe Experience' : '${room.title} picks',
                  textAlign: TextAlign.center,
                  style: AppTypography.heading2.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  'The card-swipe decision flow starts here.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
