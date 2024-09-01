import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavIndexProvider =
    StateNotifierProvider.autoDispose<BottomNavIndexNotifier, int>(
        (ref) => BottomNavIndexNotifier());

class BottomNavIndexNotifier extends StateNotifier<int> {
  BottomNavIndexNotifier() : super(1);

  void changeDisplay(int selectedIndex) {
    state = selectedIndex;
  }
}
