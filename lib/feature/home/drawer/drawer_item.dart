// Drawer Item widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/controller/home_controller.dart';

class DrawerItem extends ConsumerWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(drawerStateProvider);

    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: AnimatedOpacity(
        opacity: isCollapsed ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
