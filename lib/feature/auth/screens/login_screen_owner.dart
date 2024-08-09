import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewlease/core/utils/loaders/loader.dart';
import 'package:jewlease/feature/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    log("Login screen");

    final screenSize = MediaQuery.of(context).size;
    final double verticalPadding = screenSize.height * 0.02;
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/login_robot.png',
                        width: screenSize.width * 0.8,
                        height: screenSize.height * 0.5,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: verticalPadding),
                      Text(
                        'Welcome to Reso!',
                        style: GoogleFonts.pacifico(
                          fontSize: 28,
                          color: Colors.brown[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: verticalPadding / 2),
                      Text(
                        'Login as a Owner',
                        style: GoogleFonts.ptSans(
                          fontSize: 18,
                          color: Colors.brown[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: verticalPadding),
                      ElevatedButton(
                        onPressed: () {
                          //handleSignIn(ref);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 225, 114, 94),
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          side: BorderSide(
                            color: Colors.orange[700]!,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset('assets/google_logo2.png',
                                width: 30, height: 30),
                            const SizedBox(width: 20),
                            Text(
                              'Login with Google',
                              style: GoogleFonts.ptSans(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                context.go('/welcomeScreen');
                              },
                              child: const Text(
                                'Go back',
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
