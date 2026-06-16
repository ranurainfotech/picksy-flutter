import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

void showSubscriptionSuccessSnackBar(
  BuildContext context, {
  required bool isPro,
}) {
  if (!isPro) {
    return;
  }

  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.neonYellow,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              'Welcome to Picksy Pro!',
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mediumBorder,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      backgroundColor: AppColors.elevatedCard,
      duration: const Duration(seconds: 3),
    ),
  );
}
