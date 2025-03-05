// Drawer Sub Item widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/controller/home_controller.dart';

class DrawerSubItem extends ConsumerWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const DrawerSubItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(drawerStateProvider);

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, // Adjust padding based on drawer state
          ),
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
            ref.read(drawerStateProvider.notifier).toggleDrawer();
          },
        ),
        //const Divider(color: Colors.grey),
      ],
    );
  }
}
