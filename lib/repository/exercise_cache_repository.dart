import 'package:hive_ce/hive.dart';
import 'package:workout_app/Api/exercise_api_service.dart';
import 'package:workout_app/Exception/logger.dart';
import 'package:workout_app/models/api_exercise.dart';

// /// Handles fetching and caching ALL exercises locally
// class ExerciseCacheRepository {
//   final ExerciseApiService _api;
//   final Box _cache;

//   static const String allExercisesKey = 'all_exercises';
//   static const String lastFetchKey = 'last_fetch_timestamp';
//   static const Duration cacheExpiry = Duration(days: 30); // Refresh monthly

//   ExerciseCacheRepository(this._api, this._cache);

//   /// Check if exercises are already cached and valid
//   bool isCacheValid() {
//     final lastFetch = _cache.get(lastFetchKey);
//     if (lastFetch == null) return false;

//     final lastFetchDate = DateTime.fromMillisecondsSinceEpoch(lastFetch as int);
//     final isExpired = DateTime.now().difference(lastFetchDate) > cacheExpiry;

//     return !isExpired && _cache.containsKey(allExercisesKey);
//   }

//   /// Fetch all exercises from cache
//   Future<List<ApiExercise>?> getAllExercisesFromCache() async {
//     try {
//       if (!_cache.containsKey(allExercisesKey)) {
//         AppLogger.debug('No exercises in cache', tag: 'ExerciseCache');
//         return null;
//       }

//       final cached = _cache.get(allExercisesKey);
//       if (cached == null) return null;

//       final List<dynamic> cachedList = cached as List<dynamic>;
//       final exercises = cachedList
//           .map((item) => ApiExercise.fromJson(Map<String, dynamic>.from(item)))
//           .toList();

//       AppLogger.info(
//         'Loaded ${exercises.length} exercises from cache',
//         tag: 'ExerciseCache',
//       );
//       return exercises;
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Error loading cached exercises',
//         tag: 'ExerciseCache',
//         error: e,
//         stackTrace: stackTrace,
//       );
//       return null;
//     }
//   }

//   /// Fetch ALL exercises from API and cache them
//   Future<List<ApiExercise>> fetchAndCacheAllExercises({
//     bool forceRefresh = false,
//   }) async {
//     // Return cached if valid and not forcing refresh
//     if (!forceRefresh && isCacheValid()) {
//       final cached = await getAllExercisesFromCache();
//       if (cached != null) return cached;
//     }

//     AppLogger.info('Fetching all exercises from API...', tag: 'ExerciseCache');

//     try {
//       // Fetch from API
//       final exercises = await _api.getAllExercises();

//       AppLogger.info(
//         'Fetched ${exercises.length} exercises from API',
//         tag: 'ExerciseCache',
//       );

//       // Cache as JSON maps
//       final jsonList = exercises.map((e) => e.toJson()).toList();
//       await _cache.put(allExercisesKey, jsonList);
//       await _cache.put(lastFetchKey, DateTime.now().millisecondsSinceEpoch);

//       AppLogger.info(
//         '✅ Cached ${exercises.length} exercises successfully',
//         tag: 'ExerciseCache',
//       );

//       return exercises;
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Failed to fetch and cache exercises',
//         tag: 'ExerciseCache',
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }

//   /// Clear all cached exercises
//   Future<void> clearCache() async {
//     await _cache.delete(allExercisesKey);
//     await _cache.delete(lastFetchKey);
//     AppLogger.info('Exercise cache cleared', tag: 'ExerciseCache');
//   }

//   /// Get cache info for debugging
//   Map<String, dynamic> getCacheInfo() {
//     final lastFetch = _cache.get(lastFetchKey);
//     final hasExercises = _cache.containsKey(allExercisesKey);

