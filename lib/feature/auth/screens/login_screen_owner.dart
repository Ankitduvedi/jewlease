// ignore_for_file: unused_element

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Initially password is obscure
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Login screen staff");

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/login_robot.png',
                          width: screenSize.width *
                              1, // Dynamic width for the image
                          height: screenSize.height * 0.43,
                        ), // Placeholder for the image
                        Text(
                          'Welcome to Jwelease!',
                          style: GoogleFonts.pacifico(
                            fontSize: 28,
                            color: Colors.brown[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalPadding / 2),
                        Text(
                          'Login as a Staff',
                          style: GoogleFonts.ptSans(
                            fontSize: 18,
                            color: Colors.brown[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalPadding),

                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email address';
                            } else if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Email',
                            labelStyle: GoogleFonts.ptSans(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        SizedBox(height: verticalPadding),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) => password!.length < 8
                              ? 'Password must be at least 8 characters'
                              : null,
                          controller: _passwordController,
                          obscureText:
                              _obscureText, // Toggle this boolean to show/hide password
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: GoogleFonts.ptSans(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            // Added suffixIcon to toggle password visibility
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Change the icon based on the state of _obscureText
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                // Update the state to toggle password visibility
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              //ref.read(userProvider.notifier).update((state) => null);
                              ref
                                  .read(authControllerProvider.notifier)
                                  .loginWithEmailAndPassword(
                                      _emailController.text.toString(),
                                      _passwordController.text.toString(),
                                      context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 225, 114,
                                94), // Icon color taken from the logo
                            minimumSize:
                                const Size(double.infinity, 50), // Button size
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12), // Inner padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  24), // Rounded corners to match logo style
                              side: BorderSide(
                                  color: const Color.fromARGB(255, 255, 114,
                                      94)), // Border color taken from the logo
                            ),
                            elevation:
                                0, // No shadow for a flat design similar to the logo
                          ),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.ptSans(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
      ),
    );
  }
}
