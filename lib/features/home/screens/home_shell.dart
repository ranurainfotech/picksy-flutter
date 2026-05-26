import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_design_system.dart';
import '../../matches/screens/matches_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../rooms/screens/rooms_screen.dart';
import '../providers/home_shell_provider.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  static const _tabs = [RoomsScreen(), MatchesScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeTabIndexProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.darkSurface),
        child: IndexedStack(index: currentIndex, children: _tabs),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bottomNavBackground,
          border: const Border(top: BorderSide(color: AppColors.divider)),
          boxShadow: AppShadows.elevated,
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final isSelected = states.contains(WidgetState.selected);
              return AppTypography.tiny.copyWith(
                color: isSelected
                    ? AppColors.bottomNavActive
                    : AppColors.bottomNavInactive,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final isSelected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: isSelected
                    ? AppColors.bottomNavActive
                    : AppColors.bottomNavInactive,
                size: AppSpacing.icon,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              ref.read(homeTabIndexProvider.notifier).selectTab(index);
            },
            height: AppSpacing.bottomNavHeight,
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.like.withValues(alpha: 0.16),
            destinations: const [
              NavigationDestination(icon: Icon(AppIcons.rooms), label: 'Rooms'),
              NavigationDestination(
                icon: Icon(AppIcons.matches),
                label: 'Matches',
              ),
              NavigationDestination(
                icon: Icon(AppIcons.profile),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
