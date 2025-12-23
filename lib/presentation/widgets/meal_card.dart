import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String mealType;
  final String time;
  final String items;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;

  const MealCard({
    super.key,
    required this.mealType,
    required this.time,
    required this.items,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  IconData _getMealIcon() {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny_outlined;
      case 'lunch':
        return Icons.wb_twilight_outlined;
      case 'snacks':
        return Icons.fastfood_outlined;
      case 'dinner':
        return Icons.nightlight_outlined;
      default:
        return Icons.restaurant_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: () {
          _showMealDetails(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getMealIcon(),
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mealType, style: theme.textTheme.titleMedium),
                        Text(time, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Text(
                    '$calories kcal',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                items,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacroChip(context, 'P', protein, 'g'),
                  _buildMacroChip(context, 'C', carbs, 'g'),
                  _buildMacroChip(context, 'F', fats, 'g'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroChip(
    BuildContext context,
    String label,
    int value,
    String unit,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value$unit',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showMealDetails(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(mealType, style: theme.textTheme.headlineMedium),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(time, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
              Text('Items', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(items, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              Text('Macronutrients', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMacroDetail(context, 'Calories', '$calories', 'kcal'),
                  _buildMacroDetail(context, 'Protein', '$protein', 'g'),
                  _buildMacroDetail(context, 'Carbs', '$carbs', 'g'),
                  _buildMacroDetail(context, 'Fats', '$fats', 'g'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroDetail(
    BuildContext context,
    String label,
    String value,
    String unit,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineMedium),
        Text(unit, style: theme.textTheme.bodyMedium),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
