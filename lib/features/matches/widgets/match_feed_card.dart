import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/analytics_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_design_system.dart';
import '../../rooms/models/room_preview.dart';
import '../../swipe/widgets/swipe_avatar_stack.dart';
import '../models/match_feed_item.dart';
import '../theme/app_matches_tokens.dart';
import '../utils/match_time_formatter.dart';

class MatchFeedCard extends ConsumerStatefulWidget {
  const MatchFeedCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onMenuTap,
  });

  final MatchFeedItem item;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  @override
  ConsumerState<MatchFeedCard> createState() => _MatchFeedCardState();
}

class _MatchFeedCardState extends ConsumerState<MatchFeedCard> {
  var _loggedView = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_loggedView || !mounted) {
        return;
      }
      _loggedView = true;
      unawaited(
        ref.read(analyticsServiceProvider).logMatchCardViewed(
          roomType: widget.item.roomCategoryId,
          matchType: widget.item.matchType,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppMatchesTokens.cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppMatchesTokens.cardRadius),
          gradient: AppMatchesTokens.cardBorderGradient,
          boxShadow: AppMatchesTokens.cardGlow,
        ),
        child: Container(
          margin: const EdgeInsets.all(1),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppMatchesTokens.cardRadius - 1),
            gradient: AppMatchesTokens.cardBackground,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Text(
                  formatMatchRelativeTime(item.matchedAt),
                  style: AppMatchesTokens.poppinsRegular(
                    fontSize: AppMatchesTokens.timestampSize,
                    color: AppColors.primaryText.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MatchItemImage(item: item),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MatchTypeBadge(isPerfect: item.isPerfect),
                        const SizedBox(height: 6),
                        Text(
                          item.itemName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppMatchesTokens.poppinsBold(
                            fontSize: AppMatchesTokens.itemTitleSize,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.roomContextLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppMatchesTokens.poppinsMedium(
                            fontSize: AppMatchesTokens.roomContextSize,
                            color: AppColors.neonPink,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            SwipeAvatarStack(
                              userIds: item.matchedMemberIds,
                              size: AppMatchesTokens.avatarSize,
                              overlap: AppMatchesTokens.avatarOverlap,
                              maxVisible: 4,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.matchResultLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppMatchesTokens.poppinsMedium(
                                  fontSize: AppMatchesTokens.matchResultSize,
                                  color: AppColors.primaryText.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              onPressed: widget.onMenuTap,
                              icon: Icon(
                                Icons.more_horiz_rounded,
                                color: AppColors.primaryText.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchItemImage extends StatelessWidget {
  const _MatchItemImage({required this.item});

  final MatchFeedItem item;

  @override
  Widget build(BuildContext context) {
    final posterUrl = item.posterUrl;
    final categoryColors = RoomPreview.categoryColors(item.roomCategoryId);
    final categoryIcon = RoomPreview.categoryIcon(item.roomCategoryId);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppMatchesTokens.cardImageRadius),
      child: SizedBox(
        width: AppMatchesTokens.cardImageWidth,
        height: AppMatchesTokens.cardImageHeight,
        child: posterUrl == null
            ? DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: categoryColors,
                  ),
                ),
                child: Center(
                  child: Icon(
                    categoryIcon,
                    color: AppColors.primaryText.withValues(alpha: 0.85),
                    size: 36,
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: posterUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => ColoredBox(
                  color: AppColors.cardBackground,
                  child: Center(
                    child: Icon(categoryIcon, color: AppColors.neonPink),
                  ),
                ),
                errorWidget: (_, __, ___) => ColoredBox(
                  color: AppColors.cardBackground,
                  child: Center(
                    child: Icon(categoryIcon, color: AppColors.neonPink),
                  ),
                ),
              ),
      ),
    );
  }
}

class MatchTypeBadge extends StatelessWidget {
  const MatchTypeBadge({required this.isPerfect, super.key});

  final bool isPerfect;

  @override
  Widget build(BuildContext context) {
    final label = isPerfect ? '✨ PERFECT MATCH' : '👍 MAJORITY MATCH';
    final gradient = isPerfect
        ? AppMatchesTokens.perfectBadgeGradient
        : AppMatchesTokens.majorityBadgeGradient;

    return Container(
      height: AppMatchesTokens.badgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppMatchesTokens.poppinsSemiBold(
          fontSize: 11,
          color: Colors.white,
        ),
      ),
    );
  }
}
