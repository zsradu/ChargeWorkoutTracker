import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/database_provider.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../constants/theme.dart';

class WorkoutList extends ConsumerWidget {
  const WorkoutList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final workoutsAsync = ref.watch(workoutsByDateProvider(selectedDate));
    final exercisesAsync = ref.watch(exercisesProvider);

    return workoutsAsync.when(
      data: (workouts) {
        if (workouts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No workouts logged for this day',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return exercisesAsync.when(
              data: (exercises) {
                final exercise = exercises.firstWhere(
                  (e) => e.id == workout.exerciseId,
                  orElse: () => Exercise(
                    name: 'Unknown Exercise',
                    muscleGroup: 'Unknown',
                  ),
                );
                return WorkoutCard(workout: workout, exercise: exercise);
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading exercise'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading workouts')),
    );
  }
}

class WorkoutCard extends ConsumerWidget {
  final Workout workout;
  final Exercise exercise;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        exercise.muscleGroup,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implement edit functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Workout'),
                            content: const Text(
                              'Are you sure you want to delete this workout?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await ref
                              .read(databaseProvider)
                              .deleteWorkout(workout.id!);
                          ref.refresh(workoutsByDateProvider(workout.date));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${workout.sets} sets × ${workout.reps} reps @ ${workout.weight}kg',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
} 