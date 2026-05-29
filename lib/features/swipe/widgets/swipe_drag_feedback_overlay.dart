import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

/// Drag feedback aligned to [SwipeMovieCard] bounds (radius 32).
class SwipeDragFeedbackOverlay extends StatelessWidget {
  const SwipeDragFeedbackOverlay({
    super.key,
    required this.likeProgress,
    required this.dislikeProgress,
  });

  static const cardRadius = 32.0;

  final double likeProgress;
  final double dislikeProgress;

  @override
  Widget build(BuildContext context) {
    final like = likeProgress.clamp(0.0, 1.0);
    final dislike = dislikeProgress.clamp(0.0, 1.0);
    if (like <= 0 && dislike <= 0) {
      return const SizedBox.shrink();
    }

    final isLike = like >= dislike;
    final progress = Curves.easeOutCubic.transform(isLike ? like : dislike);
    final color = isLike ? AppColors.successGreen : AppColors.reject;
    final icon = isLike ? AppIcons.like : Icons.close_rounded;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardRadius),
              border: Border.all(
                color: color.withValues(alpha: 0.72 * progress),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.28 * progress),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          Center(
            child: Opacity(
              opacity: progress,
              child: Transform.scale(
                scale: 0.88 + (0.12 * progress),
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.4),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.55 * progress),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.32 * progress),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 44, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
