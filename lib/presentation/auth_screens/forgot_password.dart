// lib/presentation/screens/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/state_management/providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServicesProvider);
      await authService.resetPassword(email: _emailController.text.trim());

      setState(() {
        _emailSent = true;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later';
    }
    return 'Failed to send reset email. Please try again';
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
                ? [const Color(0xFF121212), const Color(0xFF1A1A1A)]
                : [Colors.white, const Color(0xFFF9FAFB)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: theme.colorScheme.onSurface,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                  ),
                ),
                const SizedBox(height: 40),

                if (!_emailSent) ...[
                  // Header
                  Text('Forgot Password?', style: theme.textTheme.displayLarge),
                  const SizedBox(height: 8),
                  Text(
                    "Don't worry! Enter your email and we'll send you a link to reset your password",
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),

                  // Illustration
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        size: 100,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleResetPassword(),
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.02),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.error,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Send Reset Link Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleResetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        disabledBackgroundColor: theme.colorScheme.primary
                            .withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Send Reset Link',
                              style: theme.textTheme.labelLarge,
                            ),
                    ),
                  ),
                ] else ...[
                  // Success State
                  Center(
                    child: Column(
                      children: [
                        // Success Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mark_email_read_outlined,
                            size: 60,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 32),

                        Text(
                          'Check Your Email',
                          style: theme.textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'We have sent a password reset link to',
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        Text(
                          _emailController.text.trim(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: theme.colorScheme.primary,
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Didn't receive the email? Check your spam folder or click resend",
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Resend Button
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _emailSent = false;
                            });
                          },
                          child: Text(
                            'Resend Email',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Back to Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Back to Login',
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
