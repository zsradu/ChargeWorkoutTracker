import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../providers/database_provider.dart';
import '../providers/workout_provider.dart';
import '../constants/theme.dart';

class ExerciseLoggingScreen extends ConsumerStatefulWidget {
  final Exercise exercise;
  final Workout? workout;

  const ExerciseLoggingScreen({
    super.key,
    required this.exercise,
    this.workout,
  });

  @override
  ConsumerState<ExerciseLoggingScreen> createState() =>
      _ExerciseLoggingScreenState();
}

class _ExerciseLoggingScreenState extends ConsumerState<ExerciseLoggingScreen> {
  late int sets;
  late int reps;
  late double weight;

  @override
  void initState() {
    super.initState();
    sets = widget.workout?.sets ?? 3;
    reps = widget.workout?.reps ?? 10;
    weight = widget.workout?.weight ?? 10.0;
  }

  Future<void> _saveWorkout() async {
    final selectedDate = ref.read(selectedDateProvider);
    final workout = Workout(
      id: widget.workout?.id,
      date: selectedDate,
      exerciseId: widget.exercise.id!,
      sets: sets,
      reps: reps,
      weight: weight,
    );

    final db = ref.read(databaseProvider);
    if (widget.workout != null) {
      await db.updateWorkout(workout);
    } else {
      await db.insertWorkout(workout);
    }

    ref.invalidate(workoutsByDateProvider(selectedDate));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Text(
                      widget.exercise.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      widget.exercise.muscleGroup,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    _buildNumberSelector(
                      label: 'Sets',
                      value: sets,
                      onChanged: (value) => setState(() => sets = value),
                    ),
                    const Divider(),
                    _buildNumberSelector(
                      label: 'Reps',
                      value: reps,
                      onChanged: (value) => setState(() => reps = value),
                    ),
                    const Divider(),
                    _buildWeightSelector(
                      label: 'Weight (kg)',
                      value: weight,
                      onChanged: (value) => setState(() => weight = value),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveWorkout,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(AppSpacing.md),
              ),
              child: Text(
                widget.workout != null ? 'Update Workout' : 'Log Workout',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberSelector({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
            ),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightSelector({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > 0
                  ? () => onChanged((value - 0.5).clamp(0, double.infinity))
                  : null,
            ),
            Text(
              value.toStringAsFixed(1),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(value + 0.5),
            ),
          ],
        ),
      ],
    );
  }
} 