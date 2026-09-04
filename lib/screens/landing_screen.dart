import 'dart:ui';
import 'package:flutter/material.dart';

import '../widgets/liquid_glass.dart';
import 'login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/appbg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay gradient — heavier at the bottom for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.3, 0.6, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    const Color(0xFF0A0A23).withValues(alpha: 0.55),
                    const Color(0xFF0A0A23).withValues(alpha: 0.78),
                    const Color(0xFF0A0A23).withValues(alpha: 0.96),
                  ],
                ),
              ),
            ),
          ),

          // Decorative glass orbs
          Positioned(
            top: size.height * 0.06,
            right: -40,
            child: const GlassOrb(
              size: 160,
              color: Color(0xFF6C63FF),
              intensity: 0.2,
            ),
          ),
          Positioned(
            top: size.height * 0.32,
            left: -55,
            child: const GlassOrb(
              size: 110,
              color: Color(0xFF48B6FF),
              intensity: 0.15,
            ),
          ),
          Positioned(
            bottom: size.height * 0.12,
            right: -30,
            child: const GlassOrb(
              size: 80,
              color: Color(0xFFB794F6),
              intensity: 0.12,
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo with rounded corners (no animation)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Title
                  const Text(
                    'CareCart',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Health, Delivered',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 3,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Banner Image instead of feature cards
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/Landing page Banner.png',
                      width: size.width * 0.85,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // CTA buttons
                  GlassButton(
                    text: 'Get Started',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _navigateToLogin,
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: _navigateToLogin,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 14,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Color(0xFF48B6FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

