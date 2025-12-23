import 'package:workout_app/models/day_rule.dart';
import 'package:workout_app/models/plan_definition.dart';

/// ---------------- FAT LOSS ----------------

final beginnerFatLossPlan = PlanDefinition(
  id: 'fat_loss_1',
  name: 'Beginner Fat Loss (No Equipment)',
  totalDays: 30,
  frequency: '5 days/week',
  duration: '25–35 min',
  level: 'Beginner',
  description:
      'Burn calories, build consistency, and develop a basic fitness habit.',
  structure: 'Full Body → Lower Body → Rest → Upper Body → Core → Rest → Rest',
  restDays: '2-3 days per week',
  expectation:
      'Build consistent workout habits with no equipment needed. Perfect for beginners starting their fitness journey.',
  weeklyRules: [
    DayRule(
      muscles: ['FULL_BODY'],
      categories: ['BODYWEIGHT'],
      types: ['CIRCUIT'],
    ),
    DayRule(
      muscles: ['LOWER_BODY'],
      categories: ['BODYWEIGHT'],
      types: ['HIIT'],
    ),
    null,
    DayRule(
      muscles: ['UPPER_BODY'],
      categories: ['BODYWEIGHT'],
      types: ['CIRCUIT'],
    ),
    DayRule(muscles: ['CORE'], categories: ['BODYWEIGHT'], types: ['CORE']),
    null,
    null,
  ],
);

final hiitFatBurnPlan = PlanDefinition(
  id: 'fat_loss_2',
  name: 'HIIT Fat Burn',
  totalDays: 28,
  frequency: '4 days/week',
  duration: '20–30 min',
  level: 'Intermediate',
  description: 'High-intensity fat burning workouts.',
  structure:
      'HIIT Full Body → Rest → HIIT Lower Body → Rest → HIIT Core → Rest → Rest',
  restDays: '3-4 days per week',
  expectation:
      'Maximize calorie burn with high-intensity intervals. Expect to be challenged but see rapid results.',
  weeklyRules: [
    DayRule(
      muscles: ['FULL_BODY'],
      categories: ['BODYWEIGHT'],
      types: ['HIIT'],
    ),
    null,
    DayRule(
      muscles: ['LOWER_BODY'],
      categories: ['BODYWEIGHT'],
      types: ['HIIT'],
    ),
    null,
    DayRule(muscles: ['CORE'], categories: ['BODYWEIGHT'], types: ['HIIT']),
    null,
    null,
  ],
);

final cardioWeightLossPlan = PlanDefinition(
  id: 'fat_loss_3',
  name: 'Cardio-Based Weight Loss',
  totalDays: 42,
  frequency: '5–6 days/week',
  duration: '30–60 min',
  level: 'Beginner–Intermediate',
  description: 'Improve endurance and burn fat with cardio.',
  structure:
      'Endurance Cardio → Lower Body Cardio → Rest → Full Body Cardio → Rest → Rest → Rest',
  restDays: '2-3 days per week',
  expectation:
      'Build cardiovascular endurance while burning fat. Perfect for those who enjoy steady-state cardio.',
  weeklyRules: [
    DayRule(
      muscles: ['FULL_BODY'],
      categories: ['CARDIO'],
      types: ['ENDURANCE'],
    ),
    DayRule(
      muscles: ['LOWER_BODY'],
      categories: ['CARDIO'],
      types: ['ENDURANCE'],
    ),
    null,
    DayRule(
      muscles: ['FULL_BODY'],
      categories: ['CARDIO'],
      types: ['ENDURANCE'],
    ),
    null,
    null,
    null,
  ],
);

/// ---------------- MUSCLE BUILDING ----------------

final fullBodyBeginnerPlan = PlanDefinition(
  id: 'muscle_1',
  name: 'Beginner Muscle Building (Full Body)',
  totalDays: 30,
  frequency: '3 days/week',
  duration: '45–60 min',
  level: 'Beginner',
  description: 'Build strength using compound lifts.',
  structure:
      'Full Body Compound → Rest → Full Body Compound → Rest → Full Body Compound → Rest → Rest',
  restDays: '4 days per week',
  expectation:
      'Learn proper form on compound lifts while building foundational strength. Rest days are crucial for recovery.',
  weeklyRules: [
    DayRule(
      muscles: ['FULL_BODY'],
      categories: ['FREE_WEIGHT'],
      types: ['COMPOUND'],
    ),
    null,
    DayRule(
      muscles: ['FULL_BODY'],
      categories: ['FREE_WEIGHT'],
      types: ['COMPOUND'],
    ),
    null,
    DayRule(
      muscles: ['FULL_BODY'],
      categories: ['FREE_WEIGHT'],
      types: ['COMPOUND'],
    ),
    null,
    null,
  ],
);

