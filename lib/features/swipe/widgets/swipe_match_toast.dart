import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../models/swipe_match.dart';

void showSwipeMatchToast(BuildContext context, SwipeMatch match) {
  final label = match.isPerfect
      ? (match.likedBy.length == 2
          ? "You both matched!"
          : "It's a perfect match!")
      : "It's a match!";
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.cardBackground,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.largeBorder,
        side: BorderSide(color: AppColors.neonPink.withValues(alpha: 0.5)),
      ),
      duration: const Duration(seconds: 4),
      content: Row(
        children: [
          Icon(
            match.isPerfect ? Icons.favorite_rounded : Icons.local_movies_rounded,
            color: AppColors.neonPink,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  match.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
