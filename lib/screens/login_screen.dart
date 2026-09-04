import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/liquid_glass.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLogin = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields', Colors.red);
      return;
    }

    if (!_isLogin && name.isEmpty) {
      _showSnackBar('Please enter your name', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // Sign in
        await _authService.signInWithEmailPassword(email, password);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        // Sign up
        await _authService.createUserWithEmailPassword(email, password, name);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'email-already-in-use':
          message = 'Email already in use';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'Authentication failed';
      }
      if (mounted) {
        _showSnackBar(message, Colors.red);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('An error occurred. Please try again.', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showSnackBar(
          e.message ?? 'Google sign-in failed',
          Colors.red,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('An error occurred. Please try again.', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/appbg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.25, 0.6, 1.0],
                  colors: [
                    const Color(0xFF0A0A23).withValues(alpha: 0.65),
                    const Color(0xFF0A0A23).withValues(alpha: 0.8),
                    const Color(0xFF0A0A23).withValues(alpha: 0.88),
                    const Color(0xFF0A0A23).withValues(alpha: 0.96),
                  ],
                ),
              ),
            ),
          ),

          // Decorative blobs
          Positioned(
            top: -60,
            left: -60,
            child: const GlassOrb(
              size: 190,
              color: Color(0xFF6C63FF),
              intensity: 0.18,
            ),
          ),
          Positioned(
            top: size.height * 0.4,
            right: -75,
            child: const GlassOrb(
              size: 170,
              color: Color(0xFF48B6FF),
              intensity: 0.15,
            ),
          ),
          Positioned(
            bottom: -35,
            left: size.width * 0.25,
            child: const GlassOrb(
              size: 130,
              color: Color(0xFFB794F6),
              intensity: 0.12,
            ),
          ),

          // Content
          SafeArea(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(bottom: bottomInset * 0.35),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: SizedBox(
                  height: size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      Colors.white.withValues(alpha: 0.06),
                                  border: Border.all(
                                    color: Colors.white
                                        .withValues(alpha: 0.1),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // Logo with rounded corners
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Heading with crossfade
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _isLogin ? 'Welcome Back' : 'Create Account',
                          key: ValueKey(_isLogin),
                          style: const TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _isLogin
                              ? 'Sign in to continue your health journey'
                              : 'Join us and start your wellness path',
                          key: ValueKey('sub_$_isLogin'),
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.white.withValues(alpha: 0.45),
                            height: 1.3,
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),

                      // Glass form card
                      LiquidGlassContainer(
                        padding: const EdgeInsets.all(24),
                        blurStrength: 22,
                        borderOpacity: 0.12,
                        child: Column(
                          children: [
                            // Name field (only for sign up)
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: !_isLogin
                                  ? Column(
                                      children: [
                                        GlassTextField(
                                          controller: _nameController,
                                          hintText: 'Full Name',
                                          prefixIcon:
                                              Icons.person_outline_rounded,
                                          keyboardType: TextInputType.name,
                                        ),
                                        const SizedBox(height: 14),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),

                            GlassTextField(
                              controller: _emailController,
                              hintText: 'Email Address',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 14),

                            GlassTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                  () => _obscurePassword =
                                      !_obscurePassword,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color:
                                        Colors.white.withValues(alpha: 0.35),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),

                            if (_isLogin) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () async {
                                    final email = _emailController.text.trim();
                                    if (email.isEmpty) {
                                      _showSnackBar(
                                        'Please enter your email first',
                                        Colors.red,
                                      );
                                      return;
                                    }

                                    try {
                                      await _authService.resetPassword(email);
                                      _showSnackBar(
                                        'Password reset link sent to $email',
                                        const Color(0xFF6C63FF),
                                      );
                                    } catch (e) {
                                      _showSnackBar(
                                        'Error sending reset link',
                                        Colors.red,
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: const Color(0xFF48B6FF)
                                          .withValues(alpha: 0.8),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 22),

                            GlassButton(
                              text: _isLogin ? 'Sign In' : 'Sign Up',
                              isLoading: _isLoading,
                              onPressed: _handleSubmit,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.08),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                color:
                                    Colors.white.withValues(alpha: 0.3),
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.08),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            customIcon: Image.asset(
                              'assets/images/google logo .png',
                              width: 24,
                              height: 24,
                            ),
                            label: 'Google',
                            onTap: _handleGoogleSignIn,
                          ),
                          const SizedBox(width: 14),
                          _SocialButton(
                            icon: Icons.phone_android_rounded,
                            label: 'Phone',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Phone sign-in coming soon!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  backgroundColor: const Color(0xFF48B6FF),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 14),
                          _SocialButton(
                            icon: Icons.apple_rounded,
                            label: 'Apple',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Apple sign-in coming soon!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  backgroundColor: const Color(0xFF48B6FF),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const Spacer(flex: 1),

                      // Toggle sign in / sign up
                      GestureDetector(
                        onTap: _toggleMode,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text.rich(
                            TextSpan(
                              text: _isLogin
                                  ? "Don't have an account? "
                                  : 'Already have an account? ',
                              style: TextStyle(
                                color:
                                    Colors.white.withValues(alpha: 0.45),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: _isLogin ? 'Sign Up' : 'Sign In',
                                  style: const TextStyle(
                                    color: Color(0xFF48B6FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _SocialButton({
    this.icon,
    this.customIcon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 88,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                children: [
                  widget.customIcon ??
                      Icon(
                        widget.icon,
                        color: widget.iconColor ?? Colors.white.withValues(alpha: 0.75),
                        size: 24,
                      ),
                  const SizedBox(height: 5),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
