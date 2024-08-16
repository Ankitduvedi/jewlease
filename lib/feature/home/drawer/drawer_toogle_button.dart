// Separate widget for the toggle button
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/controller/home_controller.dart';

class DrawerToggleButton extends ConsumerWidget {
  const DrawerToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(drawerStateProvider);
    return IconButton(
      icon: Icon(
        isCollapsed
            ? CupertinoIcons.increase_indent
            : CupertinoIcons.decrease_indent,
        color: Colors.black,
      ),
      onPressed: () {
        ref.read(drawerStateProvider.notifier).toggleDrawer();
      },
    );
  }
}
