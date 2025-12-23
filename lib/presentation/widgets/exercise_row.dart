import 'package:flutter/material.dart';

class ExerciseRow extends StatelessWidget {
  final String name;
  final String sets;
  final String reps;
  final bool isDone;

  const ExerciseRow({
    super.key,
    required this.name,
    required this.sets,
    required this.reps,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(value: isDone, onChanged: (value) {}),
        title: Text(name),
        subtitle: Text('$sets • $reps'),
        trailing: IconButton(
          icon: const Icon(Icons.expand_more),
          onPressed: () {},
        ),
      ),
    );
  }
}
