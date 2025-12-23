// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:workout_app/Api/workout_generator.dart';
import 'package:workout_app/models/active_plan.dart';
import 'package:workout_app/models/plan_definition.dart';
import 'package:workout_app/presentation/screens/plans_screens/plan_list.dart';
import 'package:workout_app/presentation/screens/profile_screen.dart';
import 'package:workout_app/presentation/widgets/plan_card.dart';
import 'package:workout_app/presentation/widgets/primary_button.dart';
import 'package:workout_app/presentation/widgets/secondary_outline_button.dart';
import 'package:workout_app/presentation/widgets/stat_card.dart';
import 'package:workout_app/presentation/widgets/workout_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  PlanDefinition? _findPlanById(String id) {
    final allPlans = <PlanDefinition>[
      beginnerFatLossPlan,
      hiitFatBurnPlan,
      cardioWeightLossPlan,
      fullBodyBeginnerPlan,
      pplPlan,
      broSplitPlan,
      twentyOneDayFatLossChallenge,
      hundredPushupChallengePlan,
      // etc
    ];

    try {
      return allPlans.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Box>(
          future: Hive.openBox('active_plan_box'),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final box = snap.data!;
            final data = box.get('active_plan_box');
            final ActivePlan? active = data == null
                ? null
                : ActivePlan.fromMap(Map<String, dynamic>.from(data));

            // compute today workout summary
            String workoutSummary = 'No active plan';
            String exercisesCount = '-';
            double progress = 0.0;
            int streak = 0;

            if (active != null) {
              final plan = _findPlanById(active.planId);
              if (plan != null) {
                final days = generateWorkoutDays(
                  totalDays: plan.totalDays,
                  weeklyRules: plan.weeklyRules,
                );
                final currentIndex = (active.currentDay - 1).clamp(
                  0,
                  days.length - 1,
                );
                final today = days[currentIndex];
                workoutSummary = today.muscles.isEmpty
                    ? 'Rest Day'
                    : today.muscles.join(', ');
                exercisesCount = today.muscles.isEmpty
                    ? '0 exercises'
                    : '${today.muscles.length} groups';
                progress = active.currentDay / plan.totalDays;
                streak = active.streak;
              } else {
                workoutSummary = active.planName;
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hey Krishna 👋',
                            style: theme.textTheme.displaySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ready to crush today?',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: colorScheme.primary,
                          child: Text(
                            'K',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Today's Plan Card (dynamic)
                  PlanCard(
                    title: active != null ? "Today's Plan" : "No Active Plan",
                    workout: workoutSummary,
                    exercises: exercisesCount,
                    calories: 1600,
                    totalCalories: 2000,
                    progress: progress,
                  ),

                  const SizedBox(height: 24),

                  // Streak Card (dynamic)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.tertiary,
                          colorScheme.tertiary.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.local_fire_department,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Streak: ${streak} days 🔥',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress.clamp(0.0, 1.0),
                                  backgroundColor: Colors.white.withOpacity(
                                    0.3,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Today's Workout Section (horizontal summary)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Workout",
                        style: theme.textTheme.headlineMedium,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        WorkoutCard(
                          muscleGroup: workoutSummary,
                          exercises: workoutSummary == 'Rest Day' ? 0 : 1,
                          icon: Icons.fitness_center,
                        ),
                        const SizedBox(width: 16),
                        const WorkoutCard(
                          muscleGroup: 'Triceps',
                          exercises: 3,
                          icon: Icons.sports_gymnastics,
                        ),
                        const SizedBox(width: 16),
                        const WorkoutCard(
                          muscleGroup: 'Cardio',
                          exercises: 2,
                          icon: Icons.directions_run,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Workouts',
                          value: '12',
                          subtitle: 'This week',
                          icon: Icons.fitness_center,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: 'Calories',
                          value: '2.1k',
                          subtitle: 'Burned',
                          icon: Icons.local_fire_department,
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // CTA Buttons
                  PrimaryButton(
                    text: 'Start Workout',
                    onPressed: () {},
                    icon: Icons.play_arrow,
                  ),
                  const SizedBox(height: 12),
                  SecondaryOutlineButton(
                    text: 'Log Weight',
                    onPressed: () {},
                    icon: Icons.scale,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
