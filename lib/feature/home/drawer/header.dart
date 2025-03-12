import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/controller/home_controller.dart';

class CustomDrawerHeader extends ConsumerWidget {
  const CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = !ref.watch(drawerStateProvider);
    final screenSize = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 60,
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: isCollapsed
                  ? Image.asset(
                      'assets/images/complete_logo.png',
                      key: const ValueKey('complete_logo'),
                      width: screenSize.width * 0.2,
                      height: screenSize.height * 0.2,
                    )
                  : Image.asset(
                      'assets/images/logo.png',
                      key: const ValueKey('logo'),
                      width: screenSize.width * 0.05,
                      height: screenSize.height * 0.05,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
