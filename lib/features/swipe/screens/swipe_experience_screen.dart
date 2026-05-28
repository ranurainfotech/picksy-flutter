import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../home/theme/app_home_tokens.dart';
import '../../movies/presentation/providers/room_discover_movies_provider.dart';
import '../../rooms/theme/app_rooms_tokens.dart';

class SwipeExperienceScreen extends ConsumerWidget {
  const SwipeExperienceScreen({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoverMoviesAsync = ref.watch(roomDiscoverMoviesProvider(roomId));

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
                discoverMoviesAsync.when(
                  data: (movies) {
                    if (movies.isEmpty) {
                      return _EmptyDiscoverState(
                        onRetry: () => ref.invalidate(
                          roomDiscoverMoviesProvider(roomId),
                        ),
                      );
                    }
                    final movie = movies.first;
                    return Column(
                      children: [
                        if (movie.posterUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              movie.posterUrl!,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Icon(
                            AppIcons.fastAction,
                            color: AppColors.neonPink,
                            size: AppRoomsTokens.swipePlaceholderIconSize,
                            shadows: AppHomeTokens.activeIconShadows,
                          ),
                        const SizedBox(height: AppSpacing.section),
                        Text(
                          movie.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.heading2.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          '⭐ ${movie.voteAverage.toStringAsFixed(1)}  •  ${movie.releaseYear}',
                          style: AppTypography.bodyRegular.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          movie.overview.isEmpty
                              ? 'No overview available.'
                              : movie.overview,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyRegular.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(
                    color: AppColors.neonPink,
                  ),
                  error: (error, stackTrace) => _DiscoverErrorState(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(
                      roomDiscoverMoviesProvider(roomId),
                    ),
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

class _DiscoverErrorState extends StatelessWidget {
  const _DiscoverErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Could not fetch movies',
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 12),
        AppButton.secondary(label: 'Retry', onPressed: onRetry),
      ],
    );
  }
}

class _EmptyDiscoverState extends StatelessWidget {
  const _EmptyDiscoverState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'No movies found for selected filters.',
          style: AppTypography.bodyRegular.copyWith(color: AppColors.secondaryText),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        AppButton.secondary(label: 'Try Again', onPressed: onRetry),
      ],
    );
  }
}
