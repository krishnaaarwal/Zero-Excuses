/// Result of initialization
class InitializationResult {
  final bool success;
  final int? exerciseCount;
  final String? error;

  InitializationResult({required this.success, this.exerciseCount, this.error});
}
