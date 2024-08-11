import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier for managing the drawer state
final drawerStateProvider = StateNotifierProvider<DrawerStateNotifier, bool>(
  (ref) => DrawerStateNotifier(),
);

class DrawerStateNotifier extends StateNotifier<bool> {
  DrawerStateNotifier() : super(true); // Initial state: collapsed

  void toggleDrawer() {
    state = !state;
  }

  void expandDrawer() {
    state = false;
  }
}

// Main Drawer Widget
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, ref, child) {
          final isCollapsed = ref.watch(drawerStateProvider);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCollapsed ? 70 : 250,
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            child: const Column(
              children: [
                DrawerToggleButton(),
                Divider(color: Colors.grey),
                Expanded(child: DrawerList()),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Separate widget for the toggle button
class DrawerToggleButton extends ConsumerWidget {
  const DrawerToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(drawerStateProvider);
    return IconButton(
      icon: Icon(
        isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
        color: Colors.black,
      ),
      onPressed: () {
        ref.read(drawerStateProvider.notifier).toggleDrawer();
      },
    );
  }
}

// Separate widget for the list of items in the drawer
class DrawerList extends StatelessWidget {
  const DrawerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: const [
        DrawerItem(icon: Icons.home, title: 'Home'),
        DrawerItem(icon: Icons.calendar_today, title: 'Calendar'),
        DrawerExpansionItem(
          icon: Icons.pin_drop,
          title: 'Destinations',
          subTiles: [
            DrawerSubItem(icon: Icons.beach_access, title: 'Beach'),
            DrawerSubItem(icon: Icons.park, title: 'Park'),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(icon: Icons.museum, title: 'Museum'),
                DrawerSubItem(icon: Icons.local_florist, title: 'Garden'),
              ],
            ),
          ],
        ),
        DrawerItem(icon: Icons.message_rounded, title: 'Messages'),
        DrawerItem(icon: Icons.cloud, title: 'Weather'),
        DrawerExpansionItem(
          icon: Icons.airplane_ticket,
          title: 'Flights',
          subTiles: [
            DrawerSubItem(icon: Icons.flight_takeoff, title: 'Departure'),
            DrawerSubItem(icon: Icons.flight_land, title: 'Arrival'),
          ],
        ),
        DrawerItem(icon: Icons.notifications, title: 'Notifications'),
        DrawerItem(icon: Icons.settings, title: 'Settings'),
      ],
    );
  }
}

// Drawer Item widget
class DrawerItem extends ConsumerWidget {
  final IconData icon;
  final String title;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
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
          style: const TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () {
        // Handle tap
      },
    );
  }
}

// Drawer Expansion Tile widget
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
            title,
            style: const TextStyle(color: Colors.black),
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

// Drawer Sub Item widget
class DrawerSubItem extends ConsumerWidget {
  final IconData icon;
  final String title;

  const DrawerSubItem({
    super.key,
    required this.icon,
    required this.title,
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
              style: const TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onTap: () {
            // Handle sub-tile tap
          },
        ),
        //const Divider(color: Colors.grey),
      ],
    );
  }
}
