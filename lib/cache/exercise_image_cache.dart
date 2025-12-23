import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/Api/key.dart';
import 'package:workout_app/Exception/logger.dart';
import 'package:workout_app/models/api_exercise.dart';

/// Handles downloading and caching exercise images locally
class ExerciseImageCache {
  static const String baseUrl = 'https://api.workoutapi.com/v1';
  final String apiKey = API_KEY;

  /// Get the local directory for storing images
  Future<Directory> _getImageDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/exercise_images');

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    return imageDir;
  }

  /// Get the file path for a specific exercise image
  Future<String> _getImagePath(String exerciseId, String format) async {
    final dir = await _getImageDirectory();
    return '${dir.path}/$exerciseId.$format';
  }

  /// Check if image is already cached
  Future<bool> isImageCached(String exerciseId, {String format = 'svg'}) async {
    final path = await _getImagePath(exerciseId, format);
    return File(path).exists();
  }

  /// Download and cache a single exercise image
  Future<bool> downloadAndCacheImage(
    String exerciseId, {
    String format = 'svg',
  }) async {
    try {
      // Check if already cached
      if (await isImageCached(exerciseId, format: format)) {
        AppLogger.debug(
          'Image already cached for exercise: $exerciseId',
          tag: 'ImageCache',
        );
        return true;
      }

      AppLogger.debug(
        'Downloading image for exercise: $exerciseId',
        tag: 'ImageCache',
      );

      // Download image from API
      final url = '$baseUrl/exercises/$exerciseId/image?format=$format';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': format == 'svg' ? 'image/svg+xml' : 'image/png',
          'x-api-key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        // Save to local file
        final path = await _getImagePath(exerciseId, format);
        final file = File(path);
        await file.writeAsBytes(response.bodyBytes);

        AppLogger.debug(
          '✅ Cached image for exercise: $exerciseId',
          tag: 'ImageCache',
        );
        return true;
      } else {
        AppLogger.error(
          'Failed to download image for $exerciseId: ${response.statusCode}',
          tag: 'ImageCache',
        );
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error downloading image for $exerciseId',
        tag: 'ImageCache',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Download and cache images for multiple exercises
  Future<void> downloadAndCacheMultipleImages(
    List<ApiExercise> exercises, {
    String format = 'svg',
    Function(int current, int total)? onProgress,
  }) async {
    AppLogger.info(
      'Starting batch download of ${exercises.length} images',
      tag: 'ImageCache',
    );

    int successCount = 0;
    int failCount = 0;

    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];

      onProgress?.call(i + 1, exercises.length);

      final success = await downloadAndCacheImage(exercise.id!, format: format);

      if (success) {
        successCount++;
      } else {
        failCount++;
      }

      // Small delay to avoid overwhelming the API
      await Future.delayed(const Duration(milliseconds: 100));
    }

    AppLogger.info(
      '✅ Batch download complete: $successCount success, $failCount failed',
      tag: 'ImageCache',
    );
  }

  /// Get cached image file
  Future<File?> getCachedImage(
    String exerciseId, {
    String format = 'svg',
  }) async {
    final path = await _getImagePath(exerciseId, format);
    final file = File(path);

    if (await file.exists()) {
      return file;
    }

    return null;
  }

  /// Get cached image as bytes
  Future<Uint8List?> getCachedImageBytes(
    String exerciseId, {
    String format = 'svg',
  }) async {
    final file = await getCachedImage(exerciseId, format: format);
    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }

  /// Clear all cached images
  Future<void> clearCache() async {
    try {
      final dir = await _getImageDirectory();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        AppLogger.info('All exercise images cleared', tag: 'ImageCache');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error clearing image cache',
        tag: 'ImageCache',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final dir = await _getImageDirectory();
      if (!await dir.exists()) {
        return {'count': 0, 'size_mb': 0.0};
      }

      final files = await dir.list().toList();
      int totalSize = 0;

      for (var file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return {
        'count': files.length,
        'size_mb': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      return {'count': 0, 'size_mb': 0.0, 'error': e.toString()};
    }
  }
}
