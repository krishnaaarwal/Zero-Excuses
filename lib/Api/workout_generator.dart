import '../models/day_rule.dart';
import '../models/workout_day.dart';

List<WorkoutDay> generateWorkoutDays({
  required int totalDays,
  required List<DayRule?> weeklyRules,
}) {
  final List<WorkoutDay> days = [];

  for (int i = 0; i < totalDays; i++) {
    final rule = weeklyRules[i % weeklyRules.length];

    if (rule == null) {
      days.add(
        WorkoutDay(
          day: i + 1,
          muscles: const [],
          categories: const [],
          types: const [],
        ),
      );
    } else {
      days.add(
        WorkoutDay(
          day: i + 1,
          muscles: rule.muscles,
          categories: rule.categories,
          types: rule.types,
        ),
      );
    }
  }

  return days;
}
