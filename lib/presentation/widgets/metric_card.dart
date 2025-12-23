import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String change;
  final bool isPositive;
  final IconData icon;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.change,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: colorScheme.primary, size: 24),
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? colorScheme.tertiary : colorScheme.error,
                  size: 20,
                ),
              ],
            ),
            const Spacer(),
            Text('$value $unit', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(title, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              change,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isPositive ? colorScheme.tertiary : colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
