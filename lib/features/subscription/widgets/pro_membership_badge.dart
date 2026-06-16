import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

class ProMembershipBadge extends StatelessWidget {
  const ProMembershipBadge({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.primaryCta,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: const [
          BoxShadow(
            color: AppColors.pinkGlow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.small : AppSpacing.regular,
          vertical: compact ? AppSpacing.compact : AppSpacing.small,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: compact ? 16 : 18,
            ),
            const SizedBox(width: AppSpacing.compact),
            Text(
              'PICKSY PRO',
              style: (compact ? AppTypography.caption : AppTypography.button)
                  .copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
