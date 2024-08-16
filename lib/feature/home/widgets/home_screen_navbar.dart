import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final String currentUrl = GoRouterState.of(context).uri.toString();
    return Scaffold(
      appBar: const Appbar(),
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          const CustomDrawer(), // Leftmost widget (Drawer)
          Expanded(flex: 1, child: widget.childScreen),
        ],
      ),
    );
  }
}
