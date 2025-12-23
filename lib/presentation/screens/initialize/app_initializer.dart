import 'package:hive_ce/hive.dart';
import 'package:workout_app/Exception/logger.dart';
import 'package:workout_app/cache/exercise_image_cache.dart';
import 'package:workout_app/models/initialization_progress.dart';
import 'package:workout_app/models/initialization_result.dart';
import 'package:workout_app/repository/exercise_cache_repository.dart';

/// Handles first-time initialization of the app
class AppInitializer {
  static const String initBoxName = 'app_init_box';
  static const String initCompleteKey = 'init_complete';

  final ExerciseCacheRepository _exerciseCacheRepo;
  final ExerciseImageCache _imageCache;
  final Box _initBox;

  AppInitializer(this._exerciseCacheRepo, this._imageCache, this._initBox);

  /// Check if app has been initialized
  bool isInitialized() {
    return _initBox.get(initCompleteKey, defaultValue: false) as bool;
  }

  /// Perform first-time initialization
  Future<InitializationResult> initialize({
    Function(InitializationProgress)? onProgress,
  }) async {
    AppLogger.info('🚀 Starting app initialization...', tag: 'AppInit');

    try {
      // Step 1: Fetch and cache all exercises
      onProgress?.call(
        InitializationProgress(
          stage: InitStage.fetchingExercises,
          message: 'Downloading exercise database...',
          progress: 0.0,
        ),
      );

      final exercises = await _exerciseCacheRepo.fetchAndCacheAllExercises();

      onProgress?.call(
        InitializationProgress(
          stage: InitStage.fetchingExercises,
          message: 'Downloaded ${exercises.length} exercises',
          progress: 0.3,
        ),
      );

      AppLogger.info('✅ Cached ${exercises.length} exercises', tag: 'AppInit');

      // Step 2: Download exercise images
      onProgress?.call(
        InitializationProgress(
          stage: InitStage.downloadingImages,
          message: 'Downloading exercise illustrations...',
          progress: 0.4,
        ),
      );

      await _imageCache.downloadAndCacheMultipleImages(
        exercises,
        format: 'svg',
        onProgress: (current, total) {
          final imageProgress = 0.4 + (current / total) * 0.5;
          onProgress?.call(
            InitializationProgress(
              stage: InitStage.downloadingImages,
              message: 'Downloaded $current of $total images',
              progress: imageProgress,
            ),
          );
        },
      );

      AppLogger.info('✅ Downloaded exercise images', tag: 'AppInit');

      // Step 3: Mark initialization as complete
      await _initBox.put(initCompleteKey, true);

      onProgress?.call(
        InitializationProgress(
          stage: InitStage.complete,
          message: 'Initialization complete!',
          progress: 1.0,
        ),
      );

      AppLogger.info('✅ Initialization complete', tag: 'AppInit');

      return InitializationResult(
        success: true,
        exerciseCount: exercises.length,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Initialization failed',
        tag: 'AppInit',
        error: e,
        stackTrace: stackTrace,
      );

      return InitializationResult(success: false, error: e.toString());
    }
  }

  /// Reset initialization (force re-download)
  Future<void> resetInitialization() async {
    await _exerciseCacheRepo.clearCache();
    await _imageCache.clearCache();
    await _initBox.delete(initCompleteKey);
    AppLogger.info('Reset initialization state', tag: 'AppInit');
  }

  /// Get initialization status
  Future<Map<String, dynamic>> getStatus() async {
    final isInit = isInitialized();
    final cacheInfo = _exerciseCacheRepo.getCacheInfo();
    final imageStats = await _imageCache.getCacheStats();

    return {
      'initialized': isInit,
      'exercise_cache': cacheInfo,
      'image_cache': imageStats,
    };
  }
}

/// Represents different stages of initialization
enum InitStage { fetchingExercises, downloadingImages, complete }
