import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../models/room_preview.dart';
import '../providers/rooms_provider.dart';
import '../theme/app_rooms_tokens.dart';
import '../widgets/member_avatar_stack.dart';

class RoomLobbyScreen extends ConsumerWidget {
  const RoomLobbyScreen({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomPreviewProvider(roomId));

    if (room == null) {
      final remoteRoom = ref.watch(remoteRoomProvider(roomId));

      return remoteRoom.when(
        data: (data) {
          if (data == null) {
            return const _MissingRoomView();
          }

          return _LobbyScaffold(
            room: RoomPreview.fromRoomData(roomId: roomId, data: data),
          );
        },
        loading: () => const _LobbyLoadingView(),
        error: (error, stackTrace) => const _MissingRoomView(),
      );
    }

    return _LobbyScaffold(room: room);
  }
}

class _LobbyScaffold extends StatelessWidget {
  const _LobbyScaffold({required this.room});

  final RoomPreview room;

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => context.go(AppRoutes.home),
                    icon: const Icon(
                      AppIcons.chevronLeft,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const Spacer(),
                _LobbyPoster(room: room),
                const SizedBox(height: AppSpacing.section),
                Text(
                  '${room.title} ${room.emoji}',
                  textAlign: TextAlign.center,
                  style: AppTypography.heading2.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  '${room.category} • ${room.membersCount} members ready',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.regular),
                Center(
                  child: MemberAvatarStack(assetPaths: room.avatarAssetPaths),
                ),
                const Spacer(),
                AppButton.primary(
                  label: 'Start Swiping',
                  icon: AppIcons.fastAction,
                  onPressed: () => context.go(AppRoutes.roomSwipe(room.id)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LobbyPoster extends StatelessWidget {
  const _LobbyPoster({required this.room});

  final RoomPreview room;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppRoomsTokens.lobbyPosterSize,
        height: AppRoomsTokens.lobbyPosterSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: room.posterColors,
          ),
          borderRadius: AppRadius.xlBorder,
          boxShadow: AppShadows.purpleGlow,
        ),
        child: Icon(
          room.posterIcon,
          color: AppColors.primaryText,
          size: AppRoomsTokens.lobbyPosterIconSize,
        ),
      ),
    );
  }
}

class _MissingRoomView extends StatelessWidget {
  const _MissingRoomView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppRoomsTokens.backgroundGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Room not found', style: AppTypography.heading3),
                const SizedBox(height: AppSpacing.regular),
                AppButton.secondary(
                  label: 'Back to Rooms',
                  onPressed: () => context.go(AppRoutes.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LobbyLoadingView extends StatelessWidget {
  const _LobbyLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: AppRoomsTokens.backgroundGradient),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.neonPink),
        ),
      ),
    );
  }
}
