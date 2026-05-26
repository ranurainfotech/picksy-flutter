import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../models/room_preview.dart';
import '../providers/rooms_provider.dart';
import '../theme/app_rooms_tokens.dart';
import '../widgets/room_card.dart';
import '../widgets/rooms_empty_state.dart';
import '../widgets/rooms_floating_action_button.dart';

class RoomsScreen extends ConsumerWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsState = ref.watch(roomsProvider);

    return _RoomsBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppRoomsTokens.headerTopPadding,
            AppSpacing.screenPadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _RoomsHeader(),
              const SizedBox(height: AppRoomsTokens.listTopPadding),
              Expanded(
                child: roomsState.when(
                  data: (rooms) {
                    if (rooms.isEmpty) {
                      return RoomsEmptyState(
                        onCreateRoom: () =>
                            context.go(AppRoutes.createJoinRoom),
                      );
                    }

                    return _RoomsList(rooms: rooms);
                  },
                  loading: () => const _RoomsLoadingState(),
                  error: (error, stackTrace) => _RoomsErrorState(
                    onRetry: () => ref.invalidate(roomsProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomsLoadingState extends StatelessWidget {
  const _RoomsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.neonPink),
    );
  }
}

class _RoomsErrorState extends StatelessWidget {
  const _RoomsErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.section),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Could not load rooms', style: AppTypography.heading3),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            AppButton.secondary(label: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _RoomsBackground extends StatelessWidget {
  const _RoomsBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppRoomsTokens.backgroundGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AmbientRoomGlow(
            alignment: Alignment(-0.92, -0.88),
            color: AppColors.electricPurple,
          ),
          const _AmbientRoomGlow(
            alignment: Alignment(0.94, -0.18),
            color: AppColors.cyan,
          ),
          const _AmbientRoomGlow(
            alignment: Alignment(-0.72, 0.98),
            color: AppColors.neonPink,
          ),
          child,
        ],
      ),
    );
  }
}

class _AmbientRoomGlow extends StatelessWidget {
  const _AmbientRoomGlow({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: AppRoomsTokens.ambientGlowSize,
          height: AppRoomsTokens.ambientGlowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(
                  alpha: AppRoomsTokens.backgroundOrbOpacity,
                ),
                blurRadius: AppRoomsTokens.ambientGlowBlur,
                spreadRadius: AppRoomsTokens.ambientGlowSpread,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomsHeader extends StatelessWidget {
  const _RoomsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Your Rooms',
            style: AppTypography.heading2.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.regular),
        RoomsFloatingActionButton(
          onPressed: () => context.go(AppRoutes.createJoinRoom),
        ),
      ],
    );
  }
}

class _RoomsList extends StatelessWidget {
  const _RoomsList({required this.rooms});

  final List<RoomPreview> rooms;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppRoomsTokens.listBottomPadding),
      physics: const BouncingScrollPhysics(),
      itemCount: rooms.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.compact),
      itemBuilder: (context, index) {
        final room = rooms[index];

        return RoomCard(
              room: room,
              onTap: () => context.go(AppRoutes.roomLobby(room.id)),
            )
            .animate()
            .fadeIn(delay: (60 * index).ms, duration: 300.ms)
            .slideX(begin: 0.08, curve: Curves.easeOutCubic);
      },
    );
  }
}
