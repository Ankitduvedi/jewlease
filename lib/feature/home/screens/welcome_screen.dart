import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE5B4),
              Color(0xFFFF8C42)
            ], // Warm gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Jewlease!',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontFamily:
                    'Pacifico', // Use a custom font for a restaurant theme
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'We are delighted to have you here.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown,
                fontFamily: 'PTSans', // Consistent font styling
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Image.asset(
            //   'assets/Welcome.png', // Add your image in the assets folder
            //   height: 240,
            //   fit: BoxFit.fill,
            // ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to owner screen
                context.push('/loginScreen');
                print("pressed button");
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.person_4, color: Colors.white),
              label: const Text(
                'Continue as Owner',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to staff screen
                context.push('/loginScreenStaff');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.person, color: Colors.white),
              label: const Text(
                'Continue as Staff',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
