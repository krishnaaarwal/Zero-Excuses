import 'package:flutter/material.dart';
import 'package:workout_app/presentation/screens/plans_screens/plans_screen.dart';

import '../../../models/plan_definition.dart';
import '../../widgets/primary_button.dart';

class PlanOverviewChallengeScreen extends StatelessWidget {
  final PlanDefinition plan;

  const PlanOverviewChallengeScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.blue],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🔥 CHALLENGE MODE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          plan.name,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${plan.totalDays} Days • No Excuses',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Challenge Rules',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),

                  _rule('Complete workout every day'),
                  _rule('No skipping days'),
                  _rule('Focus on proper form'),
                  _rule('Track your progress'),

                  const SizedBox(height: 24),

                  Text('Warning', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'This challenge is intense. If you quit halfway, it resets.',
                    ),
                  ),

                  const SizedBox(height: 32),

                  PrimaryButton(
                    text: 'Start Challenge',
                    icon: Icons.local_fire_department,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlanScreen(plan: plan),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rule(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
