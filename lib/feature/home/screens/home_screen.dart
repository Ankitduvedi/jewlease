import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/widgets/center_tiles_widget.dart';
import 'package:jewlease/feature/home/widgets/right_tiles.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('Home screen rebuild');

    return Row(
      children: [
        const Expanded(
          flex: 3, // Take up 3/4 of the screen
          child: Center(
            child: ReorderableTilesScreen(),
          ),
        ),
        Expanded(
          flex: 1, // Take up 1/4 of the screen
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to the top
            children: [
              const SizedBox(height: 80),
              WorkToDoWidget(),
              const SizedBox(height: 10),
              const Text(
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
    );
  }
}
