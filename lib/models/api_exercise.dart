import 'package:workout_app/models/api_meta.dart';

class ApiExercise {
  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final List<ApiMeta>? primaryMuscles;
  final List<ApiMeta>? secondaryMuscles;
  final List<ApiMeta>? types;
  final List<ApiMeta>? categories;
  final int? sets;
  final String? reps;

  ApiExercise({
    this.id,
    this.code,
    this.name,
    this.description,
    this.primaryMuscles,
    this.secondaryMuscles,
    this.types,
    this.categories,
    this.sets,
    this.reps,
  });

  // ✅ FROM JSON - deserialize from API or cache
  factory ApiExercise.fromJson(Map<String, dynamic> json) {
    return ApiExercise(
      id: json['id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      primaryMuscles: (json['primaryMuscles'] as List<dynamic>?)
          ?.map((e) => ApiMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
      secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>?)
          ?.map((e) => ApiMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => ApiMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => ApiMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
      sets: json['sets'] as int?,
      reps: json['reps'] as String?,
    );
  }

  // ✅ TO JSON - serialize for caching
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'primaryMuscles': primaryMuscles?.map((e) => e.toJson()).toList(),
      'secondaryMuscles': secondaryMuscles?.map((e) => e.toJson()).toList(),
      'types': types?.map((e) => e.toJson()).toList(),
      'categories': categories?.map((e) => e.toJson()).toList(),
      'sets': sets,
      'reps': reps,
    };
  }
}
