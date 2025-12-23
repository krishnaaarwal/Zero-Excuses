import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String workout;
  final String exercises;
  final int calories;
  final int totalCalories;
  final double progress;

  const PlanCard({
    super.key,
    required this.title,
    required this.workout,
    required this.exercises,
    required this.calories,
    required this.totalCalories,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text('Workout', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(workout, style: theme.textTheme.titleMedium),
                      Text(exercises, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: colorScheme.surfaceContainerHighest,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 20,
                            color: colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Text('Diet', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$calories / $totalCalories',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text('kcal', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
