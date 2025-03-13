import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewlease/feature/auth/controller/auth_controller.dart';
import 'package:jewlease/feature/splash_screen/splash_view.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final authController = ref.watch(authControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          const AnimatedBackgroundParticles(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Welcome to',
                      style: GoogleFonts.pacifico(
                        fontSize: 30,
                        color: Colors.brown[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Image.asset(
                        'assets/images/complete_logo.png',
                        width: screenSize.width * 0.4,
                        height: screenSize.height * 0.2,
                      ),
                    ),

                    const SizedBox(height: 100),

                    Text(
                      'Login to Continue',
                      style: GoogleFonts.ptSans(
                        fontSize: 18,
                        color: Colors.brown[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Email Field with Animated Border
                    _buildAnimatedTextFormField(
                      controller: _emailController,
                      label: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                    ),

                    const SizedBox(height: 25),

                    // Password Field with Animated Visibility Toggle
                    _buildAnimatedTextFormField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      icon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Animated Button with Ripple Effect
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 240, 144, 132),
                            Color.fromARGB(255, 225, 114, 94)
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await authController.login(
                            _emailController.text,
                            _passwordController.text,
                            context,
                            ref,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.ptSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // Animated TextFormField Builder
  Widget _buildAnimatedTextFormField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    bool obscureText = false,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.ptSans(),
          prefixIcon: Icon(icon, color: Colors.brown[400]),
          suffixIcon: suffixIcon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
