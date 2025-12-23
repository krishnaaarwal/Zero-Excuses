import 'dart:async';

import 'package:flutter/material.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  int currentExerciseIndex = 0;
  int currentSet = 1;
  final int totalSets = 4;
  final List<bool> setsCompleted = [false, false, false, false];

  bool isTimerRunning = false;
  int timerSeconds = 0;
  Timer? timer;

  final List<Map<String, dynamic>> exercises = [
    {'name': 'Bench Press', 'muscleGroup': 'Chest', 'sets': 4, 'reps': '8-10'},
    {
      'name': 'Incline Dumbbell Press',
      'muscleGroup': 'Chest',
      'sets': 3,
      'reps': '10-12',
    },
    {'name': 'Cable Flyes', 'muscleGroup': 'Chest', 'sets': 3, 'reps': '12-15'},
  ];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void toggleTimer() {
    setState(() {
      if (isTimerRunning) {
        timer?.cancel();
        isTimerRunning = false;
      } else {
        isTimerRunning = true;
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            timerSeconds++;
          });
        });
      }
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isTimerRunning = false;
      timerSeconds = 0;
    });
  }

  String formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void nextExercise() {
    if (currentExerciseIndex < exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
        currentSet = 1;
        setsCompleted.fillRange(0, setsCompleted.length, false);
        resetTimer();
      });
    }
  }

  void previousExercise() {
    if (currentExerciseIndex > 0) {
      setState(() {
        currentExerciseIndex--;
        currentSet = 1;
        setsCompleted.fillRange(0, setsCompleted.length, false);
        resetTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final exercise = exercises[currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercise ${currentExerciseIndex + 1} of ${exercises.length}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentExerciseIndex + 1) / exercises.length,
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Exercise Info
                  Text(
                    exercise['name'],
                    style: theme.textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        exercise['muscleGroup'].toString().toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Exercise Image Placeholder
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.fitness_center,
                        size: 80,
                        color: colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Timer
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text('Rest Timer', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Text(
                          formatTime(timerSeconds),
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: toggleTimer,
                              icon: Icon(
                                isTimerRunning ? Icons.pause : Icons.play_arrow,
                              ),
                              label: Text(isTimerRunning ? 'Pause' : 'Start'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: resetTimer,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sets Tracker
                  Text('Sets & Reps', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ...List.generate(totalSets, (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: setsCompleted[index]
                            ? colorScheme.tertiary.withOpacity(0.2)
                            : null,
                        child: CheckboxListTile(
                          title: Text('Set ${index + 1}'),
                          subtitle: Text('${exercise['reps']} reps'),
                          value: setsCompleted[index],
                          onChanged: (bool? value) {
                            setState(() {
                              setsCompleted[index] = value ?? false;
                            });
                          },
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: setsCompleted[index]
                                  ? colorScheme.tertiary
                                  : colorScheme.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${index + 1}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: setsCompleted[index]
                                    ? Colors.white
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: currentExerciseIndex > 0
                        ? previousExercise
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentExerciseIndex < exercises.length - 1
                        ? nextExercise
                        : () => Navigator.pop(context),
                    icon: Icon(
                      currentExerciseIndex < exercises.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                    ),
                    label: Text(
                      currentExerciseIndex < exercises.length - 1
                          ? 'Next'
                          : 'Finish',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
