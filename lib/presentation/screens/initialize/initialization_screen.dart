import 'package:flutter/material.dart';
import 'package:workout_app/presentation/screens/initialize/app_initializer.dart';

/// Screen shown during first-time app initialization
class InitializationScreen extends StatefulWidget {
  final AppInitializer initializer;
  final VoidCallback onComplete;

  const InitializationScreen({
    super.key,
    required this.initializer,
    required this.onComplete,
  });

  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  String _statusMessage = 'Preparing your workout experience...';
  double _progress = 0.0;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startInitialization();
  }

  Future<void> _startInitialization() async {
    final result = await widget.initializer.initialize(
      onProgress: (progress) {
        setState(() {
          _statusMessage = progress.message;
          _progress = progress.progress;
        });
      },
    );

    if (result.success) {
      // Small delay to show completion
      await Future.delayed(const Duration(milliseconds: 500));
      widget.onComplete();
    } else {
      setState(() {
        _hasError = true;
        _errorMessage = result.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // App Icon/Logo
              Icon(Icons.fitness_center, size: 80, color: colorScheme.primary),
              const SizedBox(height: 24),

              Text(
                'Workout App',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              if (!_hasError) ...[
                // Progress indicator
                SizedBox(
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),

                // Status message
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),

                Text(
                  '${(_progress * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                // Error state
                Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                const SizedBox(height: 16),

                Text(
                  'Initialization Failed',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _errorMessage ?? 'An unexpected error occurred',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _progress = 0.0;
                      _errorMessage = null;
                    });
                    _startInitialization();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],

              const Spacer(),

              // Footer note
              Text(
                'This is a one-time setup.\nDownloading exercise database and images...',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
