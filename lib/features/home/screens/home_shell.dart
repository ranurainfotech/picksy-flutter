import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/analytics_provider.dart';
import '../../../core/services/analytics/analytics_screens.dart';
import '../../../core/theme/app_design_system.dart';
import '../../matches/screens/matches_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../rooms/screens/rooms_screen.dart';
import '../providers/home_shell_provider.dart';
import '../widgets/picksy_bottom_nav.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  static const _tabs = [RoomsScreen(), MatchesScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref.read(analyticsServiceProvider).logScreenView(AnalyticsScreens.home),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(homeTabIndexProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.darkSurface),
        child: IndexedStack(index: currentIndex, children: _tabs),
      ),
      bottomNavigationBar: PicksyBottomNav(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(homeTabIndexProvider.notifier).selectTab(index);
          final screenName = switch (index) {
            1 => AnalyticsScreens.matches,
            _ => AnalyticsScreens.home,
          };
          unawaited(
            ref.read(analyticsServiceProvider).logScreenView(screenName),
          );
        },
      ),
    );
  }
}
