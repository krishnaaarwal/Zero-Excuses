import 'dart:developer' as developer;

import 'package:flutter/foundation.dart' show kReleaseMode;

class AppLogger {
  static void debug(String message, {String? tag}) {
    if (!kReleaseMode) {
      final logTag = tag ?? 'ExerciseApiService';
      developer.log(message, name: logTag, level: 1000);
    }
  }

  static void info(String message, {String? tag}) {
    final logTag = tag ?? 'ExerciseApiService';
    developer.log(message, name: logTag);
  }

  static void warning(String message, {String? tag}) {
    final logTag = tag ?? 'ExerciseApiService';
    developer.log('⚠️ $message', name: logTag, level: 900);
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logTag = tag ?? 'ExerciseApiService';
    developer.log(
      '❌ $message',
      name: logTag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
