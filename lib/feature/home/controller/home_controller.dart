import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerStateProvider = StateNotifierProvider<DrawerStateNotifier, bool>(
  (ref) => DrawerStateNotifier(),
);

// StateNotifier for managing the drawer state

class DrawerStateNotifier extends StateNotifier<bool> {
  DrawerStateNotifier() : super(true); // Initial state: collapsed

  void toggleDrawer() {
    state = !state;
  }

  void expandDrawer() {
    state = false;
  }
}
