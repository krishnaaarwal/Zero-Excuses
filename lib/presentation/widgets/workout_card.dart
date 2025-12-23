import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String muscleGroup;
  final int exercises;
  final IconData icon;

  const WorkoutCard({
    super.key,
    required this.muscleGroup,
    required this.exercises,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(muscleGroup, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('$exercises exercises', style: theme.textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
