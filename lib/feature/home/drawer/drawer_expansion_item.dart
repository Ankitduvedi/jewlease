// Drawer Expansion Tile widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/controller/home_controller.dart';

class DrawerExpansionItem extends ConsumerWidget {
  final IconData icon;
  final String title;
  final List<Widget> subTiles;

  const DrawerExpansionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subTiles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(drawerStateProvider);

    return Theme(
      data: ThemeData(
        dividerColor: Colors.grey,
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.black),
        title: AnimatedOpacity(
          opacity: isCollapsed ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Text(
            maxLines: 2,
            title,
            style: const TextStyle(color: Colors.black, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: isCollapsed ? const SizedBox.shrink() : null,
        onExpansionChanged: (isExpanded) {
          if (isExpanded && isCollapsed) {
            ref.read(drawerStateProvider.notifier).expandDrawer();
          }
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        childrenPadding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 0.0 : 16.0,
        ),
        children: subTiles,
      ),
    );
  }
}
