import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../theme/app_matches_tokens.dart';

class MatchesHeader extends StatelessWidget {
  const MatchesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Matches ',
                      style: AppMatchesTokens.poppinsBold(
                        fontSize: AppMatchesTokens.titleSize,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonPink.withValues(alpha: 0.55),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            '⚡',
                            style: AppMatchesTokens.poppinsBold(
                              fontSize: AppMatchesTokens.titleSize,
                              color: AppColors.neonPink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'All the movies, restaurants & activities your crew matched on. 🍿',
          style: AppMatchesTokens.poppinsRegular(
            fontSize: AppMatchesTokens.subtitleSize,
            color: AppColors.primaryText.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class MatchesEmptyState extends StatelessWidget {
  const MatchesEmptyState({required this.onGoToRooms, super.key});

  final VoidCallback onGoToRooms;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppGradients.neonGlow,
                boxShadow: AppShadows.purpleGlow,
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: Text(
                    '⚡',
                    style: AppMatchesTokens.poppinsBold(
                      fontSize: 48,
                      color: AppColors.neonPink,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No matches yet',
              style: AppMatchesTokens.poppinsBold(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a room and start swiping to find your next movie night.',
              textAlign: TextAlign.center,
              style: AppMatchesTokens.poppinsRegular(
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onGoToRooms,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.neonPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Go to Rooms',
                style: AppMatchesTokens.poppinsSemiBold(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
