import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/drawer/custom_drawer.dart';
import 'package:jewlease/feature/home/widgets/center_tiles_widget.dart';
import 'package:jewlease/feature/home/widgets/home_screen_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('Home screen rebuild');

    return Scaffold(
      appBar: const Appbar(),
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          const CustomDrawer(), // Leftmost widget (Drawer)
          Expanded(
            child: Center(
              child: ReorderableTilesScreen(),
            ),
          ),
          const SizedBox(
            // Rightmost widget
            width: 150, // Adjust the width according to your design
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Right Widget 1',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Right Widget 2',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
