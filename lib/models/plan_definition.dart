import 'day_rule.dart';

class PlanDefinition {
  final String id;
  final String name;
  final int totalDays;
  final List<DayRule?> weeklyRules;

  // Optional metadata (standard plans use these)
  final String? frequency;
  final String? duration;
  final String? level;
  final String? description;

  // Used to distinguish UI behavior
  final bool isChallenge;

  final String? structure;
  final String? restDays;
  final String? expectation;

  const PlanDefinition({
    required this.id,
    required this.name,
    required this.totalDays,
    required this.weeklyRules,
    this.frequency,
    this.duration,
    this.level,
    this.description,
    this.isChallenge = false,
    this.structure,
    this.restDays,
    this.expectation,
  });
}
