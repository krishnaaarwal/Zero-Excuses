import 'package:workout_app/Api/api_meta_cache.dart';
import 'package:workout_app/Api/exercise_api_service.dart';
import 'package:workout_app/models/api_meta.dart';

// Keys to identify different metadata types

const String musclesKey = 'muscles';
const String categoriesKey = 'categories';
const String typesKey = 'types';

class HiveRepository {
  final ExerciseApiService _api;
  final ApiMetaCache _cache;

  const HiveRepository(this._api, this._cache);

  // -------- MUSCLES --------
  Future<List<ApiMeta>> getMuscles() async {
    final cached = await _cache.get(musclesKey);

    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final fresh = await _api.fetchMuscles();
    await _cache.save(musclesKey, fresh);
    return fresh;
  }

  // -------- CATEGORIES --------
  Future<List<ApiMeta>> getCategories() async {
    final cached = await _cache.get(categoriesKey);

    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final fresh = await _api.fetchCategories();
    await _cache.save(categoriesKey, fresh);
    return fresh;
  }

  // -------- TYPES --------
  Future<List<ApiMeta>> getTypes() async {
    final cached = await _cache.get(typesKey);

    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final fresh = await _api.fetchTypes();
    await _cache.save(typesKey, fresh);
    return fresh;
  }
}
