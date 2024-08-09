import 'package:flutter/material.dart';

class AnimatedBackgroundParticles extends StatefulWidget {
  const AnimatedBackgroundParticles({super.key});
  @override
  AnimatedBackgroundParticlesState createState() =>
      AnimatedBackgroundParticlesState();
}

class AnimatedBackgroundParticlesState
    extends State<AnimatedBackgroundParticles> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE5B4), Color(0xFFFF8C42)],
        ),
      ),
    );
  }
}
