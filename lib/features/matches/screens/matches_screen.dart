import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.matches, color: AppColors.neonPink, size: 34),
            const SizedBox(height: AppSpacing.regular),
            Text('Matches', style: AppTypography.heading2),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Global history of things your crew picked together.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
