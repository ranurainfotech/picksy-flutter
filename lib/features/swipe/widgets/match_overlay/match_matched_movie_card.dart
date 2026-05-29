import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/match_overlay_data.dart';
import '../swipe_movie_card.dart';

/// Single matched movie card for the celebration overlay.
class MatchMatchedMovieCard extends StatelessWidget {
  const MatchMatchedMovieCard({
    super.key,
    required this.data,
    this.designWidth = 240,
    this.designHeight = 330,
  });

  final MatchOverlayData data;
  final double designWidth;
  final double designHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: designWidth,
      height: designHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [AppColors.neonPink, AppColors.softPurple],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPink.withValues(alpha: 0.4),
              blurRadius: 24,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26.5),
            child: SwipeMovieCard(
              movie: data.movie,
              likedUserIds: data.likedUserIds,
            ),
          ),
        ),
      ),
    );
  }
}