//     return {
//       'has_exercises': hasExercises,
//       'is_valid': isCacheValid(),
//       'last_fetch': lastFetch != null
//           ? DateTime.fromMillisecondsSinceEpoch(lastFetch as int).toString()
//           : 'Never',
//       'cache_size': _cache.length,
//     };
//   }
// }

/// Repository for caching exercises in Hive
class ExerciseCacheRepository {
  final ExerciseApiService _apiService;
  final Box _cacheBox;

  static const String allExercisesKey = 'all_exercises';
  static const String lastFetchKey = 'last_fetch_timestamp';
  static const String cacheValidKey = 'cache_valid';

  ExerciseCacheRepository(this._apiService, this._cacheBox);

  /// Fetch all exercises from API and cache them
  /// Set forceRefresh = true to bypass cache
  Future<List<ApiExercise>> fetchAndCacheAllExercises({
    bool forceRefresh = false,
  }) async {
    try {
      AppLogger.info(
        '📥 Fetching and caching all exercises... (forceRefresh: $forceRefresh)',
        tag: 'Cache',
      );

      // Check if already cached and valid (unless force refresh)
      if (!forceRefresh && isCacheValid()) {
        AppLogger.info('Using cached exercises', tag: 'Cache');
        final cached = await getAllExercisesFromCache();
        return cached ?? [];
      }

      // Fetch from API
      final exercises = await _apiService.getAllExercises();

      // Convert to JSON for storage
      final exercisesJson = exercises.map((e) => e.toJson()).toList();

      // Store in Hive
      await _cacheBox.put(allExercisesKey, exercisesJson);
      await _cacheBox.put(lastFetchKey, DateTime.now().toIso8601String());
      await _cacheBox.put(cacheValidKey, true);

      AppLogger.info('✅ Cached ${exercises.length} exercises', tag: 'Cache');

      return exercises;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch and cache exercises',
        tag: 'Cache',
        error: e,
        stackTrace: stackTrace,
      );

      // Mark cache as invalid on error
      await _cacheBox.put(cacheValidKey, false);
      rethrow;
    }
  }

  /// Get all cached exercises from Hive
  /// Returns null if no cache exists
  Future<List<ApiExercise>?> getAllExercisesFromCache() async {
    try {
      final cached = _cacheBox.get(allExercisesKey);

      if (cached == null) {
        AppLogger.warning('No exercises in cache', tag: 'Cache');
        return null;
      }

      final List<dynamic> cachedList = cached as List<dynamic>;
      final exercises = cachedList
          .map((json) => ApiExercise.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.debug(
        'Retrieved ${exercises.length} exercises from cache',
        tag: 'Cache',
      );

      return exercises;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error reading cached exercises',
        tag: 'Cache',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Check if cache is valid and ready to use
  bool isCacheValid() {
    final isValid = _cacheBox.get(cacheValidKey, defaultValue: false) as bool;
    final hasData = _cacheBox.containsKey(allExercisesKey);
    return isValid && hasData;
  }

  /// Get cache information
  Map<String, dynamic> getCacheInfo() {
    final isValid = isCacheValid();
    final lastFetch = _cacheBox.get(lastFetchKey);

    int exerciseCount = 0;
    if (isValid) {
      final cached = _cacheBox.get(allExercisesKey);
      if (cached != null && cached is List) {
        exerciseCount = cached.length;
      }
    }

    return {
      'is_valid': isValid,
      'exercise_count': exerciseCount,
      'last_fetch': lastFetch,
    };
  }

  /// Clear all cached exercises
  Future<void> clearCache() async {
    await _cacheBox.delete(allExercisesKey);
    await _cacheBox.delete(lastFetchKey);
    await _cacheBox.delete(cacheValidKey);
    AppLogger.info('🗑️ Cleared exercise cache', tag: 'Cache');
  }

  /// Get when exercises were last fetched
  DateTime? getLastFetchTime() {
    final timestamp = _cacheBox.get(lastFetchKey);
    if (timestamp == null) return null;
    return DateTime.tryParse(timestamp);
  }
}
