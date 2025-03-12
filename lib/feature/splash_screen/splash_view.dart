import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/auth/screens/login_screen_owner.dart';
import 'package:jewlease/feature/splash_screen/controller/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _positionAnimation; // Position Animation

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2)).then((value) async {
      final splashInitialize = ref.read(splashControllerProvider);
      splashInitialize.checkCondition(context);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.2, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuad,
      ),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -2.5), // Smooth upward movement
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuad,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackgroundParticles(),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _positionAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Hero(
                      tag: 'appLogo',
                      child: Image.asset(
                        'assets/images/complete_logo.png',
                        width: 580,
                        height: 580,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// GRADIENT BACKGROUND
class AnimatedBackgroundParticles extends StatefulWidget {
  const AnimatedBackgroundParticles({super.key});

  @override
  State<AnimatedBackgroundParticles> createState() =>
      _AnimatedBackgroundParticlesState();
}

class _AnimatedBackgroundParticlesState
    extends State<AnimatedBackgroundParticles> with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<Alignment> _alignmentAnimation1;
  late Animation<Alignment> _alignmentAnimation2;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _alignmentAnimation1 = Tween<Alignment>(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));

    _alignmentAnimation2 = Tween<Alignment>(
      begin: Alignment.bottomCenter,
      end: Alignment.topLeft,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOutCubicEmphasized,
    ));
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _alignmentAnimation1.value,
              end: _alignmentAnimation2.value,
              colors: const [
                Color.fromARGB(90, 196, 201, 71), // Neon Green
                Color.fromARGB(90, 61, 134, 223), // Neon Green
                // Deep Blue
              ],
            ),
          ),
        );
      },
    );
  }
}
