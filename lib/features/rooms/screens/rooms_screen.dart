import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShellTabPlaceholder(
      title: 'Rooms',
      subtitle: 'Your active decision rooms will live here.',
      icon: AppIcons.rooms,
    );
  }
}

class _ShellTabPlaceholder extends StatelessWidget {
  const _ShellTabPlaceholder({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.neonPink, size: 34),
            const SizedBox(height: AppSpacing.regular),
            Text(title, style: AppTypography.heading2),
            const SizedBox(height: AppSpacing.small),
            Text(
              subtitle,
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
