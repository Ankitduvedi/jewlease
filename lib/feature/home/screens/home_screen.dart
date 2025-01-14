import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/home/widgets/center_tiles_widget.dart';
import 'package:jewlease/feature/home/widgets/right_tiles.dart';

final isOnHomeScreenProvider = StateProvider<bool>((ref) => true);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(isOnHomeScreenProvider.notifier).state = true;
  }

  @override
  void dispose() {
    ref.read(isOnHomeScreenProvider.notifier).state = false;
    log('leave screen');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Home screen rebuild');

    return const Row(
      children: [
        Expanded(
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
              SizedBox(height: 80),
              WorkToDoWidget(),
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
    );
  }
}
