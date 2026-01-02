// lib/providers/diet_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_ce/hive.dart';
import 'package:workout_app/models/diet_nutrition_goals.dart';
import 'package:workout_app/models/diet_nutrition_tools.dart';
import 'package:workout_app/models/meal.dart';

// Hive box provider for meals
final mealsBoxProvider = Provider<Box>((ref) {
  return Hive.box('meals_box');
});

// Hive box provider for nutrition goals
final nutritionGoalsBoxProvider = Provider<Box>((ref) {
  return Hive.box('nutrition_goals_box');
});

// Nutrition goals provider
final nutritionGoalsProvider =
    StateNotifierProvider<NutritionGoalsNotifier, DailyNutritionGoals>((ref) {
      final box = ref.watch(nutritionGoalsBoxProvider);
      return NutritionGoalsNotifier(box);
    });

class NutritionGoalsNotifier extends StateNotifier<DailyNutritionGoals> {
  final Box _box;
  static const String _goalsKey = 'daily_nutrition_goals';

  NutritionGoalsNotifier(this._box) : super(_loadGoals(_box));

  static DailyNutritionGoals _loadGoals(Box box) {
    final saved = box.get(_goalsKey);
    if (saved is DailyNutritionGoals) {
      return saved;
    }
    // Default goals
    return DailyNutritionGoals(
      caloriesTarget: 2000,
      proteinTarget: 120,
      carbsTarget: 200,
      fatsTarget: 60,
    );
  }

  Future<void> updateGoals(DailyNutritionGoals goals) async {
    await _box.put(_goalsKey, goals);
    state = goals;
  }
}

// Meals provider - provides all meals for today
final todaysMealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((
  ref,
) {
  final box = ref.watch(mealsBoxProvider);
  return MealsNotifier(box);
});

class MealsNotifier extends StateNotifier<List<Meal>> {
  final Box _box;

  MealsNotifier(this._box) : super([]) {
    _loadTodaysMeals();
  }

  void _loadTodaysMeals() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final allMeals = _box.values.whereType<Meal>().toList();
    final todaysMeals = allMeals.where((meal) {
      final mealDate = DateTime(meal.date.year, meal.date.month, meal.date.day);
      return mealDate.isAtSameMomentAs(today);
    }).toList();

    // Sort by time
    todaysMeals.sort(
      (a, b) => _parseTime(a.time).compareTo(_parseTime(b.time)),
    );
    state = todaysMeals;
  }

  DateTime _parseTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minuteParts = parts[1].split(' ');
      var minute = int.parse(minuteParts[0]);

      if (minuteParts.length > 1 &&
          minuteParts[1].toUpperCase() == 'PM' &&
          hour != 12) {
        return DateTime(0, 1, 1, hour + 12, minute);
      }
      return DateTime(0, 1, 1, hour, minute);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> addMeal(Meal meal) async {
    await _box.put(meal.id, meal);
    _loadTodaysMeals();
  }

  Future<void> updateMeal(Meal meal) async {
    await _box.put(meal.id, meal);
    _loadTodaysMeals();
  }

  Future<void> deleteMeal(String id) async {
    await _box.delete(id);
    _loadTodaysMeals();
  }

  Future<void> addSampleMeals() async {
    final now = DateTime.now();
    final sampleMeals = [
      Meal(
        id: 'meal_1_${now.millisecondsSinceEpoch}',
        mealType: 'Breakfast',
        time: '8:00 AM',
        items: 'Oats, Banana, Milk, Almonds',
        calories: 450,
        protein: 18,
        carbs: 65,
        fats: 12,
        date: now,
      ),
      Meal(
        id: 'meal_2_${now.millisecondsSinceEpoch}',
        mealType: 'Lunch',
        time: '1:00 PM',
        items: 'Chicken Breast, Brown Rice, Broccoli',
        calories: 550,
        protein: 45,
        carbs: 60,
        fats: 10,
        date: now,
      ),
      Meal(
        id: 'meal_3_${now.millisecondsSinceEpoch}',
        mealType: 'Snacks',
        time: '4:00 PM',
        items: 'Protein Shake, Apple',
        calories: 200,
        protein: 25,
        carbs: 15,
        fats: 3,
        date: now,
      ),
      Meal(
        id: 'meal_4_${now.millisecondsSinceEpoch}',
        mealType: 'Dinner',
        time: '7:30 PM',
        items: 'Grilled Fish, Quinoa, Mixed Vegetables',
        calories: 480,
        protein: 40,
        carbs: 45,
        fats: 15,
        date: now,
      ),
    ];

    for (final meal in sampleMeals) {
      await _box.put(meal.id, meal);
    }
    _loadTodaysMeals();
  }
}

// Daily totals provider
final dailyNutritionTotalsProvider = Provider<DailyNutritionTotals>((ref) {
  final meals = ref.watch(todaysMealsProvider);

  var totalCalories = 0;
  var totalProtein = 0;
  var totalCarbs = 0;
  var totalFats = 0;

  for (final meal in meals) {
    totalCalories += meal.calories;
    totalProtein += meal.protein;
    totalCarbs += meal.carbs;
    totalFats += meal.fats;
  }

  return DailyNutritionTotals(
    calories: totalCalories,
    protein: totalProtein,
    carbs: totalCarbs,
    fats: totalFats,
  );
});
