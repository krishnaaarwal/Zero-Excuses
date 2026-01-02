// lib/presentation/screens/diet_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/models/diet_nutrition_goals.dart';
import 'package:workout_app/models/meal.dart';
import 'package:workout_app/presentation/screens/meal_screens/add_meal_screen.dart';
import 'package:workout_app/presentation/widgets/meal_card.dart';
import 'package:workout_app/providers.dart/diet_provider.dart';

class DietScreen extends ConsumerWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final meals = ref.watch(todaysMealsProvider);
    final totals = ref.watch(dailyNutritionTotalsProvider);
    final goals = ref.watch(nutritionGoalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Diet", style: theme.textTheme.headlineMedium),
        actions: [
          if (meals.isEmpty)
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _addSampleMeals(context, ref),
              tooltip: 'Add Sample Meals',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daily Summary',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => _editGoals(context, ref, goals),
                        tooltip: 'Edit Goals',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNutrientColumn(
                          context,
                          'Calories',
                          totals.calories.toString(),
                          goals.caloriesTarget.toString(),
                          'kcal',
                          totals.calories / goals.caloriesTarget,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildNutrientColumn(
                          context,
                          'Protein',
                          totals.protein.toString(),
                          goals.proteinTarget.toString(),
                          'g',
                          totals.protein / goals.proteinTarget,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNutrientColumn(
                          context,
                          'Carbs',
                          totals.carbs.toString(),
                          goals.carbsTarget.toString(),
                          'g',
                          totals.carbs / goals.carbsTarget,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildNutrientColumn(
                          context,
                          'Fats',
                          totals.fats.toString(),
                          goals.fatsTarget.toString(),
                          'g',
                          totals.fats / goals.fatsTarget,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Meals Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Meals', style: theme.textTheme.headlineMedium),
                if (meals.isNotEmpty)
                  Text(
                    '${meals.length} meals today',
                    style: theme.textTheme.bodyMedium,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Meals List
            meals.isEmpty
                ? _buildEmptyState(context, theme)
                : Column(
                    children: meals.map((meal) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MealCard(
                          meal: meal,
                          onDelete: () => _deleteMeal(context, ref, meal),
                          onEdit: () => _editMeal(context, meal),
                        ),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addMeal(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No meals logged today',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your meals to monitor your nutrition',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientColumn(
    BuildContext context,
    String label,
    String current,
    String target,
    String unit,
    double progress,
  ) {
    final theme = Theme.of(context);
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          '$current / $target $unit',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: clampedProgress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 1.0 ? Colors.orange : Colors.white,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  void _addMeal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMealScreen()),
    );
  }

  void _editMeal(BuildContext context, Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMealScreen(meal: meal)),
    );
  }

  Future<void> _deleteMeal(
    BuildContext context,
    WidgetRef ref,
    Meal meal,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal'),
        content: Text('Delete ${meal.mealType}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await ref.read(todaysMealsProvider.notifier).deleteMeal(meal.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Meal deleted'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _addSampleMeals(BuildContext context, WidgetRef ref) async {
    await ref.read(todaysMealsProvider.notifier).addSampleMeals();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sample meals added'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _editGoals(
    BuildContext context,
    WidgetRef ref,
    DailyNutritionGoals currentGoals,
  ) async {
    final caloriesController = TextEditingController(
      text: currentGoals.caloriesTarget.toString(),
    );
    final proteinController = TextEditingController(
      text: currentGoals.proteinTarget.toString(),
    );
    final carbsController = TextEditingController(
      text: currentGoals.carbsTarget.toString(),
    );
    final fatsController = TextEditingController(
      text: currentGoals.fatsTarget.toString(),
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Nutrition Goals'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories Target (kcal)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Protein Target (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: carbsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Carbs Target (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: fatsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fats Target (g)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      final newGoals = DailyNutritionGoals(
        caloriesTarget:
            int.tryParse(caloriesController.text) ??
            currentGoals.caloriesTarget,
        proteinTarget:
            int.tryParse(proteinController.text) ?? currentGoals.proteinTarget,
        carbsTarget:
            int.tryParse(carbsController.text) ?? currentGoals.carbsTarget,
        fatsTarget:
            int.tryParse(fatsController.text) ?? currentGoals.fatsTarget,
      );

      await ref.read(nutritionGoalsProvider.notifier).updateGoals(newGoals);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Goals updated'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }

    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatsController.dispose();
  }
}
