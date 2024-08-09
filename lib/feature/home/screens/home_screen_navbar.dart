import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// Import the new widget

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  final Widget childScreen;
  const ScaffoldWithNavBar({required this.childScreen, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar>
    with TickerProviderStateMixin {
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/staff');
        break;
      case 3:
        GoRouter.of(context).go('/menu');
        break;
      case 4:
        GoRouter.of(context).go('/account');
        break;
    }
  }

  bool blackColor = false;
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Hello')),
      body: SafeArea(bottom: false, child: widget.childScreen),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.only(bottom: 2),
        color: !blackColor ? Colors.white : Colors.black,
        height: 50,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: TabBar(
          controller: _controller,
          indicatorColor: Colors.transparent,
          onTap: (index) {
            _onItemTapped(index, context);
            setState(() {
              blackColor = index == 2;
            });
          },
          tabs: [
            Tab(
              child: Column(
                children: [
                  Icon(
                    _controller!.index == 0
                        ? FluentIcons.data_bar_vertical_32_filled
                        : FluentIcons.data_bar_vertical_32_regular,
                    size: 30,
                    color: !blackColor ? Colors.black : Colors.white,
                  ),
                  const Text(
                    'KPI',
                    style: TextStyle(fontSize: 10, letterSpacing: 2),
                  ),
                ],
              ),
              // icon: Icon(
              //   _controller!.index == 0
              //       ? FluentIcons.data_bar_vertical_32_filled
              //       : FluentIcons.data_bar_vertical_32_regular,
              //   size: 30,
              //   color: !blackColor ? Colors.black : Colors.white,
              // ),
            ),
            Tab(
              child: Column(
                children: [
                  Icon(
                    _controller!.index == 1
                        ? Icons.group
                        : Icons.group_outlined,
                    size: 30,
                    color: !blackColor ? Colors.black : Colors.white,
                  ),
                  const Text(
                    'Staff',
                    style: TextStyle(fontSize: 11, letterSpacing: 2),
                  ),
                ],
              ),
              // icon: Icon(
              //   _controller!.index == 1 ? Icons.group : Icons.group_outlined,
              //   size: 30,
              //   color: !blackColor ? Colors.black : Colors.white,
              // ),
            ),
            const SizedBox(width: 30), // Space for the floating action button
            Tab(
              child: Column(
                children: [
                  Icon(
                    _controller!.index == 3
                        ? FluentIcons.food_20_filled
                        : FluentIcons.food_20_regular,
                    size: 30,
                    color: !blackColor ? Colors.black : Colors.white,
                  ),
                  const Text(
                    'Menu',
                    style: TextStyle(fontSize: 10, letterSpacing: 2),
                  ),
                ],
              ),
              // icon: Icon(
              //   _controller!.index == 3
              //       ? FluentIcons.food_20_filled
              //       : FluentIcons.food_20_regular,
              //   size: 30,
              //   color: !blackColor ? Colors.black : Colors.white,
              // ),
            ),
            Tab(
              child: Column(
                children: [
                  Icon(
                    _controller!.index == 4
                        ? FluentIcons.person_20_filled
                        : FluentIcons.person_20_regular,
                    size: 30,
                    color: !blackColor ? Colors.black : Colors.white,
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 10, letterSpacing: 2),
                  ),
                ],
              ),
              // icon: Icon(
              //   _controller!.index == 4
              //       ? FluentIcons.person_20_filled
              //       : FluentIcons.person_20_regular,
              //   size: 30,
              //   color: !blackColor ? Colors.black : Colors.white,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
