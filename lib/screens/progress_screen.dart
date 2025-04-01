import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/exercise_provider.dart';
import '../providers/workout_provider.dart';
import '../constants/theme.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  Exercise? selectedExercise;

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: exercisesAsync.when(
              data: (exercises) => DropdownButtonFormField<Exercise>(
                decoration: const InputDecoration(
                  labelText: 'Select Exercise',
                  border: OutlineInputBorder(),
                ),
                value: selectedExercise,
                items: [
                  const DropdownMenuItem<Exercise>(
                    value: null,
                    child: Text('General Progress'),
                  ),
                  ...exercises.map(
                    (exercise) => DropdownMenuItem<Exercise>(
                      value: exercise,
                      child: Text(exercise.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedExercise = value;
                  });
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading exercises'),
            ),
          ),
          Expanded(
            child: selectedExercise == null
                ? const GeneralProgress()
                : ExerciseProgress(exercise: selectedExercise!),
          ),
        ],
      ),
    );
  }
}

class GeneralProgress extends ConsumerWidget {
  const GeneralProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, just show a placeholder
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'General progress metrics coming soon',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ],
      ),
    );
  }
}

class ExerciseProgress extends ConsumerWidget {
  final Exercise exercise;

  const ExerciseProgress({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutsByExerciseProvider(exercise.id!));

    return workoutsAsync.when(
      data: (workouts) {
        if (workouts.isEmpty) {
          return Center(
            child: Text(
              'No workouts logged for ${exercise.name}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weight Progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              workouts.length,
                              (index) => FlSpot(
                                index.toDouble(),
                                workouts[index].weight,
                              ),
                            ),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading workouts')),
    );
  }
} 