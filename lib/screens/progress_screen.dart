import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/exercise_provider.dart';
import '../providers/workout_provider.dart';
import '../constants/theme.dart';
import '../models/exercise.dart';
import 'select_exercise_screen.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  Exercise? selectedExercise;

  @override
  void initState() {
    super.initState();
    // Refresh data when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(exercisesProvider);
    });
  }

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
              data: (exercises) => Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push<Exercise>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectExerciseScreen(
                              isProgressScreen: true,
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            selectedExercise = result;
                          });
                          // Refresh workout data for the selected exercise
                          ref.invalidate(workoutsByExerciseProvider(result.id!));
                        }
                      },
                      icon: const Icon(Icons.fitness_center),
                      label: Text(
                        selectedExercise?.name ?? 'Select Exercise',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
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
    final exercisesAsync = ref.watch(exercisesProvider);

    return exercisesAsync.when(
      data: (exercises) {
        // if (exercises.isEmpty) {
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
                  'No exercises logged yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ],
            ),
          );
        // }

          /*
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return Card(
              child: ListTile(
                title: Text(exercise.name),
                subtitle: Text(exercise.muscleGroup),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseProgressScreen(exercise: exercise),
                    ),
                  );
                },
              ),
            );
          },
        );
        */
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading exercises')),
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

        // Calculate min and max values for the graph
        final minWeight = 0.0;
        final maxWeight = workouts.map((w) => w.weight).reduce((a, b) => a > b ? a : b);
        final maxReps = workouts.map((w) => w.reps).reduce((a, b) => a > b ? a : b);

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toStringAsFixed(0));
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= workouts.length) return const Text('');
                                final date = workouts[value.toInt()].date;
                                return Text('${date.day}/${date.month}');
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        minX: 0,
                        maxX: (workouts.length - 1).toDouble(),
                        minY: minWeight,
                        maxY: maxWeight > maxReps ? maxWeight : maxReps.toDouble(),
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
                          LineChartBarData(
                            spots: List.generate(
                              workouts.length,
                              (index) => FlSpot(
                                index.toDouble(),
                                workouts[index].reps.toDouble(),
                              ),
                            ),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.secondary,
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