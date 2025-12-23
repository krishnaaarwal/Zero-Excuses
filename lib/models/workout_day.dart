//API REQUEST

class WorkoutDay {
  final int day;
  final List<String> muscles;
  final List<String> categories;
  final List<String> types;

  const WorkoutDay({
    required this.day,
    required this.muscles,
    required this.categories,
    required this.types,
  });
}
