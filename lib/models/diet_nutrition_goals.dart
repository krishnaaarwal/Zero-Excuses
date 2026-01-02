// lib/models/diet_nutrition_goals.dart
import 'package:hive_ce/hive.dart';

part 'diet_nutrition_goals.g.dart';

@HiveType(typeId: 3)
class DailyNutritionGoals extends HiveObject {
  @HiveField(0)
  final int caloriesTarget;

  @HiveField(1)
  final int proteinTarget;

  @HiveField(2)
  final int carbsTarget;

  @HiveField(3)
  final int fatsTarget;

  DailyNutritionGoals({
    required this.caloriesTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatsTarget,
  });

  DailyNutritionGoals copyWith({
    int? caloriesTarget,
    int? proteinTarget,
    int? carbsTarget,
    int? fatsTarget,
  }) {
    return DailyNutritionGoals(
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      fatsTarget: fatsTarget ?? this.fatsTarget,
    );
  }
}
