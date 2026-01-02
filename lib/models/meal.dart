// lib/models/meal.dart
import 'package:hive_ce/hive.dart';

part 'meal.g.dart';

@HiveType(typeId: 2)
class Meal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String mealType;

  @HiveField(2)
  final String time;

  @HiveField(3)
  final String items;

  @HiveField(4)
  final int calories;

  @HiveField(5)
  final int protein;

  @HiveField(6)
  final int carbs;

  @HiveField(7)
  final int fats;

  @HiveField(8)
  final DateTime date;

  Meal({
    required this.id,
    required this.mealType,
    required this.time,
    required this.items,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.date,
  });

  Meal copyWith({
    String? id,
    String? mealType,
    String? time,
    String? items,
    int? calories,
    int? protein,
    int? carbs,
    int? fats,
    DateTime? date,
  }) {
    return Meal(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      time: time ?? this.time,
      items: items ?? this.items,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      date: date ?? this.date,
    );
  }
}
