import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/controller/home_controller.dart';
import 'package:jewlease/feature/home/drawer/custom_drawer.dart';
import 'package:jewlease/feature/home/widgets/home_screen_app_bar.dart';
// Import the new widget

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  final Widget childScreen;
  const ScaffoldWithNavBar({required this.childScreen, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar> {
  @override
  Widget build(BuildContext context) {
    final isOnHomeScreen = ref.watch(isOnHomeScreenProvider);
    return Scaffold(
      appBar: const Appbar(),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          if (isOnHomeScreen) const CustomDrawer(), // Leftmost widget (Drawer)
          Expanded(flex: 1, child: widget.childScreen),
        ],
      ),
    );
  }
}
