import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/controller/home_controller.dart';
import 'package:jewlease/feature/home/drawer/custom_drawer.dart';
import 'package:jewlease/feature/home/right_side_drawer/screen/drawer_screen.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final isOnHomeScreen = ref.watch(isOnHomeScreenProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: Appbar(
        scaffoldKey: _scaffoldKey,
      ),
      endDrawer: const DrawerScreen(),
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

class RightAppDrawer extends StatelessWidget {
  const RightAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
