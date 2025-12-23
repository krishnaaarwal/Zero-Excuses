import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:workout_app/Api/workout_generator.dart';
import 'package:workout_app/models/plan_definition.dart';
import 'package:workout_app/models/workout_day.dart';
import 'package:workout_app/presentation/widgets/primary_button.dart';
import 'package:workout_app/repository/active_plan_repository.dart';

class PlanScreen extends StatelessWidget {
  final PlanDefinition plan;

  const PlanScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    const String activePlanBox = 'active_plan_box';
    final List<WorkoutDay> days = generateWorkoutDays(
      totalDays: plan.totalDays,
      weeklyRules: plan.weeklyRules,
    );

    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];

          final isRestDay = day.muscles.isEmpty;

          return ListTile(
            title: Text(
              isRestDay
                  ? 'Day ${day.day} • Rest'
                  : 'Day ${day.day} • ${day.muscles.join(', ')}',
            ),
            subtitle: isRestDay
                ? const Text('Recovery day')
                : Text(
                    'Categories: ${day.categories.join(', ')}\n'
                    'Types: ${day.types.join(', ')}',
                  ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: 'Start This Plan',
          icon: Icons.play_arrow,
          onPressed: () async {
            final repo = ActivePlanRepository(
              await Hive.openBox(activePlanBox),
            );

            await repo.startPlan(plan);

            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
