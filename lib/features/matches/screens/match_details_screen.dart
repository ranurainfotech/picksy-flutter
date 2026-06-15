import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/analytics_provider.dart';
import '../../../core/services/analytics/analytics_screens.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../swipe/widgets/swipe_avatar_stack.dart';
import '../models/match_feed_item.dart';
import '../providers/matches_provider.dart';
import '../widgets/match_feed_card.dart';
import '../theme/app_matches_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchDetailsScreen extends ConsumerStatefulWidget {
  const MatchDetailsScreen({
    super.key,
    required this.roomId,
    required this.itemId,
    this.initialItem,
  });

  final String roomId;
  final String itemId;
  final MatchFeedItem? initialItem;

  @override
  ConsumerState<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends ConsumerState<MatchDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref.read(analyticsServiceProvider).logScreenView(
          AnalyticsScreens.matchDetails,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchAsync = ref.watch(
      matchFeedItemProvider((roomId: widget.roomId, itemId: widget.itemId)),
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.darkSurface),
        child: SafeArea(
          child: matchAsync.when(
            data: (item) {
              if (item == null) {
                return _MissingMatch(onBack: context.pop);
              }
              return _MatchDetailsBody(item: item);
            },
            loading: () {
              if (widget.initialItem != null) {
                return _MatchDetailsBody(item: widget.initialItem!);
              }
              return const Center(
                child: CircularProgressIndicator(color: AppColors.neonPink),
              );
            },
            error: (_, __) => _MissingMatch(onBack: context.pop),
          ),
        ),
      ),
    );
  }
}

class _MissingMatch extends StatelessWidget {
  const _MissingMatch({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
          ),
          const Spacer(),
          Text('Match not found', style: AppTypography.heading3),
          const SizedBox(height: 8),
          Text(
            'This match may have been removed.',
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _MatchDetailsBody extends ConsumerWidget {
  const _MatchDetailsBody({required this.item});

  final MatchFeedItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMovies = item.roomCategoryId == 'movies';
    final isRestaurants = item.roomCategoryId == 'restaurants';
    final movieAsync = isMovies && item.movieId != null
        ? ref.watch(movieDetailsProvider(item.movieId!))
        : const AsyncValue<dynamic>.data(null);
    final placeAsync = isRestaurants
        ? ref.watch(placeDetailsProvider(item.itemId))
        : const AsyncValue<dynamic>.data(null);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: _DetailsHero(item: item)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              MatchTypeBadge(isPerfect: item.isPerfect),
              const SizedBox(height: 12),
              Text(
                item.itemName,
                style: AppMatchesTokens.poppinsBold(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                item.roomContextLabel,
                style: AppMatchesTokens.poppinsMedium(
                  fontSize: 18,
                  color: AppColors.neonPink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.matchResultLabel,
                style: AppMatchesTokens.poppinsMedium(
                  fontSize: 15,
                  color: AppColors.primaryText.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Description',
                style: AppMatchesTokens.poppinsSemiBold(fontSize: 18),
              ),
              const SizedBox(height: 8),
              movieAsync.when(
                data: (movie) {
                  final overview = movie?.overview?.trim();
                  if (overview != null && overview.isNotEmpty) {
                    return Text(
                      overview,
                      style: AppMatchesTokens.poppinsRegular(
                        fontSize: 15,
                        color: AppColors.secondaryText,
                      ),
                    );
                  }
                  return Text(
                    _placeholderDescription(item.roomCategoryId),
                    style: AppMatchesTokens.poppinsRegular(
                      fontSize: 15,
                      color: AppColors.secondaryText,
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(color: AppColors.neonPink),
                ),
                error: (_, __) => Text(
                  _placeholderDescription(item.roomCategoryId),
                  style: AppMatchesTokens.poppinsRegular(
                    fontSize: 15,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              if (isRestaurants) ...[
                const SizedBox(height: 16),
                placeAsync.when(
                  data: (details) {
                    if (details == null) {
                      return const SizedBox.shrink();
                    }
                    final lines = <String>[
                      if (details.shortAddress.isNotEmpty) details.shortAddress,
                      if (details.overview.isNotEmpty) details.overview,
                      ...details.openingHours,
                    ];
                    if (lines.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final line in lines)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              line,
                              style: AppMatchesTokens.poppinsRegular(
                                fontSize: 15,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                        Text(
                          'Powered by Google',
                          style: AppMatchesTokens.poppinsRegular(
                            fontSize: 12,
                            color: AppColors.secondaryText.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
              const SizedBox(height: 28),
              Text(
                'Matched members',
                style: AppMatchesTokens.poppinsSemiBold(fontSize: 18),
              ),
              const SizedBox(height: 12),
              SwipeAvatarStack(
                userIds: item.matchedMemberIds,
                size: 44,
                overlap: 14,
                maxVisible: 8,
              ),
              const SizedBox(height: 28),
              _DetailsActions(item: item, isMovies: isMovies),
            ]),
          ),
        ),
      ],
    );
  }

  String _placeholderDescription(String categoryId) {
    return switch (categoryId) {
      'restaurants' =>
        'Your crew matched on this spot. Menu and details coming soon.',
      'activities' =>
        'Your crew matched on this activity. Full details coming soon.',
      _ => 'Your crew matched on this pick.',
    };
  }
}

class _DetailsHero extends StatelessWidget {
  const _DetailsHero({required this.item});

  final MatchFeedItem item;

  @override
  Widget build(BuildContext context) {
    final posterUrl = item.posterUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: posterUrl == null
              ? ColoredBox(
                  color: AppColors.cardBackground,
                  child: Icon(
                    item.roomCategoryId == 'restaurants'
                        ? Icons.restaurant_rounded
                        : Icons.movie_filter_rounded,
                    size: 64,
                    color: AppColors.neonPink.withValues(alpha: 0.8),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: posterUrl,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class _DetailsActions extends StatelessWidget {
  const _DetailsActions({required this.item, required this.isMovies});

  final MatchFeedItem item;
  final bool isMovies;

  @override
  Widget build(BuildContext context) {
    if (isMovies) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton.primary(
            label: 'Add to Watchlist',
            icon: Icons.playlist_add_rounded,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          AppButton.secondary(
            label: 'Where to Watch',
            icon: Icons.live_tv_rounded,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          AppButton.secondary(
            label: 'Open Room',
            icon: AppIcons.rooms,
            onPressed: () => context.push(AppRoutes.roomLobby(item.roomId)),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          label: item.roomCategoryId == 'restaurants'
              ? 'Open Maps'
              : 'View Details',
          icon: Icons.open_in_new_rounded,
          onPressed: () => _openExternalLink(
            item.googleMapsUri ??
                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(item.itemName)}&query_place_id=${Uri.encodeComponent(item.itemId)}',
          ),
        ),
        const SizedBox(height: 12),
        AppButton.secondary(
          label: 'Open Room',
          icon: AppIcons.rooms,
          onPressed: () => context.push(AppRoutes.roomLobby(item.roomId)),
        ),
      ],
    );
  }

  Future<void> _openExternalLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
