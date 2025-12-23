import 'package:hive_ce/hive.dart';
import 'package:workout_app/models/api_meta.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(ApiMetaAdapter());
  }
}
