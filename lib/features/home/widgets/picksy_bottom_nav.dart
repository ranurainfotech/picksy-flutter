import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../theme/app_home_tokens.dart';

class PicksyBottomNav extends StatelessWidget {
  const PicksyBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _items = [
    _PicksyNavItem(icon: AppIcons.rooms, label: 'Rooms'),
    _PicksyNavItem(icon: AppIcons.matches, label: 'Matches'),
    _PicksyNavItem(icon: AppIcons.profile, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppHomeTokens.bottomNavBlur,
          sigmaY: AppHomeTokens.bottomNavBlur,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppHomeTokens.bottomNavBackground,
            border: Border(
              top: BorderSide(
                color: AppHomeTokens.bottomNavBorder.withValues(
                  alpha: AppHomeTokens.bottomNavBorderOpacity,
                ),
              ),
            ),
            boxShadow: AppHomeTokens.bottomNavShadow,
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: AppHomeTokens.bottomNavHeight,
              child: Row(
                children: [
                  for (final (index, item) in _items.indexed)
                    Expanded(
                      child: _PicksyBottomNavItem(
                        item: item,
                        isSelected: selectedIndex == index,
                        onTap: () => onDestinationSelected(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PicksyBottomNavItem extends StatelessWidget {
  const _PicksyBottomNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _PicksyNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? AppColors.bottomNavActive
        : AppColors.primaryText.withValues(alpha: AppHomeTokens.inactiveAlpha);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: AppHomeTokens.bottomNavTopPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              item.icon,
              color: color,
              size: AppHomeTokens.bottomNavIconSize,
              shadows: isSelected ? AppHomeTokens.activeIconShadows : null,
            ),
            const SizedBox(height: AppHomeTokens.bottomNavItemGap),
            Text(
              item.label,
              style: AppTypography.caption.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: -0.2,
                shadows: isSelected ? AppHomeTokens.activeTextShadows : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PicksyNavItem {
  const _PicksyNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
