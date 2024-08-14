import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/home/drawer/header.dart';

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
            width: isCollapsed ? 70 : 300,
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
                CustomDrawerHeader(),
                Divider(color: Colors.grey),
                Expanded(child: DrawerList()),
                Divider(color: Colors.grey),
                DrawerToggleButton(),
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
      children: [
        const DrawerItem(
            icon: Icons.dashboard_outlined, title: 'Pending Document(Trans)'),
        DrawerExpansionItem(
          icon: Icons.currency_rupee,
          title: 'Rate Updation',
          subTiles: [
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Metal Rate Updation(Filter)',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Stone Buying Rate',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Stone Selling Rate',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Gst Percentage',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Labour Rate Updation',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Discount Rate Updation',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Style(SP) Rate Updation',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Formula Rate Updation(Style Wastage)',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'OMP Fineness',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.dashboard_outlined,
              title: 'Allowable Discount',
              onTap: () {},
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.rule_outlined,
          title: 'Configurations & Rules',
          subTiles: [
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Right,Access & Roles',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Mater-POS',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Master',
          subTiles: [
            DrawerExpansionItem(
              icon: Icons.dashboard_outlined,
              title: 'Company Specific',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum_outlined,
                  title: 'Company',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Financial Year',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.currency_rupee,
                  title: 'Currency',
                  onTap: () {},
                ),
              ],
            ),
            DrawerExpansionItem(
              icon: Icons.dashboard_outlined,
              title: 'Party Specific',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum_outlined,
                  title: 'Company',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Financial Year',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.currency_rupee,
                  title: 'Currency',
                  onTap: () {},
                ),
              ],
            ),
            DrawerExpansionItem(
              icon: Icons.dashboard_outlined,
              title: 'Attribute Specific',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum_outlined,
                  title: 'Company',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Financial Year',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.currency_rupee,
                  title: 'Currency',
                  onTap: () {},
                ),
              ],
            ),
            DrawerExpansionItem(
              icon: Icons.dashboard_outlined,
              title: 'Item Specific',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum_outlined,
                  title: 'Jwellery Specific Master',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.location_on_outlined,
                  title: 'Item Master & Variant',
                  onTap: () {
                    log('button tapped');
                    context.push('/masterScreen');
                  },
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Procurement',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Order Management(React)',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Production',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Procurement(React)',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Report',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Inventory Management(React)',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.request_page_outlined,
          title: 'Financial Account',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Accept-Installment(POS)',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Sales (React)',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.percent_outlined,
          title: 'Scheme Management',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Misc Modules/Masters(React)',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        const DrawerItem(icon: Icons.calendar_today, title: 'Calendar'),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Production Management',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'FG Inventory Management',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Order Management',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Point Of Sales',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        DrawerExpansionItem(
          icon: Icons.dashboard_outlined,
          title: 'Procurement Management',
          subTiles: [
            DrawerSubItem(
              icon: Icons.beach_access,
              title: 'Beach',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.park,
              title: 'Park',
              onTap: () {},
            ),
            DrawerExpansionItem(
              icon: Icons.place,
              title: 'Places',
              subTiles: [
                DrawerSubItem(
                  icon: Icons.museum,
                  title: 'Museum',
                  onTap: () {},
                ),
                DrawerSubItem(
                  icon: Icons.local_florist,
                  title: 'Garden',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        const DrawerItem(icon: Icons.dashboard_outlined, title: 'Loyalty'),
        const DrawerItem(icon: Icons.remove_red_eye, title: 'View Transaction'),
        const DrawerItem(
            icon: Icons.receipt_long_outlined, title: 'View FA Transaction'),
        const DrawerItem(icon: Icons.dashboard_outlined, title: 'Migrations'),
        const DrawerItem(
            icon: Icons.dashboard_outlined, title: 'Formula Procedures'),
        const DrawerItem(
            icon: Icons.dashboard_outlined, title: 'Generic Masters'),
        const DrawerItem(icon: Icons.cloud, title: 'Application Management'),
        DrawerExpansionItem(
          icon: Icons.airplane_ticket,
          title: 'Flights',
          subTiles: [
            DrawerSubItem(
              icon: Icons.flight_takeoff,
              title: 'Departure',
              onTap: () {},
            ),
            DrawerSubItem(
              icon: Icons.flight_land,
              title: 'Arrival',
              onTap: () {},
            ),
          ],
        ),
        const DrawerItem(icon: Icons.notifications, title: 'Notifications'),
        const DrawerItem(icon: Icons.settings, title: 'Settings'),
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
          style: const TextStyle(color: Colors.black, fontSize: 14),
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

// Drawer Sub Item widget
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
          },
        ),
        //const Divider(color: Colors.grey),
      ],
    );
  }
}
