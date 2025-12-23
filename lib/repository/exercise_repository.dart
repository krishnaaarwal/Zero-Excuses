import 'package:workout_app/Exception/logger.dart';
import 'package:workout_app/models/api_exercise.dart';
import 'package:workout_app/models/workout_day.dart';
import 'package:workout_app/repository/exercise_cache_repository.dart';

/// Repository for filtering exercises locally from cached data
class ExerciseRepository {
  final ExerciseCacheRepository _cacheRepo;

  ExerciseRepository(this._cacheRepo);

  /// Get exercises for a specific workout day by filtering locally
  Future<List<ApiExercise>> getExercisesForDay(WorkoutDay day) async {
    AppLogger.debug(
      'Getting exercises for day ${day.day}',
      tag: 'ExerciseRepo',
    );
    AppLogger.debug(
      'Filters - Muscles: ${day.muscles}, Categories: ${day.categories}, Types: ${day.types}',
      tag: 'ExerciseRepo',
    );

    // Get all cached exercises
    final allExercises = await _cacheRepo.getAllExercisesFromCache();

    if (allExercises == null || allExercises.isEmpty) {
      throw Exception(
        'No exercises found in cache. Please ensure exercises are downloaded first.',
      );
    }

    AppLogger.info(
      'Filtering from ${allExercises.length} total exercises',
      tag: 'ExerciseRepo',
    );

    // Filter exercises locally
    final filtered = _filterExercises(
      allExercises,
      muscles: day.muscles,
      categories: day.categories,
      types: day.types,
    );

    AppLogger.info(
      '✅ Found ${filtered.length} exercises matching filters',
      tag: 'ExerciseRepo',
    );

    return filtered;
  }

  /// Filter exercises based on muscles, categories, and types
  List<ApiExercise> _filterExercises(
    List<ApiExercise> exercises, {
    required List<String> muscles,
    required List<String> categories,
    required List<String> types,
  }) {
    return exercises.where((exercise) {
      // Check muscles (primary or secondary)
      bool matchesMuscles = muscles.isEmpty;
      if (!matchesMuscles && muscles.isNotEmpty) {
        for (var muscle in muscles) {
          // Check primary muscles
          if (exercise.primaryMuscles != null) {
            matchesMuscles = exercise.primaryMuscles!.any(
              (m) => m.code?.toLowerCase() == muscle.toLowerCase(),
            );
          }

          // Check secondary muscles if not found in primary
          if (!matchesMuscles && exercise.secondaryMuscles != null) {
            matchesMuscles = exercise.secondaryMuscles!.any(
              (m) => m.code?.toLowerCase() == muscle.toLowerCase(),
            );
          }

          if (matchesMuscles) break;
        }
      }

      // Check categories
      bool matchesCategories = categories.isEmpty;
      if (!matchesCategories &&
          categories.isNotEmpty &&
          exercise.categories != null) {
        matchesCategories = exercise.categories!.any(
          (c) => categories.any(
            (filter) => c.code?.toLowerCase() == filter.toLowerCase(),
          ),
        );
      }

      // Check types
      bool matchesTypes = types.isEmpty;
      if (!matchesTypes && types.isNotEmpty && exercise.types != null) {
        matchesTypes = exercise.types!.any(
          (t) => types.any(
            (filter) => t.code?.toLowerCase() == filter.toLowerCase(),
          ),
        );
      }

      // Return true only if all non-empty filters match
      return (muscles.isEmpty || matchesMuscles) &&
          (categories.isEmpty || matchesCategories) &&
          (types.isEmpty || matchesTypes);
    }).toList();
  }

  /// Get all cached exercises (for debugging or display)
  Future<List<ApiExercise>> getAllExercises() async {
    final exercises = await _cacheRepo.getAllExercisesFromCache();
    return exercises ?? [];
  }

  /// Check if exercises are cached and ready
  Future<bool> isReady() async {
    return _cacheRepo.isCacheValid();
  }

  /// Force refresh all exercises from API
  Future<List<ApiExercise>> refreshExercises() async {
    return await _cacheRepo.fetchAndCacheAllExercises(forceRefresh: true);
  }
}
