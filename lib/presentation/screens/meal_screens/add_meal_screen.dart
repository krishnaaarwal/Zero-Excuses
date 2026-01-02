// lib/presentation/screens/add_meal_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/models/meal.dart';
import 'package:workout_app/providers.dart/diet_provider.dart';

class AddMealScreen extends ConsumerStatefulWidget {
  final Meal? meal; // If provided, we're editing

  const AddMealScreen({super.key, this.meal});

  @override
  ConsumerState<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _itemsController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatsController;

  String _selectedMealType = 'Breakfast';
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  void initState() {
    super.initState();

    // Initialize with existing meal data if editing
    if (widget.meal != null) {
      _selectedMealType = widget.meal!.mealType;
      _selectedTime = _parseTimeOfDay(widget.meal!.time);
      _itemsController = TextEditingController(text: widget.meal!.items);
      _caloriesController = TextEditingController(
        text: widget.meal!.calories.toString(),
      );
      _proteinController = TextEditingController(
        text: widget.meal!.protein.toString(),
      );
      _carbsController = TextEditingController(
        text: widget.meal!.carbs.toString(),
      );
      _fatsController = TextEditingController(
        text: widget.meal!.fats.toString(),
      );
    } else {
      _itemsController = TextEditingController();
      _caloriesController = TextEditingController();
      _proteinController = TextEditingController();
      _carbsController = TextEditingController();
      _fatsController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _itemsController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTimeOfDay(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minuteParts = parts[1].split(' ');
      var minute = int.parse(minuteParts[0]);

      if (minuteParts.length > 1 &&
          minuteParts[1].toUpperCase() == 'PM' &&
          hour != 12) {
        return TimeOfDay(hour: hour + 12, minute: minute);
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final meal = Meal(
        id: widget.meal?.id ?? 'meal_${DateTime.now().millisecondsSinceEpoch}',
        mealType: _selectedMealType,
        time: _formatTimeOfDay(_selectedTime),
        items: _itemsController.text.trim(),
        calories: int.parse(_caloriesController.text),
        protein: int.parse(_proteinController.text),
        carbs: int.parse(_carbsController.text),
        fats: int.parse(_fatsController.text),
        date: widget.meal?.date ?? DateTime.now(),
      );

      if (widget.meal != null) {
        await ref.read(todaysMealsProvider.notifier).updateMeal(meal);
      } else {
        await ref.read(todaysMealsProvider.notifier).addMeal(meal);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.meal != null ? 'Meal updated' : 'Meal added'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.meal != null ? 'Edit Meal' : 'Add Meal',
          style: theme.textTheme.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Type Selector
              Text('Meal Type', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _mealTypes.map((type) {
                  final isSelected = _selectedMealType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedMealType = type);
                      }
                    },
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Time Picker
              Text('Time', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        _formatTimeOfDay(_selectedTime),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Food Items
              Text('Food Items', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                controller: _itemsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g., Chicken Breast, Brown Rice, Broccoli',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.02),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter food items';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Nutrition Information
              Text('Nutrition Information', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildNutrientField(
                      controller: _caloriesController,
                      label: 'Calories',
                      hint: 'kcal',
                      icon: Icons.local_fire_department,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNutrientField(
                      controller: _proteinController,
                      label: 'Protein',
                      hint: 'g',
                      icon: Icons.egg_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildNutrientField(
                      controller: _carbsController,
                      label: 'Carbs',
                      hint: 'g',
                      icon: Icons.bakery_dining,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNutrientField(
                      controller: _fatsController,
                      label: 'Fats',
                      hint: 'g',
                      icon: Icons.water_drop_outlined,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMeal,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          widget.meal != null ? 'Update Meal' : 'Add Meal',
                          style: theme.textTheme.labelLarge,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.02),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            if (int.tryParse(value) == null) {
              return 'Invalid';
            }
            return null;
          },
        ),
      ],
    );
  }
}
