import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/presentation/widgets/primary_button.dart';
import 'package:workout_app/presentation/widgets/secondary_outline_button.dart';
import 'package:workout_app/state_management/providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    confirmPassC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/logo1.png"),
          Text("ZeroExcuse", style: theme.textTheme.displayMedium),
          Text(
            '"Track your workouts, diet & progress in one place"',
            style: theme.textTheme.bodySmall,
          ),
          Text("Create Account", style: theme.textTheme.bodyLarge),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailC,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: "you@example.com",
                    labelText: "Email Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Create a valid email';
                    }
                    if (!value.contains('@')) {
                      return 'Please create a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passC,
                  style: theme.textTheme.bodyMedium,
                  obscureText: !ref.watch(registerPasswordVisiblilityProvider),
                  decoration: InputDecoration(
                    hintText: "Create your password",
                    labelText: "Create Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        ref.watch(registerPasswordVisiblilityProvider)
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        ref
                            .read(registerPasswordVisiblilityProvider.notifier)
                            .state = !ref.watch(
                          registerPasswordVisiblilityProvider,
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPassC,
                  style: theme.textTheme.bodyMedium,
                  obscureText: !ref.watch(
                    registerConfirmPasswordVisiblilityProvider,
                  ),
                  decoration: InputDecoration(
                    hintText: "Confirm your password",
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        ref.watch(registerConfirmPasswordVisiblilityProvider)
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        ref
                            .read(
                              registerConfirmPasswordVisiblilityProvider
                                  .notifier,
                            )
                            .state = !ref.watch(
                          registerConfirmPasswordVisiblilityProvider,
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          PrimaryButton(text: "Create->", onPressed: () {}),
          SecondaryOutlineButton(text: "Login", onPressed: () {}),
        ],
      ),
    );
  }
}
