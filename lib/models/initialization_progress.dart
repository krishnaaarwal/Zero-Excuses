import 'package:workout_app/presentation/screens/initialize/app_initializer.dart';

/// Progress update during initialization
class InitializationProgress {
  final InitStage stage;
  final String message;
  final double progress; // 0.0 to 1.0

  InitializationProgress({
    required this.stage,
    required this.message,
    required this.progress,
  });
}
