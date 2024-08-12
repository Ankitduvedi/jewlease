import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Scaffold(
      body: widget.childScreen,
    );
  }
}
