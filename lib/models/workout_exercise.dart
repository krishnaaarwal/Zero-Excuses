import 'package:workout_app/models/api_exercise.dart';

class WorkoutExercise {
  final ApiExercise exercise;
  final int sets;
  final String reps;
  final String rest;

  const WorkoutExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.rest,
  });
}
