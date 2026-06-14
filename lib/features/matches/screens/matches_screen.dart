import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/analytics_provider.dart';
import '../../../core/services/analytics/analytics_screens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../home/providers/home_shell_provider.dart';
import '../models/match_feed_item.dart';
import '../providers/matches_provider.dart';
import '../theme/app_matches_tokens.dart';
import '../widgets/match_feed_card.dart';
import '../widgets/matches_header.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  final _scrollController = ScrollController();
  var _visibleCount = AppMatchesTokens.feedPageSize;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref.read(analyticsServiceProvider).logScreenView(AnalyticsScreens.matches),
      );
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      final total = ref.read(matchesFeedProvider).asData?.value.length ?? 0;
      if (_visibleCount < total) {
        setState(() {
          _visibleCount += AppMatchesTokens.feedPageSize;
        });
      }
    }
  }

  void _openMatchDetails(MatchFeedItem item) {
    unawaited(
      ref.read(analyticsServiceProvider).logMatchCardOpened(
        roomId: item.roomId,
        itemId: item.itemId,
      ),
    );
    context.push(AppRoutes.matchDetails(item.roomId, item.itemId), extra: item);
  }

  void _showMatchMenu() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.cardBackground,
        content: Text(
          'Share, open room, and archive — coming soon.',
          style: AppTypography.bodyRegular.copyWith(color: AppColors.primaryText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(matchesFeedProvider);

    ref.listen(matchesFeedProvider, (previous, next) {
      final total = next.asData?.value.length ?? 0;
      if (_visibleCount > total && total > 0) {
        setState(() => _visibleCount = total);
      }
    });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppMatchesTokens.screenHorizontalPadding,
          AppMatchesTokens.headerTopPadding,
          AppMatchesTokens.screenHorizontalPadding,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MatchesHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: feedAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return MatchesEmptyState(
                      onGoToRooms: () {
                        ref.read(homeTabIndexProvider.notifier).selectTab(0);
                      },
                    );
                  }

                  final visibleItems = items.take(_visibleCount).toList(
                    growable: false,
                  );

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: visibleItems.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppMatchesTokens.cardGap),
                    itemBuilder: (context, index) {
                      final item = visibleItems[index];
                      return MatchFeedCard(
                        item: item,
                        onTap: () => _openMatchDetails(item),
                        onMenuTap: _showMatchMenu,
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.neonPink),
                ),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Could not load matches',
                          style: AppTypography.heading3,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check your connection and try again.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyRegular.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton.secondary(
                          label: 'Retry',
                          onPressed: () => ref.invalidate(matchesFeedProvider),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
