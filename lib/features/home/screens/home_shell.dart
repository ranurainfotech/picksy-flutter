import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_design_system.dart';
import '../../matches/screens/matches_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../rooms/screens/rooms_screen.dart';
import '../providers/home_shell_provider.dart';
import '../widgets/picksy_bottom_nav.dart';

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
      bottomNavigationBar: PicksyBottomNav(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(homeTabIndexProvider.notifier).selectTab(index);
        },
      ),
    );
  }
}
