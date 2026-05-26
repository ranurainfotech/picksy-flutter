import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeTabIndexProvider = NotifierProvider<HomeTabIndexNotifier, int>(
  HomeTabIndexNotifier.new,
);

class HomeTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void selectTab(int index) {
    state = index;
  }
}