final pplPlan = PlanDefinition(
  id: 'muscle_2',
  name: 'Push Pull Legs (PPL)',
  totalDays: 30,
  frequency: '6 days/week',
  duration: '60–75 min',
  level: 'Intermediate',
  description: 'Classic hypertrophy split.',
  structure:
      'Push (Chest/Shoulders/Triceps) → Pull (Back/Biceps) → Legs → Rest → Rest → Rest → Rest',
  restDays: '1 day per week (after 3-day cycle)',
  expectation:
      'Target specific muscle groups with high frequency. Great for intermediate lifters seeking hypertrophy.',
  weeklyRules: [
    DayRule(
      muscles: ['CHEST', 'SHOULDERS', 'TRICEPS'],
      categories: ['FREE_WEIGHT'],
      types: ['COMPOUND'],
    ),
    DayRule(
      muscles: ['BACK', 'BICEPS'],
      categories: ['FREE_WEIGHT'],
      types: ['COMPOUND'],
    ),
    DayRule(
      muscles: ['LEGS'],
      categories: ['FREE_WEIGHT'],
      types: ['COMPOUND'],
    ),
    null,
    null,
    null,
    null,
  ],
);

final broSplitPlan = PlanDefinition(
  id: 'muscle_3',
  name: 'Bro Split Bodybuilding',
  totalDays: 30,
  frequency: '5 days/week',
  duration: '60–75 min',
  level: 'Advanced',
  description: 'One muscle group per day.',
  structure: 'Chest → Back → Shoulders → Arms → Legs → Rest → Rest',
  restDays: '2 days per week (weekend)',
  expectation:
      'Maximize muscle isolation and volume per muscle group. Requires good recovery and nutrition.',
  weeklyRules: [
    DayRule(
      muscles: ['CHEST'],
      categories: ['FREE_WEIGHT'],
      types: ['ISOLATION'],
    ),
    DayRule(
      muscles: ['BACK'],
      categories: ['FREE_WEIGHT'],
      types: ['ISOLATION'],
    ),
    DayRule(
      muscles: ['SHOULDERS'],
      categories: ['FREE_WEIGHT'],
      types: ['ISOLATION'],
    ),
    DayRule(
      muscles: ['ARMS'],
      categories: ['FREE_WEIGHT'],
      types: ['ISOLATION'],
    ),
    DayRule(
      muscles: ['LEGS'],
      categories: ['FREE_WEIGHT'],
      types: ['ISOLATION'],
    ),
    null,
    null,
  ],
);

/// ---------------- CHALLENGES ----------------

final twentyOneDayFatLossChallenge = PlanDefinition(
  id: 'challenge_1',
  name: '21-Day Fat Loss Challenge',
  totalDays: 21,
  isChallenge: true,
  frequency: '4-5 days/week',
  duration: '20–35 min',
  level: 'Intermediate',
  description: 'Intensive 3-week fat loss program',
  structure:
      'Full Body HIIT → Core → Rest → Lower Body HIIT → Upper Body Circuit → Rest → Rest',
  restDays: '2-3 days per week',
  expectation:
      'Intense 3-week transformation focusing on fat loss. Push your limits with mixed training styles.',
  weeklyRules: [
    DayRule(
      muscles: ['FULL_BODY'],
      categories: ['BODYWEIGHT'],
      types: ['HIIT'],
    ),
    DayRule(muscles: ['CORE'], categories: ['BODYWEIGHT'], types: ['CORE']),
    null,
    DayRule(
      muscles: ['LOWER_BODY'],
      categories: ['BODYWEIGHT'],
      types: ['HIIT'],
    ),
    DayRule(
      muscles: ['UPPER_BODY'],
      categories: ['BODYWEIGHT'],
      types: ['CIRCUIT'],
    ),
    null,
    null,
  ],
);

final hundredPushupChallengePlan = PlanDefinition(
  id: 'challenge_2',
  name: '100 Push-up Challenge',
  totalDays: 30,
  isChallenge: true,
  frequency: '3 days/week',
  duration: '15–30 min',
  level: 'Beginner–Intermediate',
  description: 'Build up to 100 push-ups in 30 days',
  structure:
      'Push-up Endurance → Rest → Push-up Strength → Rest → Push-up Volume → Rest → Rest',
  restDays: '4 days per week',
  expectation:
      'Gradually increase push-up capacity through progressive overload. Rest days are essential for muscle recovery.',
  weeklyRules: [
    DayRule(
      muscles: ['CHEST', 'TRICEPS', 'SHOULDERS'],
      categories: ['BODYWEIGHT'],
      types: ['ENDURANCE'],
    ),
    null,
    DayRule(
      muscles: ['CHEST', 'TRICEPS'],
      categories: ['BODYWEIGHT'],
      types: ['ENDURANCE'],
    ),
    null,
    DayRule(
      muscles: ['CHEST', 'TRICEPS'],
      categories: ['BODYWEIGHT'],
      types: ['ENDURANCE'],
    ),
    null,
    null,
  ],
);
