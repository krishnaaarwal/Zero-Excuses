import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:workout_app/Api/exercise_api_service.dart';
import 'package:workout_app/Api/workout_generator.dart';
import 'package:workout_app/Exception/debug_screen.dart';
import 'package:workout_app/models/active_plan.dart';
import 'package:workout_app/models/api_exercise.dart';
import 'package:workout_app/models/plan_definition.dart';
import 'package:workout_app/presentation/screens/plans_screens/challenge_plan_overview_screen.dart';
import 'package:workout_app/presentation/screens/plans_screens/plan_list.dart';
import 'package:workout_app/presentation/screens/plans_screens/standard_plans_overview.dart';
import 'package:workout_app/presentation/screens/session_screen.dart';
import 'package:workout_app/presentation/widgets/exercise_row.dart';
import 'package:workout_app/presentation/widgets/primary_button.dart';
import 'package:workout_app/repository/active_plan_repository.dart';
import 'package:workout_app/repository/exercise_cache_repository.dart';
import 'package:workout_app/repository/exercise_repository.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Box names
  static const String activePlanBoxName = 'active_plan_box';
  static const String exerciseCacheBoxName = 'exercise_cache_box';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts', style: theme.textTheme.headlineMedium),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Plans'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTodayTab(context), _buildPlansTab(context)],
      ),
    );
  }

  // TODAY TAB - Uses cached exercises with filtering
  Widget _buildTodayTab(BuildContext context) {
    return FutureBuilder<Box>(
      future: Hive.openBox(activePlanBoxName),
      builder: (context, snapActiveBox) {
        if (snapActiveBox.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapActiveBox.hasError) {
          return Center(
            child: Text('Error loading active plan: ${snapActiveBox.error}'),
          );
        }

        final activeBox = snapActiveBox.data!;
        final activeRepo = ActivePlanRepository(activeBox);
        final active = activeRepo.getActivePlan();

        if (active == null) {
          return _noActivePlanState(context);
        }

        final plan = _findPlanById(active.planId);
        if (plan == null) {
          return _planNotFoundError(context, activeRepo, active);
        }

        final days = generateWorkoutDays(
          totalDays: plan.totalDays,
          weeklyRules: plan.weeklyRules,
        );

        final currentIndex = (active.currentDay - 1).clamp(0, days.length - 1);
        final today = days[currentIndex];

        // Handle rest days
        if (today.muscles.isEmpty) {
          return _restDayView(context, activeRepo, active, plan);
        }

        // Load exercises from cache using repository
        return FutureBuilder<Box>(
          future: Hive.openBox(exerciseCacheBoxName),
          builder: (context, snapCacheBox) {
            if (snapCacheBox.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapCacheBox.hasError) {
              return Center(
                child: Text('Error opening cache: ${snapCacheBox.error}'),
              );
            }

            final cacheBox = snapCacheBox.data!;
            final cacheRepo = ExerciseCacheRepository(
              ExerciseApiService(),
              cacheBox,
            );
            final exerciseRepo = ExerciseRepository(cacheRepo);

            return FutureBuilder<List<ApiExercise>>(
              future: exerciseRepo.getExercisesForDay(today),
              builder: (context, snapExercises) {
                if (snapExercises.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading exercises...'),
                      ],
                    ),
                  );
                }

                if (snapExercises.hasError) {
                  return _exerciseErrorState(context, snapExercises.error);
                }

                final exercises = snapExercises.data ?? [];

                if (exercises.isEmpty) {
                  return _noExercisesFound(context, today);
                }

                return _buildWorkoutView(
                  context,
                  plan,
                  active,
                  activeRepo,
                  today,
                  exercises,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _planNotFoundError(
    BuildContext context,
    ActivePlanRepository repo,
    ActivePlan active,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Active plan not found (id: ${active.planId})'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await repo.clear();
              setState(() {});
            },
            child: const Text('Clear Active Plan'),
          ),
        ],
      ),
    );
  }

  Widget _exerciseErrorState(BuildContext context, Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading exercises',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('Retry'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ApiDebugScreen()),
                );
              },
              child: const Text('Debug Screen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noExercisesFound(BuildContext context, dynamic today) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 48),
            const SizedBox(height: 16),
            Text(
              'No exercises found for:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('Muscles: ${today.muscles.join(", ")}'),
            Text('Categories: ${today.categories.join(", ")}'),
            Text('Types: ${today.types.join(", ")}'),
            const SizedBox(height: 24),
            const Text(
              'Try a different plan or check your filter settings.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutView(
    BuildContext context,
    PlanDefinition plan,
    ActivePlan active,
    ActivePlanRepository activeRepo,
    dynamic today,
    List<ApiExercise> exercises,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _todayHeader(context, plan, active),
              const SizedBox(height: 12),
              _buildWorkoutSection(
                context,
                today.muscles.join(', '),
                exercises,
                today.types, // Pass types to determine sets/reps
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Start Session',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SessionScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () async {
                  await activeRepo.completeDay();
                  setState(() {});
                },
                child: const Text('Complete'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _todayHeader(
    BuildContext context,
    PlanDefinition plan,
    ActivePlan active,
  ) {
    final theme = Theme.of(context);
    final progress = (active.currentDay / (plan.totalDays));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(plan.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Day ${active.currentDay} • ${plan.totalDays} days',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress),
      ],
    );
  }

  Widget _noActivePlanState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No active plan', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            const Text(
              'Choose a plan to get started. Your Today tab will show exercises automatically.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Browse Plans',
              icon: Icons.list,
              onPressed: () {
                _tabController.animateTo(1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _restDayView(
    BuildContext context,
    ActivePlanRepository repo,
    ActivePlan active,
    PlanDefinition plan,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _todayHeader(context, plan, active),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Rest Day', style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(
                        'Take it easy today. Focus on mobility, hydration, and sleep.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Suggested activities: Light walk, stretching, foam rolling.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Mark Rest Done',
                  icon: Icons.check,
                  onPressed: () async {
                    await repo.completeDay();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutSection(
    BuildContext context,
    String muscleGroup,
    List<ApiExercise> exercises,
    List<String> types, // Use types to determine sets/reps
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Helper functions to get default sets/reps based on workout types
    int getDefaultSets(List<String> types) {
      if (types.contains('HIIT')) return 4;
      if (types.contains('ENDURANCE')) return 3;
      if (types.contains('COMPOUND')) return 4;
      if (types.contains('ISOLATION')) return 3;
      return 3;
    }

    String getDefaultReps(List<String> types) {
      if (types.contains('HIIT')) return '30 seconds';
      if (types.contains('ENDURANCE')) return '45 seconds';
      if (types.contains('COMPOUND')) return '8-12';
      if (types.contains('ISOLATION')) return '10-15';
      if (types.contains('CORE')) return '15-20';
      return '10-12';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            muscleGroup.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...exercises.map(
          (exercise) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExerciseRow(
              name: exercise.name ?? 'Exercise',
              sets: '${getDefaultSets(types)} sets',
              reps: getDefaultReps(types),
              isDone: false,
            ),
          ),
        ),
      ],
    );
  }

  // PLANS TAB (unchanged)
  Widget _buildPlansTab(BuildContext context) {
    final fatLossPlans = [
      _planItem(beginnerFatLossPlan, 'standard'),
      _planItem(hiitFatBurnPlan, 'standard'),
      _planItem(cardioWeightLossPlan, 'standard'),
    ];

    final musclePlans = [
      _planItem(fullBodyBeginnerPlan, 'standard'),
      _planItem(pplPlan, 'standard'),
      _planItem(broSplitPlan, 'standard'),
    ];

    final challengePlans = [
      _planItem(twentyOneDayFatLossChallenge, 'challenge'),
      _planItem(hundredPushupChallengePlan, 'challenge'),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section('FAT LOSS / WEIGHT LOSS', context),
          listItems(context, fatLossPlans),
          _section('MUSCLE GAIN / BODYBUILDING', context),
          listItems(context, musclePlans),
          _section('CHALLENGES', context),
          listItems(context, challengePlans),
        ],
      ),
    );
  }

  Map<String, dynamic> _planItem(PlanDefinition plan, String type) {
    return {'plan': plan, 'type': type};
  }

  Widget _section(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

// Plan list item builder (unchanged)
Widget listItems(BuildContext context, List<Map<String, dynamic>> plans) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: plans.length,
    itemBuilder: (context, index) {
      final item = plans[index];
      final PlanDefinition plan = item['plan'];
      final String type = item['type'];

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (type == 'challenge') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlanOverviewChallengeScreen(plan: plan),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlanOverviewStandardScreen(plan: plan),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.fitness_center, color: colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(_subtitle(plan), style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      );
    },
  );
}

String _subtitle(PlanDefinition plan) {
  final freq = plan.frequency;
  final dur = plan.duration;

  if (freq == null && dur == null) return '${plan.totalDays} days';
  if (freq != null && dur != null) return '$freq • $dur';
  return freq ?? dur ?? '';
}
