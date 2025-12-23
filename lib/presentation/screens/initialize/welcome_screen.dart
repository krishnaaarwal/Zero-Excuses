// lib/presentation/screens/auth/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:workout_app/presentation/auth_screens/login_screen.dart';
import 'package:workout_app/presentation/auth_screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF121212),
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2A2A2A),
                  ]
                : [Colors.white, const Color(0xFFF3F4F6), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // App Icon/Logo
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // App Title
                        Text(
                          'FitPro',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tagline
                        Text(
                          'Transform Your Body,\nElevate Your Mind',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Features
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeatureBadge(context, 'Track'),
                            const SizedBox(width: 8),
                            _buildFeatureBadge(context, 'Progress'),
                            const SizedBox(width: 8),
                            _buildFeatureBadge(context, 'Achieve'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),

                // Buttons
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Terms
                      Text(
                        'By continuing, you agree to our Terms & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(BuildContext context, String text) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.2)
              : theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : theme.colorScheme.primary,
        ),
      ),
    );
  }
}
