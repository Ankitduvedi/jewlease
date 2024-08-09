import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/drawer/custom_drawer.dart';
import 'package:jewlease/feature/home/screens/home_screen_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: Appbar(),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomDrawer(),
          //Appbar(),
          Center(
            child: Text(
              'Collasable drawers',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
