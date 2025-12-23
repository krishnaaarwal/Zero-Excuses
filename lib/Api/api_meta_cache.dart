import 'package:hive_ce/hive.dart';
import 'package:workout_app/models/api_meta.dart';

class ApiMetaCache {
  static const String _boxName = 'api_meta';

  Box<List<ApiMeta>>? _box;

  // Ensure box is opened once
  Future<Box<List<ApiMeta>>> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    _box = await Hive.openBox<List<ApiMeta>>(_boxName);
    return _box!;
  }

  // ---------- READ ----------
  Future<List<ApiMeta>?> get(String key) async {
    final box = await _getBox();
    return box.get(key);
  }

  // ---------- WRITE ----------
  Future<void> save(String key, List<ApiMeta> data) async {
    final box = await _getBox();
    await box.put(key, data);
  }

  // ---------- CHECK ----------
  Future<bool> contains(String key) async {
    final box = await _getBox();
    return box.containsKey(key);
  }

  // ---------- CLEAR (optional) ----------
  Future<void> clear() async {
    final box = await _getBox();
    await box.clear();
  }
}
