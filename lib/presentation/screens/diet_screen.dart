import 'package:flutter/material.dart';

import '../widgets/meal_card.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Diet", style: theme.textTheme.headlineMedium),
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
                  Text(
                    'Daily Summary',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNutrientColumn(
                          context,
                          'Calories',
                          '1200',
                          '2000',
                          'kcal',
                          0.6,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildNutrientColumn(
                          context,
                          'Protein',
                          '60',
                          '120',
                          'g',
                          0.5,
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
                          '140',
                          '200',
                          'g',
                          0.7,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildNutrientColumn(
                          context,
                          'Fats',
                          '35',
                          '60',
                          'g',
                          0.58,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Meals Section
            Text('Meals', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            const MealCard(
              mealType: 'Breakfast',
              time: '8:00 AM',
              items: 'Oats, Banana, Milk, Almonds',
              calories: 450,
              protein: 18,
              carbs: 65,
              fats: 12,
            ),
            const SizedBox(height: 12),
            const MealCard(
              mealType: 'Lunch',
              time: '1:00 PM',
              items: 'Chicken Breast, Brown Rice, Broccoli',
              calories: 550,
              protein: 45,
              carbs: 60,
              fats: 10,
            ),
            const SizedBox(height: 12),
            const MealCard(
              mealType: 'Snacks',
              time: '4:00 PM',
              items: 'Protein Shake, Apple',
              calories: 200,
              protein: 25,
              carbs: 15,
              fats: 3,
            ),
            const SizedBox(height: 12),
            const MealCard(
              mealType: 'Dinner',
              time: '7:30 PM',
              items: 'Grilled Fish, Quinoa, Mixed Vegetables',
              calories: 480,
              protein: 40,
              carbs: 45,
              fats: 15,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
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
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
